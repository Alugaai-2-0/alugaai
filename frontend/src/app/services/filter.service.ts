import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, combineLatest, debounceTime, distinctUntilChanged, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FilterService {

  private ageRangeSubject = new BehaviorSubject<{ min: number; max: number }>({ min: 18, max: 100 });
  private interestsSubject = new BehaviorSubject<string[]>([]);
  private buttonClickSubject = new Subject<void>();  // Subject for button click
  private filtersUpdatedSubject = new Subject<void>();  // Subject for filter update

  // Observables to get current filter values
  ageRange$ = this.ageRangeSubject.asObservable();
  interesses$ = this.interestsSubject.asObservable();
  buttonClick$ = this.buttonClickSubject.asObservable();
  
  filtersUpdated$ = this.filtersUpdatedSubject.asObservable();

  constructor() { }

  updateAgeRange(min: number, max: number) {
    this.ageRangeSubject.next({ min, max });
    this.notifyFiltersUpdated();  // Notify when filters are updated
  }

  getCombinedFilters$() {
    return combineLatest([this.ageRange$, this.interesses$]).pipe(
      debounceTime(100), // Add debounce to reduce the number of emissions
      distinctUntilChanged() // Ensure unique emissions only
    );
  }

  // Update interests filter
  updateInterests(interests: string[]) {
    this.interestsSubject.next(interests);
    this.notifyFiltersUpdated();  // Notify when filters are updated
  }

  triggerButtonClick() {
    this.buttonClickSubject.next();

  }
  private notifyFiltersUpdated() {
    this.filtersUpdatedSubject.next();  // Notify that filters have been updated
  }

}
