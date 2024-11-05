import { Component, inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ILogin } from '../../../interfaces/ILogin';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup = new FormGroup({});
  isEmailScreen: boolean = true;

  mockLogin: ILogin = {
    identifier: 'admin@alugaai.com',
    password: 'admin123'
  };

  constructor(
    private fb: FormBuilder,
  ) {}

  authService = inject(AuthService)
 

  ngOnInit(): void {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required],
    });

    this.authService.login(this.mockLogin).subscribe({
      next: (response) =>{
       
      },
      error: (error) => {
        
      },
      complete: () => {
      }
    })
  }




 

  
  onContinuarClick(){

    console.log("Email: ", this.loginForm.get('email')?.value);
    console.log("senha: ", this.loginForm.get('password')?.value);
    this.isEmailScreen = false;
  }


}
