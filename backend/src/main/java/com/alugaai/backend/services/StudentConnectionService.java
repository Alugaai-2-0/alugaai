package com.alugaai.backend.services;

import com.alugaai.backend.models.ConnectionStatus;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.StudentConnection;
import com.alugaai.backend.repositories.StudentConnectionRepository;
import com.alugaai.backend.repositories.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudentConnectionService {

    private final StudentConnectionRepository connectionRepository;
    private final StudentRepository studentRepository;
    private final UserService userService;

    /**
     * Envia uma solicitação de conexão de um estudante para outro
     */
    @Transactional
    public StudentConnection sendConnectionRequest(Integer addresseeId) {
        // Obtém o estudante atual
        Student requester = (Student) userService.getCurrentUser();

        // Não permitir que um estudante se conecte a si mesmo
        if (requester.getId().equals(addresseeId)) {
            throw new IllegalArgumentException("Não é possível enviar solicitação para si mesmo");
        }

        // Verificar se o destinatário existe
        Student addressee = studentRepository.findById(addresseeId)
                .orElseThrow(() -> new RuntimeException("Estudante destinatário não encontrado"));

        // Verificar se já existe uma solicitação nesta direção
        Optional<StudentConnection> existingConnection = connectionRepository
                .findByRequesterIdAndAddresseeId(requester.getId(), addresseeId);

        if (existingConnection.isPresent()) {
            return existingConnection.get(); // Retorna a conexão existente
        }

        // Verificar se existe uma solicitação na direção oposta
        Optional<StudentConnection> reverseConnection = connectionRepository
                .findByRequesterIdAndAddresseeId(addresseeId, requester.getId());

        if (reverseConnection.isPresent()) {
            StudentConnection connection = reverseConnection.get();

            // Se a solicitação inversa estiver pendente, aceitamos automaticamente (match)
            if (connection.getStatus() == ConnectionStatus.PENDING) {
                connection.setStatus(ConnectionStatus.ACCEPTED);
                connection.setResponseDate(LocalDateTime.now());
                return connectionRepository.save(connection);
            } else if (connection.getStatus() == ConnectionStatus.REJECTED) {
                // Se a solicitação inversa foi rejeitada, talvez queiramos impedir novas solicitações
                // ou permitir após um período
                // Esta é uma decisão de negócio - aqui estou permitindo novas solicitações
            } else if (connection.getStatus() == ConnectionStatus.BLOCKED) {
                // Se o outro usuário bloqueou, não permitir novas solicitações
                throw new RuntimeException("Não é possível enviar solicitação para este estudante");
            }

            return connection; // Retorna a conexão existente na direção oposta
        }

        // Criar uma nova solicitação
        StudentConnection newConnection = new StudentConnection(requester, addressee);
        return connectionRepository.save(newConnection);
    }

    /**
     * Aceita uma solicitação de conexão
     */
    @Transactional
    public StudentConnection acceptConnectionRequest(Integer connectionId, Integer studentId) {
        StudentConnection connection = connectionRepository.findById(connectionId)
                .orElseThrow(() -> new RuntimeException("Solicitação de conexão não encontrada"));

        // Verificar se o estudante é o destinatário da solicitação
        if (!connection.getAddressee().getId().equals(studentId)) {
            throw new RuntimeException("Você não tem permissão para aceitar esta solicitação");
        }

        // Verificar se a solicitação está pendente
        if (connection.getStatus() != ConnectionStatus.PENDING) {
            throw new RuntimeException("Esta solicitação não está pendente");
        }

        connection.setStatus(ConnectionStatus.ACCEPTED);
        connection.setResponseDate(LocalDateTime.now());

        return connectionRepository.save(connection);
    }

    /**
     * Rejeita uma solicitação de conexão
     */
    @Transactional
    public StudentConnection rejectConnectionRequest(Integer connectionId, Integer studentId) {
        StudentConnection connection = connectionRepository.findById(connectionId)
                .orElseThrow(() -> new RuntimeException("Solicitação de conexão não encontrada"));

        // Verificar se o estudante é o destinatário da solicitação
        if (!connection.getAddressee().getId().equals(studentId)) {
            throw new RuntimeException("Você não tem permissão para rejeitar esta solicitação");
        }

        // Verificar se a solicitação está pendente
        if (connection.getStatus() != ConnectionStatus.PENDING) {
            throw new RuntimeException("Esta solicitação não está pendente");
        }

        connection.setStatus(ConnectionStatus.REJECTED);
        connection.setResponseDate(LocalDateTime.now());

        return connectionRepository.save(connection);
    }

    /**
     * Remove uma conexão entre estudantes
     */
    @Transactional
    public void removeConnection(Integer studentId, Integer otherStudentId) {
        // Procurar conexão em ambas direções
        Optional<StudentConnection> connection = connectionRepository
                .findByRequesterIdAndAddresseeId(studentId, otherStudentId);

        if (connection.isPresent() &&
                connection.get().getStatus() == ConnectionStatus.ACCEPTED) {
            connectionRepository.delete(connection.get());
            return;
        }

        Optional<StudentConnection> reverseConnection = connectionRepository
                .findByRequesterIdAndAddresseeId(otherStudentId, studentId);

        if (reverseConnection.isPresent() &&
                reverseConnection.get().getStatus() == ConnectionStatus.ACCEPTED) {
            connectionRepository.delete(reverseConnection.get());
            return;
        }

        throw new RuntimeException("Conexão não encontrada");
    }

    /**
     * Obtém todas as conexões aceitas de um estudante
     */
    public List<Student> getConnections(Integer studentId) {
        List<Student> connections = new ArrayList<>();

        // Buscar conexões onde o estudante é o solicitante
        List<StudentConnection> sentConnections = connectionRepository
                .findByRequesterIdAndStatus(studentId, ConnectionStatus.ACCEPTED);

        // Adicionar os destinatários dessas conexões
        List<Student> sentConnectionStudents = sentConnections.stream()
                .map(StudentConnection::getAddressee)
                .collect(Collectors.toList());
        connections.addAll(sentConnectionStudents);

        // Buscar conexões onde o estudante é o destinatário
        List<StudentConnection> receivedConnections = connectionRepository
                .findByAddresseeIdAndStatus(studentId, ConnectionStatus.ACCEPTED);

        // Adicionar os solicitantes dessas conexões
        List<Student> receivedConnectionStudents = receivedConnections.stream()
                .map(StudentConnection::getRequester)
                .collect(Collectors.toList());
        connections.addAll(receivedConnectionStudents);

        return connections;
    }

    /**
     * Obtém todas as solicitações pendentes recebidas por um estudante
     */
    public List<StudentConnection> getPendingReceivedRequests(Integer studentId) {
        return connectionRepository.findByAddresseeIdAndStatus(studentId, ConnectionStatus.PENDING);
    }

    /**
     * Obtém todas as solicitações pendentes enviadas por um estudante
     */
    public List<StudentConnection> getPendingSentRequests(Integer studentId) {
        return connectionRepository.findByRequesterIdAndStatus(studentId, ConnectionStatus.PENDING);
    }

    /**
     * Verifica se dois estudantes estão conectados
     */
    public boolean areConnected(Integer student1Id, Integer student2Id) {
        // Verificar conexão em ambas as direções
        boolean connection1 = connectionRepository
                .findByRequesterIdAndAddresseeId(student1Id, student2Id)
                .map(conn -> conn.getStatus() == ConnectionStatus.ACCEPTED)
                .orElse(false);

        if (connection1) {
            return true;
        }

        boolean connection2 = connectionRepository
                .findByRequesterIdAndAddresseeId(student2Id, student1Id)
                .map(conn -> conn.getStatus() == ConnectionStatus.ACCEPTED)
                .orElse(false);

        return connection2;
    }

    /**
     * Bloqueia um estudante (impede futuras solicitações)
     */
    @Transactional
    public StudentConnection blockStudent(Integer studentToBlockId) {
        Student currentStudent = (Student) userService.getCurrentUser();
        Student studentToBlock = studentRepository.findById(studentToBlockId)
                .orElseThrow(() -> new RuntimeException("Estudante a ser bloqueado não encontrado"));

        // Primeiro, remover qualquer conexão existente
        try {
            removeConnection(currentStudent.getId(), studentToBlockId);
        } catch (RuntimeException e) {
            // Ignora se não houver conexão existente
        }

        // Verificar se já existe um bloqueio
        Optional<StudentConnection> existingBlock = connectionRepository
                .findByRequesterIdAndAddresseeId(currentStudent.getId(), studentToBlockId);

        if (existingBlock.isPresent()) {
            StudentConnection block = existingBlock.get();
            block.setStatus(ConnectionStatus.BLOCKED);
            return connectionRepository.save(block);
        }

        // Criar novo bloqueio
        StudentConnection block = new StudentConnection(currentStudent, studentToBlock);
        block.setStatus(ConnectionStatus.BLOCKED);
        return connectionRepository.save(block);
    }
}