import { NgModule } from '@angular/core';
import { BrowserModule, provideClientHydration } from '@angular/platform-browser';

import { AppRoutingModule, routes } from './app-routing.module';
import { AppComponent } from './app.component';
import { ExplorarComponent } from './components/explorar/explorar.component';
import { NavbarComponent } from './shared/navbar/navbar.component';
import { FooterComponent } from './shared/footer/footer.component';
import { UserCardComponent } from './shared/user-card/user-card.component';
import { BrowserAnimationsModule, provideAnimations } from '@angular/platform-browser/animations';
import { HomeComponent } from './shared/home/home.component';
import { provideToastr, ToastrModule } from 'ngx-toastr';
import { HTTP_INTERCEPTORS, HttpClientModule, provideHttpClient, withFetch, withInterceptorsFromDi } from '@angular/common/http';
import { AuthInterceptor } from './interceptors/auth.interceptor';
import { NotFoundComponent } from './shared/not-found/not-found.component';
import { NotAuthorizedComponent } from './shared/not-authorized/not-authorized.component';
import { ButtonMapComponent } from './shared/button-map/button-map.component';
import { LoginComponent } from './components/auth/login/login.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { RegisterChoiceComponent } from './components/auth/register-choice/register-choice.component';
import { BackgroundComponent } from './shared/background/background.component';
import { RegisterStudentComponent } from './components/auth/register-student/register-student.component';
import { RegisterOwnerComponent } from './components/auth/register-owner/register-owner.component';
import { PhoneMaskDirective } from './directives/phone-mask.directive';
import { MapComponent } from './components/map/map.component';
import { GoogleMapsModule } from '@angular/google-maps';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import {MatSliderModule} from '@angular/material/slider';
import {MatIconModule} from '@angular/material/icon';
import {MatAutocompleteModule} from '@angular/material/autocomplete';
import {MatChipsModule} from '@angular/material/chips';
import { AutocompleteComponent } from './components/material/autocomplete/autocomplete.component';
import { MatFormFieldModule } from '@angular/material/form-field';
import { AgeRangeComponent } from './components/material/age-range/age-range.component';







@NgModule({
  declarations: [
    AppComponent,
    ExplorarComponent,
    NavbarComponent,
    FooterComponent,
    UserCardComponent,
    HomeComponent,
    NotFoundComponent,
    NotAuthorizedComponent,
    ButtonMapComponent,
    LoginComponent,
    RegisterChoiceComponent,
    BackgroundComponent,
    RegisterStudentComponent,
    RegisterOwnerComponent,
    PhoneMaskDirective,
    MapComponent,
    AutocompleteComponent,
    AgeRangeComponent,
    
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(),
    FormsModule,
    ReactiveFormsModule,
    GoogleMapsModule,
    HttpClientModule,
    MatSliderModule,
    MatIconModule,
    MatAutocompleteModule,
    MatChipsModule,
    MatFormFieldModule,
    
  ],
  providers: [
    provideClientHydration(),
    provideToastr(),
    provideAnimations(),
    provideHttpClient(withFetch()),
    provideAnimationsAsync(),
   
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
