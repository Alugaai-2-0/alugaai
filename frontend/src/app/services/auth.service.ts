import { Injectable } from '@angular/core';
import { environment } from '../enviroment/enviroment';
import { ILogin } from '../interfaces/ILogin';
import { HttpClient } from '@angular/common/http';


@Injectable({
  providedIn: 'root'
})
export class AuthService {
  baseUrl: string = environment.apiUrl;


  constructor(private http: HttpClient) { }

  login(loginBody: ILogin) {
    return this.http.post<any>(this.baseUrl + 'auth/login', loginBody, { withCredentials: true })
  }

}
