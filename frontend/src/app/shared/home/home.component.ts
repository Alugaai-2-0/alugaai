import { Component, inject, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent implements OnInit {

  toastService = inject(ToastrService);

  ngOnInit(): void {

  }

  onClick(){
    this.toastService.success("Atenção", "Destruindo o pc");
  }

}
