import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  constructor(private http: HttpClient) {}
  title = 'frontend';


  ngOnInit() {
    // Make a dummy HTTP GET request to a public API
    this.http.get('https://jsonplaceholder.typicode.com/posts/1').subscribe(
      (response) => console.log('API Response:', response),
      (error) => console.error('API Error:', error)
    );
  }
}
