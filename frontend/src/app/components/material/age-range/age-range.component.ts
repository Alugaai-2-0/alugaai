import { Component } from '@angular/core';
import { FilterService } from '../../../services/filter.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-age-range',
  templateUrl: './age-range.component.html',
  styleUrl: './age-range.component.scss'
})
export class AgeRangeComponent {
  currentValue!: number;
  value = 100;
  private buttonClickSubscription!: Subscription;
  

  constructor(private filterService: FilterService){}

  ngOnInit() {
    // Subscribe to the button click event
    this.buttonClickSubscription = this.filterService.buttonClick$.subscribe(() => {
      this.onButtonClick();  
    });
  }

  ngOnDestroy() {
   
    if (this.buttonClickSubscription) {
      this.buttonClickSubscription.unsubscribe();
    }
  }

  onButtonClick() {
    this.filterService.updateAgeRange(18, this.value);
  }


  formatLabel(value: number): string {
    this.currentValue = value;
    return `${value}`;
  }
}
