import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { PropertyService } from '../../services/property.service';
import { CollegeService } from '../../services/college.service';

@Component({
  selector: 'app-badge-clicked',
  templateUrl: './badge-clicked.component.html',
  styleUrl: './badge-clicked.component.scss'
})
export class BadgeClickedComponent {

  constructor(@Inject(MAT_DIALOG_DATA) public building: any, private propertyService: PropertyService, private collegeService: CollegeService) {}

}
