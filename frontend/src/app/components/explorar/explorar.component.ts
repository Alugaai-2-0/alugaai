import { Component } from '@angular/core';

@Component({
  selector: 'app-explorar',
  templateUrl: './explorar.component.html',
  styleUrl: './explorar.component.scss'
})
export class ExplorarComponent {
  tags: { name: string; color?: string }[] = [
    { name: 'Estudos' },
    { name: 'Tecnologia', color: 'rgb(133, 135, 150)' },
    { name: 'Esportes' },
    { name: 'Música' },
    { name: 'Literatura' },
    { name: 'Gatos' },
    { name: 'Idiomas' },
    { name: 'Voluntariado' },
    { name: 'Organização' },
  ];
}
