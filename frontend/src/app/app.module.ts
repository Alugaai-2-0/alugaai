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
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(),
    FormsModule,
    ReactiveFormsModule,
  ],
  providers: [
    provideClientHydration(),
    provideToastr(),
    provideAnimations(),
    provideHttpClient(withInterceptorsFromDi(), withFetch()),
    { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true },
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
