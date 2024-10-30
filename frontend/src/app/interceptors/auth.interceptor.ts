// src/app/interceptors/auth.interceptor.ts
import { Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
   
    // Clone the request to add a custom header (e.g., Authorization)
    const clonedRequest = req.clone({
      headers: req.headers.set('Authorization', 'Bearer dummy-token'),
    });

  
    // Pass the cloned request to the next handler and log the response
    return next.handle(clonedRequest).pipe(
      tap(
      )
    );
  }
}
