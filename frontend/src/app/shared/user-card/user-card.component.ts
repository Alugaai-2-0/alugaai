import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-user-card',
  templateUrl: './user-card.component.html',
  styleUrl: './user-card.component.scss'
})
export class UserCardComponent {
  userDescription: string = 'Sou Alina Dias, estudante tranquila, nas horas vagas gosto de ler e estudar.';
  userName: string = 'Alina Dias';
  userAge: number = 22;
  userSchool: string = 'FACENS';
  profileImageSrc: string = 'assets/common/img/Profile-picture.jpg';
  
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
    { name: 'Viagens' },
  ];

  truncate(value: string, limit: number = 65, completeWords: boolean = false, ellipsis: string = '...'): string {
    if (!value || typeof value !== 'string') return '';
    if (value.length <= limit) return value;

    let truncated = value.slice(0, limit);

    if (completeWords) {
      const lastSpaceIndex = truncated.lastIndexOf(' ');
      if (lastSpaceIndex > -1) {
        truncated = truncated.slice(0, lastSpaceIndex);
      }
    }

    return truncated + ellipsis;
  }

}
