import { COMMA, ENTER } from '@angular/cdk/keycodes';
import { Component, DoCheck, ElementRef, EventEmitter, Output, ViewChild, inject } from '@angular/core';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatAutocompleteSelectedEvent, MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatChipInputEvent, MatChipsModule } from '@angular/material/chips';
import { Observable, Subscription } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { MatIconModule } from '@angular/material/icon';
import { AsyncPipe } from '@angular/common';
import { MatFormFieldModule } from '@angular/material/form-field';
import { LiveAnnouncer } from '@angular/cdk/a11y';
import { StudentService } from '../../../services/student.service';
import { FilterService } from '../../../services/filter.service';
@Component({
  selector: 'app-autocomplete',
  templateUrl: './autocomplete.component.html',
  styleUrl: './autocomplete.component.scss',
})
export class AutocompleteComponent {

  separatorKeysCodes: number[] = [ENTER, COMMA];
  interesseCtrl = new FormControl('');
  filteredInteresses: Observable<string[]>;
  interesses: string[] = [];
  allInteresses: string[] = [
    'Extrovertida',
    'Músico',
    'Madrugador',
    'Noturno',
    'Toca Piano',
    'Vegetariana',
    'Filmes', 
    'Séries', 
    'Animes', 
    'Leitura', 
    'Esportes', 
    'Futebol', 
    'Basquete', 
    'Vôlei', 
    'Corrida', 
    'Treinar', 
    'Academia', 
    'Yoga', 
    'Dança', 
    'Fotografia', 
    'Desenho', 
    'Pintura', 
    'Música', 
    'Tocar Violão', 
    'Tocar Piano', 
    'Cantar', 
    'Jogos de Tabuleiro', 
    'RPG de Mesa', 
    'Baralho', 
    'Videogames', 
    'League of Legends', 
    'Valorant', 
    'CS:GO', 
    'Minecraft', 
    'Roblox', 
    'Tecnologia', 
    'Programação', 
    'Hackathons', 
    'Startups', 
    'Empreendedorismo', 
    'Culinária', 
    'Doces', 
    'Café', 
    'Viagens', 
    'Camping', 
    'Harry Potter', 
    'Senhor dos Anéis', 
    'Star Wars', 
    'Marvel', 
    'DC Comics', 
    'Astronomia', 
    'Filosofia', 
    'História', 
    'Poesia', 
    'Psicologia', 
    'Voluntariado', 
    'Sustentabilidade', 
    'Ativismo Social', 
    'Fotografia de Natureza', 
    'Pet Lover', 
    'Cuidar de Plantas', 
    'Astrologia', 
    'Meditação', 
    'Trekking', 
    'Surf', 
    'Skate', 
    'Patinação', 
    'Ciclismo', 
    'Economia', 
    'Debates', 
    'Política', 
    'Stand-up Comedy', 
    'Memes', 
    'Cultura Pop', 
    'Cosplay', 
    'Eventos Universitários', 
    'Baladas', 
    'Churrasco', 
    'Comida Japonesa', 
    'Comida Italiana', 
    'Series Documentais', 
    'Podcasts', 
    'TikTok', 
    'YouTube', 
    'Streaming', 
    'Esportes Radicais', 
    'Lutas', 
    'Boxe', 
    'Jiu-Jitsu', 
    'Karatê'
  ];
  private buttonClickSubscription!: Subscription;
  

  @Output() interessesChange = new EventEmitter<string[]>();
  @ViewChild('interesseInput') interesseInput!: ElementRef<HTMLInputElement>;

  announcer = inject(LiveAnnouncer);
  filterService = inject(FilterService)

  constructor(private studentService: StudentService) {
    this.filteredInteresses = this.interesseCtrl.valueChanges.pipe(
      startWith(null),
      map((interesse: string | null) => (interesse ? this._filter(interesse) : this.allInteresses.slice())),
    );
  }

  ngOnInit() {
    // Subscribe to the button click event
    this.buttonClickSubscription = this.filterService.buttonClick$.subscribe(() => {
      this.onButtonClick();  // Call the method when the button click event occurs
    });
  }

  onButtonClick() {
    this.filterService.updateInterests(this.interesses);
  }

  add(event: MatChipInputEvent): void {
    const value = (event.value || '').trim();
  
    if (value && this.allInteresses.includes(value) && !this.interesses.includes(value)) {
      this.interesses.push(value);
      // Update filters in the service
    }
  
    event.chipInput!.clear();
    this.interesseCtrl.setValue(null);
  }


  remove(interesse: string): void {
    const index = this.interesses.indexOf(interesse);
  
    if (index >= 0) {
      this.interesses.splice(index, 1);
   // Update filters in the service
    }
  }

  selected(event: MatAutocompleteSelectedEvent): void {
    const value = event.option.viewValue;
  
    // Add only if not already added
    if (!this.interesses.includes(value)) {
      this.interesses.push(value);
  
     
    
    }
  
    // Clear the input
    this.interesseInput.nativeElement.value = '';
    this.interesseCtrl.setValue(null);
  }

  private _filter(value: string): string[] {
    const filterValue = value.toLowerCase();

    return this.allInteresses.filter(interesse => interesse.toLowerCase().includes(filterValue));
  }

}
