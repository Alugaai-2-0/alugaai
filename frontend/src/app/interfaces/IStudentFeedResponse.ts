import { IImageResponseDTO } from "./IImageResponse";

export interface IStudentFeedResponse{
    id: number;
    userName: string;
    birthDate: string; // Using string for LocalDateTime representation
    description: string;
    image: IImageResponseDTO;
    personalities: Set<string> 
}