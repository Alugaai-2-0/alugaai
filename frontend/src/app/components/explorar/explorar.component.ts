import { Component } from '@angular/core';

@Component({
  selector: 'app-explorar',
  templateUrl: './explorar.component.html',
  styleUrl: './explorar.component.scss'
})
export class ExplorarComponent {

  showMap = false;

  toggleMap(): void {
    this.showMap = !this.showMap;
  }
  
}
