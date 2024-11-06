import { Component, inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../../services/auth.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup = new FormGroup({});
  isEmailScreen: boolean = true;

  constructor(
    private fb: FormBuilder,
  ) { }

  authService = inject(AuthService)
  toastr = inject(ToastrService)
  router = inject(Router);


  ngOnInit(): void {
    this.loginForm = this.fb.group({
      identifier: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required],
    });


  }



  onContinuarClick() {
    this.isEmailScreen = false;
  }

  onArrowClick(){
    this.isEmailScreen = true;
  }
  onEntrarClick() {
    this.authService.login(this.loginForm.value).subscribe({
      next: (response) => {
        this.toastr.success(response.userName, "Logado com sucesso")
        this.router.navigate(['/home']);

      },
      error: (error) => {
       this.toastr.error( error.message, "Erro ao fazer login")
      },
      complete: () => {
      }
    })
  }


}
