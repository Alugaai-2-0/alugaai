import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AgeRangeComponent } from './age-range.component';

describe('AgeRangeComponent', () => {
  let component: AgeRangeComponent;
  let fixture: ComponentFixture<AgeRangeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AgeRangeComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AgeRangeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
