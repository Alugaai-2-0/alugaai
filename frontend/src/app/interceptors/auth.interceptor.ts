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
    console.log('Intercepted request:', req);

    // Clone the request to add a custom header (e.g., Authorization)
    const clonedRequest = req.clone({
      headers: req.headers.set('Authorization', 'Bearer dummy-token'),
    });

    console.log('Modified request:', clonedRequest);

    // Pass the cloned request to the next handler and log the response
    return next.handle(clonedRequest).pipe(
      tap(
        (event) => console.log('Response received:', event),
        (error) => console.error('Request error:', error)
      )
    );
  }
}
