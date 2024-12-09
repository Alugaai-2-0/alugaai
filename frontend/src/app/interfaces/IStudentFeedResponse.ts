import { IImageResponseDTO } from "./IImageResponse";

export interface IStudentFeedResponse{
    id: number;
    userName: string;
    birthDate: string; 
    description: string;
    image: IImageResponseDTO;
    personalities: Set<string> 
}