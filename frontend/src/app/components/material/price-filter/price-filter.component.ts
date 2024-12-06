import { Component } from '@angular/core';
import { FilterService } from '../../../services/filter.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-price-filter',
  templateUrl: './price-filter.component.html',
  styleUrl: './price-filter.component.scss'
})
export class PriceFilterComponent {
  currentValue!: number;
  value = 100;
  private buttonClickSubscription!: Subscription;
  

  constructor(private filterService: FilterService){}

  ngOnInit() {
    // Subscribe to the button click event
    this.buttonClickSubscription = this.filterService.buttonClick$.subscribe(() => {
      this.onButtonClick();  // Call the method when the button click event occurs
    });
  }

  ngOnDestroy() {
    // Clean up the subscription to prevent memory leaks
    if (this.buttonClickSubscription) {
      this.buttonClickSubscription.unsubscribe();
    }
  }

  onButtonClick() {
    this.filterService.updateAgeRange(18, this.value);
  }


  formatLabel(value: number): string {
    this.currentValue = value;
    return "R$" + `${value}`;
  }
}
