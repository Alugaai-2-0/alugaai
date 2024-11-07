import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
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
      identifier: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required],
    });

    const today = new Date();
    const minAgeDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
    this.maxDate = minAgeDate.toISOString().split('T')[0];
  }

}
