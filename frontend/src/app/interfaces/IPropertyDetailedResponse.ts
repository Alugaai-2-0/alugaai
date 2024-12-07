import { IImageResponseDTO } from "./IImageResponse";
import { IOwnerForPropertyResponse } from "./IOwnerForPropertyResponse";

export interface IPropertyDetailedResponse{
id: number;
  address: string;
  homeNumber: string;
  homeComplement: string;
  neighborhood: string;
  district: string;
  latitude: string;
  longitude: string;
  owner: IOwnerForPropertyResponse;
  propertyImages: IImageResponseDTO[];
}