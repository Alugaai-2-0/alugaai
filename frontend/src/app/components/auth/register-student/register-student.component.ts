
import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../../services/auth.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';


@Component({
  selector: 'app-register-student',
  templateUrl: './register-student.component.html',
  styleUrl: './register-student.component.scss'
})
export class RegisterStudentComponent {

  studentForm: FormGroup = new FormGroup({});

  constructor(
    private fb: FormBuilder,
  ) { }

  authService = inject(AuthService)
  toastr = inject(ToastrService)
  router = inject(Router);
  maxDate!: string;


  ngOnInit(): void {
    this.studentForm = this.fb.group({
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
    if(this.studentForm.valid){
      console.log(this.studentForm.value);
    }
    console.log("Form not valid");
    
  }

  //getters

  get username() {
    return this.studentForm.get('username');
  }

  get identifier() {
    return this.studentForm.get('identifier');
  }

  get password() {
    return this.studentForm.get('password');
  }

  get confirmPassword() {
    return this.studentForm.get('confirmPassword');
  }

  get gender() {
    return this.studentForm.get('gender');
  }

  get birthDate() {
    return this.studentForm.get('birthDate');
  }

  get phoneNumber() {
    return this.studentForm.get('phoneNumber');
  }
  
}
