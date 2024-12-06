import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BadgeClickedComponent } from './badge-clicked.component';

describe('BadgeClickedComponent', () => {
  let component: BadgeClickedComponent;
  let fixture: ComponentFixture<BadgeClickedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [BadgeClickedComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(BadgeClickedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
