import { Component, OnInit, Input, OnDestroy } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { keyframes } from '@angular/animations';
import { Subject } from 'rxjs';
import * as kf from './keyframes';

@Component({
  selector: 'app-user-card',
  templateUrl: './user-card.component.html',
  styleUrl: './user-card.component.scss',
  animations: [
    trigger('cardAnimator', [
      transition('* => swiperight', animate(750, keyframes(kf.swiperight))),
      transition('* => swipeleft', animate(750, keyframes(kf.swipeleft)))
    ])
  ]
})
export class UserCardComponent implements OnInit, OnDestroy {
  // Existing properties
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

  // Animation properties""
  animationState!: string;
  parentSubject: Subject<string> = new Subject();
  index: number = 0;

  constructor() {}

  ngOnInit() {
    this.parentSubject.subscribe((event) => {
      this.startAnimation(event);
    });
  }

  startAnimation(state: string) {
    if (!this.animationState) {
      this.animationState = state;
    }
  }

  resetAnimationState(state: any) {
    this.animationState = '';
    this.index++;
  }

  ngOnDestroy() {
    this.parentSubject.unsubscribe();
  }

  // Existing method
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