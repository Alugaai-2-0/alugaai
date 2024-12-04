import { Component, OnInit, OnDestroy } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { keyframes } from '@angular/animations';
import { Subject } from 'rxjs';
import * as kf from './keyframes';
import { StudentService } from '../../services/student.service';
import { IUser } from '../../interfaces/IUser';
import { IStudentFeedResponse } from '../../interfaces/IStudentFeedResponse';



@Component({
  selector: 'app-user-card',
  templateUrl: './user-card.component.html',
  styleUrls: ['./user-card.component.scss'],
  animations: [
    trigger('cardAnimator', [
      transition('* => swiperight', animate(750, keyframes(kf.swiperight))),
      transition('* => swipeleft', animate(750, keyframes(kf.swipeleft)))
    ])
  ]
})
export class UserCardComponent implements OnInit, OnDestroy {
  constructor(private studentService: StudentService) {}
  private allUsers!: IStudentFeedResponse[]

  visibleUsers: IStudentFeedResponse[] = [];
  animationStates: string[] = [];
  parentSubject: Subject<string> = new Subject();
  readonly MAX_VISIBLE_CARDS = 3;
  currentIndex = 0;

  ngOnInit() {
    this.studentService.getStudents().subscribe({
      next: (response) => {
        this.allUsers = response;
        console.log(response)
        this.loadInitialCards();
    this.parentSubject.subscribe((event) => {
      this.startAnimation(event);
    });
      } 
    })

    

    
  }

  formatName(name: string): string {
    if (name.length <= 12) return name;
    
    const nameParts = name.split(' ');
    const firstName = nameParts[0];
    const lastName = nameParts[nameParts.length - 1];
    
    return `${firstName} ${lastName.charAt(0)}.`;
  }

  loadInitialCards() {
    this.visibleUsers = this.allUsers.slice(
      this.currentIndex,
      this.currentIndex + this.MAX_VISIBLE_CARDS
    );
    this.animationStates = new Array(this.visibleUsers.length).fill('');
  }

  startAnimation(state: string, index: number = 0) {
    if (this.visibleUsers.length > 0) {
      this.animationStates[index] = state;
    }
  }

  resetAnimationState(event: any, index: number) {
    if (this.animationStates[index]) {
      this.animationStates[index] = '';
      this.removeCard();
    
    }
  }

  removeCard() {
    this.visibleUsers.shift();
    this.animationStates.shift();
    this.currentIndex++;
    
    if (this.currentIndex + this.visibleUsers.length < this.allUsers.length) {
      const nextUser = this.allUsers[this.currentIndex + this.visibleUsers.length];
      this.visibleUsers.push(nextUser);
      this.animationStates.push('');
    }
  }

  getCardTransform(index: number): string {
    if (index === 0) return 'scale(1)';
    const scale = 1 - (index * 0.05);
    const translateY = index * -10;
    return `scale(${scale}) translateY(${translateY}px)`;
  }

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

  ngOnDestroy() {
    this.parentSubject.unsubscribe();
  }
}