package com.alugaai.backend.repositories.seeder;

import com.alugaai.backend.models.ConnectionStatus;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.StudentConnection;
import com.alugaai.backend.repositories.StudentConnectionRepository;
import com.alugaai.backend.repositories.StudentRepository;
import com.alugaai.backend.repositories.UserRepository;
import com.alugaai.backend.repositories.seeder.base.BaseSeeder;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@Order(3)
public class StudentConnectionSeeder extends BaseSeeder {

    private final StudentConnectionRepository connectionRepository;
    private final StudentRepository studentRepository;

    public StudentConnectionSeeder(
            StudentConnectionRepository connectionRepository,
            StudentRepository studentRepository) {
        this.connectionRepository = connectionRepository;
        this.studentRepository = studentRepository;
    }

    @Override
    protected void seed() {
        // Verifica se já existem conexões no banco
        if (connectionRepository.count() > 0) {
            return;
        }

        // Busca todos os estudantes criados pelo UserSeeder
        List<Student> students = studentRepository.findAll();

        if (students.size() < 2) {
            return;
        }

        // Para facilitar o acesso aos estudantes por nome
        Student joaoAntonio = findStudentByName(students, "João Antonio");
        Student mariaFreita = findStudentByName(students, "Maria Freita");
        Student florentinaSouza = findStudentByName(students, "Florentina Souza");
        Student gustavoRibeiro = findStudentByName(students, "Gustavo Ribeiro");
        Student carlosVieira = findStudentByName(students, "Carlos Vieira");
        Student humbertoOliveira = findStudentByName(students, "Humberto Oliveira");
        Student anaRamalho = findStudentByName(students, "Ana Ramalho");

        // 1. Conexões aceitas (matches)
        // João e Maria são amigos
        createAcceptedConnection(joaoAntonio, mariaFreita,
                LocalDateTime.now().minusDays(30),
                LocalDateTime.now().minusDays(29));

        // João e Carlos são amigos
        createAcceptedConnection(joaoAntonio, carlosVieira,
                LocalDateTime.now().minusDays(25),
                LocalDateTime.now().minusDays(24));

        // Maria e Ana são amigas
        createAcceptedConnection(mariaFreita, anaRamalho,
                LocalDateTime.now().minusDays(20),
                LocalDateTime.now().minusDays(19));

        // Florentina e Gustavo são amigos (mesma faculdade)
        createAcceptedConnection(florentinaSouza, gustavoRibeiro,
                LocalDateTime.now().minusDays(15),
                LocalDateTime.now().minusDays(14));

        // Ana e Gustavo são amigos (conexão entre faculdades diferentes)
        createAcceptedConnection(anaRamalho, gustavoRibeiro,
                LocalDateTime.now().minusDays(10),
                LocalDateTime.now().minusDays(9));

        // 2. Solicitações pendentes
        // João enviou solicitação para Gustavo
        createPendingConnection(joaoAntonio, gustavoRibeiro,
                LocalDateTime.now().minusDays(5));

        // Maria enviou solicitação para Florentina
        createPendingConnection(mariaFreita, florentinaSouza,
                LocalDateTime.now().minusDays(4));

        // Carlos enviou solicitação para Humberto
        createPendingConnection(carlosVieira, humbertoOliveira,
                LocalDateTime.now().minusDays(3));

        // 3. Solicitações rejeitadas
        // Florentina rejeitou solicitação de Carlos
        createRejectedConnection(carlosVieira, florentinaSouza,
                LocalDateTime.now().minusDays(8),
                LocalDateTime.now().minusDays(7));

        // João rejeitou solicitação de Humberto
        createRejectedConnection(humbertoOliveira, joaoAntonio,
                LocalDateTime.now().minusDays(12),
                LocalDateTime.now().minusDays(11));

        // 4. Bloqueios
        // Ana bloqueou Humberto
        createBlockedConnection(anaRamalho, humbertoOliveira,
                LocalDateTime.now().minusDays(18));

        // Gustavo bloqueou Carlos
        createBlockedConnection(gustavoRibeiro, carlosVieira,
                LocalDateTime.now().minusDays(16));

    }

    private Student findStudentByName(List<Student> students, String name) {
        return students.stream()
                .filter(student -> student.getUsername().equals(name))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Estudante " + name + " não encontrado"));
    }

    private void createAcceptedConnection(Student requester, Student addressee,
                                          LocalDateTime requestDate, LocalDateTime responseDate) {
        StudentConnection connection = new StudentConnection(requester, addressee);
        connection.setStatus(ConnectionStatus.ACCEPTED);
        connection.setRequestDate(requestDate);
        connection.setResponseDate(responseDate);
        connectionRepository.save(connection);
    }

    private void createPendingConnection(Student requester, Student addressee,
                                         LocalDateTime requestDate) {
        StudentConnection connection = new StudentConnection(requester, addressee);
        connection.setStatus(ConnectionStatus.PENDING);
        connection.setRequestDate(requestDate);
        connectionRepository.save(connection);
    }

    private void createRejectedConnection(Student requester, Student addressee,
                                          LocalDateTime requestDate, LocalDateTime responseDate) {
        StudentConnection connection = new StudentConnection(requester, addressee);
        connection.setStatus(ConnectionStatus.REJECTED);
        connection.setRequestDate(requestDate);
        connection.setResponseDate(responseDate);
        connectionRepository.save(connection);
    }

    private void createBlockedConnection(Student blocker, Student blocked,
                                         LocalDateTime blockDate) {
        StudentConnection connection = new StudentConnection(blocker, blocked);
        connection.setStatus(ConnectionStatus.BLOCKED);
        connection.setRequestDate(blockDate);
        connectionRepository.save(connection);
    }
}