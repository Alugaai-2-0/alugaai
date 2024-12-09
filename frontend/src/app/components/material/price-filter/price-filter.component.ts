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
    return "R$" + `${value}`;
  }
}
