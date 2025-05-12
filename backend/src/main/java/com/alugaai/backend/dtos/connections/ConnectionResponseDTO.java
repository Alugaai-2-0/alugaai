package com.alugaai.backend.dtos.connections;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ConnectionResponseDTO {
    private Integer id;
    private Integer studentId;
    private String studentName;
    private String status;
    private LocalDateTime requestDate;
    private LocalDateTime responseDate;
}