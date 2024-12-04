import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { environment } from '../enviroment/enviroment';
import { IStudentFeedResponse } from '../interfaces/IStudentFeedResponse';

@Injectable({
  providedIn: 'root'
})
export class StudentService {
  baseUrl: string = environment.apiUrl;

  //filter
  private filtersSubject = new BehaviorSubject<string[]>([]);
  filters$ = this.filtersSubject.asObservable();

  updateFilters(newFilters: string[]): void {
    this.filtersSubject.next(newFilters);
  }
//filter

  constructor(private http: HttpClient) { }

  getStudents(minAge?: number, maxAge?: number, personalities?: string[]) {
    let params = new HttpParams();
  
    if (minAge) {
      params = params.append('minAge', minAge.toString());
    }
    if (maxAge) {
      params = params.append('maxAge', maxAge.toString());
    }
    if (personalities && personalities.length > 0) {
      params = params.append('personalities', personalities.join(',')); // Join the array into a comma-separated string
    }
  
    return this.http.get<IStudentFeedResponse[]>(this.baseUrl + 'student/get-all', { params });
  }
}
