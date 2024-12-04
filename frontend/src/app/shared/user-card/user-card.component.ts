import { Component, OnInit, OnDestroy } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { keyframes } from '@angular/animations';
import { Subject, Subscription } from 'rxjs';
import * as kf from './keyframes';
import { StudentService } from '../../services/student.service';
import { IUser } from '../../interfaces/IUser';
import { IStudentFeedResponse } from '../../interfaces/IStudentFeedResponse';
import { FilterService } from '../../services/filter.service';



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

  constructor(private studentService: StudentService, private filterService: FilterService) {}
  private allUsers!: IStudentFeedResponse[]
  visibleUsers: IStudentFeedResponse[] = [];
  animationStates: string[] = [];
  parentSubject: Subject<string> = new Subject();
  readonly MAX_VISIBLE_CARDS = 3;
  currentIndex = 0;

  //filter variables
  //I have to make another function so
  interesses!: string[]
  minAge: number = 18;
  maxAge: number = 100;
  private filterSubscription!: Subscription;
  private filtersUpdatedSubscription!: Subscription;
  loaded: boolean = false

  ngOnInit() {
    // Subscribe to filter values from the filter service
    this.filterSubscription = this.filterService.ageRange$.subscribe((ageRange: { min: number; max: number; }) => {
      this.minAge = ageRange.min;
      this.maxAge = ageRange.max;
       // Fetch students with updated filters
       
    });

    this.filterService.interesses$.subscribe((interests: string[]) => {
      this.interesses = interests;
       // Fetch students with updated filters
      
    });

    // Initial fetch when the component is loaded
   
    this.filterService.getCombinedFilters$().subscribe(([ageRange, interests]) => {
      console.log('Filters updated:', ageRange, interests);
      this.loadFilteredStudents();
    });

      this.loadFilteredStudents();
     
    this.parentSubject.subscribe((event) => {
      this.startAnimation(event);
    });
  }

  handleButtonClick() {
    // This method will be triggered whenever the button click occurs
    console.log('Button clicked! Triggered via FilterService');

    // You can add your logic here, for example:
    this.loadFilteredStudents();  // Re-fetch the users or trigger an animation
  }
  

  ngOnDestroy() {
    // Unsubscribe from filter service to avoid memory leaks
    if (this.filterSubscription) {
      this.filterSubscription.unsubscribe();
    }
    this.parentSubject.unsubscribe();
  }

  loadFilteredStudents() {
    console.log("on filtered students: ", this.minAge, this.maxAge, this.interesses)
    // Call the studentService with updated filter values
    this.studentService.getStudents(this.minAge, this.maxAge, this.interesses).subscribe({
      next: (response) => {

        this.allUsers = response;
        
        this.loadInitialCards(); // Assuming this method handles setting the initial visible cards
      },
      error: (err) => {
        console.error('Error loading students', err);
      }
    });
  }

  formatName(name: string): string {
    if (name.length <= 12) return name;
    
    const nameParts = name.split(' ');
    const firstName = nameParts[0];
    const lastName = nameParts[nameParts.length - 1];
    
    return `${firstName} ${lastName.charAt(0)}.`;
  }

  getAge(birthdate: string | Date): number {
    const today = new Date();
    const birthDate = new Date(birthdate);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    
    // Adjust age if the birthday hasn't occurred yet this year
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
  
    return age;
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

 
}