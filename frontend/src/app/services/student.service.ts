import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../enviroment/enviroment';
import { IStudentFeedResponse } from '../interfaces/IStudentFeedResponse';

@Injectable({
  providedIn: 'root'
})
export class StudentService {
  baseUrl: string = environment.apiUrl;

  constructor(private http: HttpClient) { }

  getStudents() {
    return this.http.get<IStudentFeedResponse[]>(this.baseUrl + 'student/get-all');
   
  }
}
