import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, MinLengthValidator, Validators } from '@angular/forms';
import { AuthService } from '../../../services/auth.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';


@Component({
  selector: 'app-register-owner',
  templateUrl: './register-owner.component.html',
  styleUrl: './register-owner.component.scss'
})
export class RegisterOwnerComponent {

  ownerForm: FormGroup = new FormGroup({});

  constructor(
    private fb: FormBuilder,
  ) { }

  authService = inject(AuthService)
  toastr = inject(ToastrService)
  router = inject(Router);
  maxDate!: string;


  ngOnInit(): void {
    this.ownerForm = this.fb.group({
      username: ['', Validators.required],
      identifier: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(8)]],
      confirmPassword: ['', [Validators.required, Validators.minLength(8)]],
      gender: ['', Validators.required],
      birthDate: ['', Validators.required],
      phoneNumber: ['', Validators.required],
      
    });

    const today = new Date();
    const minAgeDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
    this.maxDate = minAgeDate.toISOString().split('T')[0];
  }

  onRegistrarClick(){
    if(this.ownerForm.valid){
      console.log(this.ownerForm.value);
    }
    console.log("Form not valid");
    
  }

  //getters

  get username() {
    return this.ownerForm.get('username');
  }

  get identifier() {
    return this.ownerForm.get('identifier');
  }

  get password() {
    return this.ownerForm.get('password');
  }

  get confirmPassword() {
    return this.ownerForm.get('confirmPassword');
  }

  get gender() {
    return this.ownerForm.get('gender');
  }

  get birthDate() {
    return this.ownerForm.get('birthDate');
  }

  get phoneNumber() {
    return this.ownerForm.get('phoneNumber');
  }
  

}
