package com.alugaai.backend.dtos.image;

import jakarta.validation.constraints.NotNull;

public record ImageRequestDTO(
        @NotNull String imageData64
) {
    public byte[] toByteArray() {
        if (imageData64 == null) return null;

        String cleanHex = imageData64.replaceAll("\\s+", "")
                .replaceAll("0x", "")
                .replaceAll(",", "");

        int len = cleanHex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(cleanHex.charAt(i), 16) << 4)
                    + Character.digit(cleanHex.charAt(i + 1), 16));
        }
        return data;
    }
}
