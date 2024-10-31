import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ButtonMapComponent } from './button-map.component';

describe('ButtonMapComponent', () => {
  let component: ButtonMapComponent;
  let fixture: ComponentFixture<ButtonMapComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ButtonMapComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ButtonMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
