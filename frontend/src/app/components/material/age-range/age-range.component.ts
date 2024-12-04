import { Component } from '@angular/core';

@Component({
  selector: 'app-age-range',
  templateUrl: './age-range.component.html',
  styleUrl: './age-range.component.scss'
})
export class AgeRangeComponent {
  formatLabel(value: number): string {
   
    return `${value}`;
  }
}
