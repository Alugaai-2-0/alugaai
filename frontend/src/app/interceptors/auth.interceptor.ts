import { Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
} from '@angular/common/http';
import { Observable, switchMap, take } from 'rxjs';
import { AuthService } from '../services/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private authService: AuthService) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    return this.authService.userLoggedToken$.pipe(
      take(1),
      switchMap((userLogged) => {
        if (userLogged) {
          req = req.clone({
            setHeaders: {
              Authorization: `Bearer ${userLogged.token}`,
            },
          });
        }
        return next.handle(req);
      })
    );
  }
  
}