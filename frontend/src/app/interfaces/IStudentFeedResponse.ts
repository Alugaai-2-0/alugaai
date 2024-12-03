export interface IStudentFeedResponse{
    id: number;
    userName: string;
    birthDate: string; // Using string for LocalDateTime representation
    personalities: Set<string>; 
}