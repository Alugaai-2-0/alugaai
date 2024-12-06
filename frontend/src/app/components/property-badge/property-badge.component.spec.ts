import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PropertyBadgeComponent } from './property-badge.component';

describe('PropertyBadgeComponent', () => {
  let component: PropertyBadgeComponent;
  let fixture: ComponentFixture<PropertyBadgeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [PropertyBadgeComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(PropertyBadgeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
