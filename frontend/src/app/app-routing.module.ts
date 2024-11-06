import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ExplorarComponent } from './components/explorar/explorar.component';
import { HomeComponent } from './shared/home/home.component';
import { NotFoundComponent } from './shared/not-found/not-found.component';
import { NotAuthorizedComponent } from './shared/not-authorized/not-authorized.component';
import { LoginComponent } from './components/auth/login/login.component';
import { loggedGuard } from './guards/logged.guard';



export const routes: Routes = [
  { 
    path: '',
     component: HomeComponent
  },
  { 
    path: 'explorar',
     component: ExplorarComponent
  },
  { 
    path: 'home',
     component: HomeComponent
  },
  { 
    path: 'not-found',
     component: NotFoundComponent
  },
  { 
    path: 'not-authorized',
     component: NotAuthorizedComponent
  },
  { 
    path: 'login',
    component: LoginComponent,
    canActivate: [loggedGuard]
    
  },


];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
