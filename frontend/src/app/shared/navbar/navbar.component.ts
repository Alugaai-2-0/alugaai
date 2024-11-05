import { Component, inject, OnInit } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { ILoginResponse } from '../../interfaces/ILoginResponse';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.scss'
})
export class NavbarComponent implements OnInit {
  userName: string | null = null;
  authService = inject(AuthService)

  ngOnInit() {
    this.authService.getUserLogged().subscribe((user: ILoginResponse | null) => {
      this.userName = user ? user.userName : null;
    });
  }

  onSairClick(){
    this.authService.logout()
  }

}
