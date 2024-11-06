import { Component, OnInit, inject } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { ILoginResponse } from '../../interfaces/ILoginResponse';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss'],
})
export class NavbarComponent implements OnInit {
  userName: string | null = null;
  userLogged: boolean = false;
  loading: boolean = true; 
  authService = inject(AuthService);

  ngOnInit() {
    this.authService.getUserLogged().subscribe((user: ILoginResponse | null) => {
      this.userName = user ? user.userName : null;
      this.userLogged = !!user; 
      this.loading = false; 
    });
  }

  onSairClick() {
    this.authService.logout();
    this.userLogged = false;
  }
}
