import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

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
  ) {}
 

  ngOnInit(): void {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required],
    });
  }

  
  onContinuarClick(){

    console.log("Email: ", this.loginForm.get('email')?.value);
    console.log("senha: ", this.loginForm.get('password')?.value);
    this.isEmailScreen = false;
  }


}
