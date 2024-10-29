import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import path from 'path';
import { ExplorarComponent } from './components/explorar/explorar.component';
import { HomeComponent } from './shared/home/home.component';

const routes: Routes = [
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

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
