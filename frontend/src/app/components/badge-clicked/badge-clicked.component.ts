import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { PropertyService } from '../../services/property.service';
import { CollegeService } from '../../services/college.service';
import { ICollegeResponse } from '../../interfaces/ICollegeResponse';
import { IPropertyDetailedResponse } from '../../interfaces/IPropertyDetailedResponse';
import { IPropertyResponse } from '../../interfaces/IPropertyResponse';

@Component({
  selector: 'app-badge-clicked',
  templateUrl: './badge-clicked.component.html',
  styleUrl: './badge-clicked.component.scss'
})
export class BadgeClickedComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public building: any, private propertyService: PropertyService, private collegeService: CollegeService) {}


  propertyForDetails?: IPropertyDetailedResponse;
  collegeForDetails?: ICollegeResponse;

  ngOnInit(): void {
    this.verifyIsCollege();
    this.verifyIsProperty();
    this.propertyDetails();
    
  }

  isProperty: boolean = false;

  verifyIsProperty() {
    if ('price' in this.building) {
      this.isProperty = true;
    }
    this.building = this.building as IPropertyResponse;
  }

  verifyIsCollege() {

    if ('address' in this.building) {
      this.isProperty = false;
    }
    this.building = this.building as ICollegeResponse;
  }

  propertyDetails() {
    if (this.isProperty) {
      this.propertyService.findPropertyDetailsById(this.building.id).subscribe((response) => {
        this.propertyForDetails = response;
      });
    }
  }

  

}
