import { Component, Input, OnInit } from '@angular/core';
import { ICollegeResponse } from '../../interfaces/ICollegeResponse';
import { DomSanitizer, SafeUrl } from '@angular/platform-browser';

@Component({
  selector: 'app-college-badge',
  templateUrl: './college-badge.component.html',
  styleUrl: './college-badge.component.scss'
})
export class CollegeBadgeComponent implements OnInit {
  constructor(private sanitizer: DomSanitizer) { }

  @Input() building?: ICollegeResponse;
  buildingImages: SafeUrl[] = [];
  base64: string = 'data:image/png;base64,';

  ngOnInit(): void {
    console.log("Building: ", this.building)
  }

  // startImage() {
  //  if (this.building?.collegeImagesIds) {
  //   let images = this.building.collegeImagesIds;
  //   images.forEach((image) => {
  //    this.buildingImages.push(
  //      this.sanitizer.bypassSecurityTrustUrl(this.base64 + image.imageData64)
  //    );
  //    });
  //   }
  // }
}
