import { IImageResponseDTO } from "./IImageResponse";

export interface IOwnerForPropertyResponse{
    id: number;
    userName: string;
    gender: string; 
    phoneNumber: string;
    image: IImageResponseDTO;
}