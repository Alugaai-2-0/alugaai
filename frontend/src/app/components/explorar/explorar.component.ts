import { Component, inject } from '@angular/core';
import { CollegeService } from '../../services/college.service';

@Component({
  selector: 'app-explorar',
  templateUrl: './explorar.component.html',
  styleUrl: './explorar.component.scss'
})
export class ExplorarComponent {

  showMap = false;

  collegeService = inject(CollegeService);

  ngOnInit(): void {
    
  }

  toggleMap(): void {
    this.showMap = !this.showMap;
  }

  getColleges(){
    this.collegeService.getColleges().subscribe({
      next: (response) => {
        console.log(response);
      },
      error: (error) =>{
        console.log("error:", error);
      }
    })
  }

  onButtonClick(){
    this.getColleges();
  }
  
}
