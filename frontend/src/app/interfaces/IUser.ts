export interface IUser{
    description: string;
    name: string;
    age: number;
    school: string;
    profileImage: string;
    tags: { name: string; color?: string }[];
}