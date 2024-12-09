export interface ILoginResponse{
    token: string;
    roles: string[];
    email: string;
    userName: string;
    phoneNumber: string;
    birthDate: Date;
    gender: string; 
    cpf: string;
    phoneNumberConfirmed: boolean;
    twoFactorEnabled: boolean;
    createdDate: Date;
    
 }