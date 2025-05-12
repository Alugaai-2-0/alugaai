package com.alugaai.backend.resources;


import com.alugaai.backend.dtos.connections.ConnectionRequestDTO;
import com.alugaai.backend.dtos.connections.ConnectionResponseDTO;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.StudentConnection;
import com.alugaai.backend.services.StudentConnectionService;
import com.alugaai.backend.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/connections")
@PreAuthorize("hasRole('STUDENT')")
@RequiredArgsConstructor
public class StudentConnectionsResource {

    private final StudentConnectionService connectionService;
    private final UserService userService;

    @PostMapping("/request")
    public ResponseEntity<ConnectionResponseDTO> sendConnectionRequest(
            @RequestBody ConnectionRequestDTO requestDTO) {
        StudentConnection connection = connectionService.sendConnectionRequest(requestDTO.getAddresseeId());
        return ResponseEntity.status(HttpStatus.CREATED).body(convertToDTO(connection));
    }

    @PutMapping("/{connectionId}/accept")
    public ResponseEntity<ConnectionResponseDTO> acceptConnection(@PathVariable Integer connectionId) {
        Student currentStudent = (Student) userService.getCurrentUser();
        StudentConnection connection = connectionService.acceptConnectionRequest(connectionId, currentStudent.getId());
        return ResponseEntity.ok(convertToDTO(connection));
    }

    @PutMapping("/{connectionId}/reject")
    public ResponseEntity<ConnectionResponseDTO> rejectConnection(@PathVariable Integer connectionId) {
        Student currentStudent = (Student) userService.getCurrentUser();
        StudentConnection connection = connectionService.rejectConnectionRequest(connectionId, currentStudent.getId());
        return ResponseEntity.ok(convertToDTO(connection));
    }

    @DeleteMapping("/{studentId}")
    public ResponseEntity<Void> removeConnection(@PathVariable Integer studentId) {
        Student currentStudent = (Student) userService.getCurrentUser();
        connectionService.removeConnection(currentStudent.getId(), studentId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/my-connections")
    public ResponseEntity<List<ConnectionResponseDTO>> getMyConnections() {
        Student currentStudent = (Student) userService.getCurrentUser();
        List<Student> connections = connectionService.getConnections(currentStudent.getId());

        List<ConnectionResponseDTO> responseDTOs = connections.stream()
                .map(student -> {
                    ConnectionResponseDTO dto = new ConnectionResponseDTO();
                    dto.setId(null);
                    dto.setStudentId(student.getId());
                    dto.setStudentName(student.getUsername());
                    dto.setStatus("ACCEPTED");
                    return dto;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(responseDTOs);
    }

    @GetMapping("/pending-received")
    public ResponseEntity<List<ConnectionResponseDTO>> getPendingReceivedRequests() {
        Student currentStudent = (Student) userService.getCurrentUser();
        List<StudentConnection> pendingRequests = connectionService.getPendingReceivedRequests(currentStudent.getId());
        List<ConnectionResponseDTO> responseDTOs = pendingRequests.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseDTOs);
    }

    @GetMapping("/pending-sent")
    public ResponseEntity<List<ConnectionResponseDTO>> getPendingSentRequests() {
        Student currentStudent = (Student) userService.getCurrentUser();
        List<StudentConnection> pendingRequests = connectionService.getPendingSentRequests(currentStudent.getId());
        List<ConnectionResponseDTO> responseDTOs = pendingRequests.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responseDTOs);
    }

    // Método auxiliar para converter entidade para DTO
    private ConnectionResponseDTO convertToDTO(StudentConnection connection) {
        ConnectionResponseDTO dto = new ConnectionResponseDTO();
        dto.setId(connection.getId());

        Student currentUser = (Student) userService.getCurrentUser();
        Student otherStudent;

        if (connection.getRequester().getId().equals(currentUser.getId())) {
            otherStudent = connection.getAddressee();
        } else {
            otherStudent = connection.getRequester();
        }

        dto.setStudentId(otherStudent.getId());
        dto.setStudentName(otherStudent.getUsername());
        dto.setStatus(connection.getStatus().toString());
        dto.setRequestDate(connection.getRequestDate());
        dto.setResponseDate(connection.getResponseDate());

        return dto;
    }
}