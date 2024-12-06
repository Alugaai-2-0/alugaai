import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CollegeBadgeComponent } from './college-badge.component';

describe('CollegeBadgeComponent', () => {
  let component: CollegeBadgeComponent;
  let fixture: ComponentFixture<CollegeBadgeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CollegeBadgeComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(CollegeBadgeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
