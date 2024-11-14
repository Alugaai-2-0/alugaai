import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../enviroment/enviroment';
import { Observable } from 'rxjs';
import { ICollegeResponse } from '../interfaces/ICollegeResponse';

@Injectable({
  providedIn: 'root'
})
export class CollegeService {

  baseUrl: string = environment.apiUrl;

  constructor(private http: HttpClient) { 
  }

  getColleges() {
    return this.http.get(this.baseUrl + 'college');
  }

}
