export interface ILoginResponse{
    token: string;
    roles: string[];
    email: string;
    userName: string;
    phoneNumber: string;
    birthDate: Date;
    gender: string; // or 'M' | 'F' if it's a male/female character
    cpf: string;
    phoneNumberConfirmed: boolean;
    twoFactorEnabled: boolean;
    createdDate: Date;
    
 }