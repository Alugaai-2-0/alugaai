import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import path from 'path';
import { ExplorarComponent } from './components/explorar/explorar.component';

const routes: Routes = [{ path: 'explorar', component: ExplorarComponent }];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
