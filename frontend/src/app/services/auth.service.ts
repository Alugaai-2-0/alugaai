import { Injectable } from '@angular/core';
import { environment } from '../enviroment/enviroment';
import { ILogin } from '../interfaces/ILogin';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, map } from 'rxjs';
import { ILoginResponse } from '../interfaces/ILoginResponse';


@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private userLogged = new BehaviorSubject<ILoginResponse | null>(null);
  baseUrl: string = environment.apiUrl;


  constructor(private http: HttpClient) { 
    if (typeof localStorage !== 'undefined') {
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      this.userLogged.next(JSON.parse(storedUser) as ILoginResponse);
    }
  }
  }

  getUserLogged() {
    return this.userLogged.asObservable();
  }

  
  setUserLogged(userToken: ILoginResponse) {
    this.userLogged.next(userToken);
  }

  logout() {
    this.userLogged.next(null);
    localStorage.clear();
  }

  login(loginBody: ILogin) {
    return this.http.post<any>(this.baseUrl + 'auth/login', loginBody).pipe(
      map((response: ILoginResponse) => {
        if (response) {
          localStorage.setItem('user', JSON.stringify(response));
          this.setUserLogged(response);
        }
        return response;
      })
    );
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('user');
  }

}
