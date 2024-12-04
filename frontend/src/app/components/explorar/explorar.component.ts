import { Component, inject } from '@angular/core';
import { CollegeService } from '../../services/college.service';
import { FilterService } from '../../services/filter.service';

@Component({
  selector: 'app-explorar',
  templateUrl: './explorar.component.html',
  styleUrl: './explorar.component.scss'
})
export class ExplorarComponent {

  showMap = false;

  collegeService = inject(CollegeService);
  filterService = inject(FilterService);

  ngOnInit(): void {
    
  }

  toggleMap(): void {
    this.showMap = !this.showMap;
  }

  onButtonClick(){
    this.filterService.triggerButtonClick(); 
  }


 

  
  
}
