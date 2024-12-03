import { Injectable } from '@angular/core';
import { environment } from '../enviroment/enviroment';
import { HttpClient } from '@angular/common/http';
import { IPropertyResponse } from '../interfaces/IPropertyResponse';

@Injectable({
  providedIn: 'root'
})
export class PropertyService {

  baseUrl: string = environment.apiUrl;

  constructor(private http: HttpClient) { 
  }

  getProperties() {
    return this.http.get<IPropertyResponse[]>(this.baseUrl + 'property');
  }
}
