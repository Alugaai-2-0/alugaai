import { IImageResponseDTO } from "./IImageResponse";

export interface IOwnerForPropertyResponse{
    id: number;
    userName: string;
    gender: string; // Use `string` for a single character like 'M', 'F', etc.
    phoneNumber: string;
    image: IImageResponseDTO;
}