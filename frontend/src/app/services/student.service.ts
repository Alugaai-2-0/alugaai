import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class StudentService {

  constructor(private http: HttpClient) { }

  getStudents() {
    const mockUsers = [
      {
        description: 'Sou Alina Dias, estudante tranquila, nas horas vagas gosto de ler e estudar.',
        name: 'Alina',
        age: 22,
        school: 'FACENS',
        profileImage: 'assets/common/img/Profile-picture.jpg',
        tags: [
          { name: 'Estudos' },
          { name: 'Tecnologia' },
          { name: 'Esportes' },
          { name: 'Música' },
          { name: 'Literatura' },
          { name: 'Gatos' },
          { name: 'Idiomas' },
          { name: 'Voluntariado' },
          { name: 'Arte' },
          { name: 'Cachorro' },

        ]
      },
      {
        description: 'Sou João Silva, apaixonado por tecnologia e inovação.',
        name: 'João',
        age: 28,
        school: 'FACENS',
        profileImage: 'assets/common/img/Profile-picture2.jpg',
        tags: [
          { name: 'Tecnologia' },
          { name: 'Música' },
          { name: 'Viagens' },
          { name: 'Esportes' },
          { name: 'Arte' },
          { name: 'Livros' },
          { name: 'Estudos' },
          { name: 'Cinema' },
          { name: 'Ler' },
        ]
      },
      {
        description: 'Sou Maria Oliveira, adoro esportes e vida saudável.',
        name: 'Maria',
        age: 25,
        school: 'UNESP',
        profileImage: 'assets/common/img/Profile-picture3.jpg',
        tags: [
          { name: 'Esportes' },
          { name: 'Nutrição' },
          { name: 'Estudos' },
          { name: 'Música' },
          { name: 'Organização' }
        ]
      },
      {
        description: 'Sou João Silva, apaixonado por tecnologia e inovação.',
        name: 'João',
        age: 28,
        school: 'FACENS',
        profileImage: 'assets/common/img/Profile-picture2.jpg',
        tags: [
          { name: 'Tecnologia' },
          { name: 'Música' },
          { name: 'Viagens' },
          { name: 'Esportes' },
          { name: 'Arte' },
          { name: 'Livros' },
          { name: 'Tecnologia' },
        { name: 'Música' },
        { name: 'Viagens' },
          { name: 'Estudos' },
          { name: 'Cinema' },
          { name: 'Ler' },
        ]
      },
      {
        description: 'Sou João Silva, apaixonado por tecnologia e inovação.',
        name: 'João',
        age: 28,
        school: 'FACENS',
        profileImage: 'assets/common/img/Profile-picture2.jpg',
        tags: [
          { name: 'Tecnologia' },
          { name: 'Música' },
          { name: 'Livros' },
          { name: 'Estudos' },
          { name: 'Cinema' },
          { name: 'Ler' },
        ]
      },
      {
        description: 'Sou Alina Dias, estudante tranquila, nas horas vagas gosto de ler e estudar.',
        name: 'Alina',
        age: 22,
        school: 'FACENS',
        profileImage: 'assets/common/img/Profile-picture.jpg',
        tags: [
          { name: 'Estudos' },
          { name: 'Tecnologia' },
          { name: 'Esportes' },
          { name: 'Voluntariado' },
          { name: 'Arte' },
          { name: 'Cachorro' },
  
        ]
      },
      {
        description: 'Sou João Silva, apaixonado por tecnologia e inovação.',
        name: 'João',
        age: 28,
        school: 'FACENS',
        profileImage: 'assets/common/img/Profile-picture2.jpg',
        tags: [
          { name: 'Tecnologia' },
          { name: 'Tecnologia' },
        { name: 'Música' },
        { name: 'Viagens' },
          { name: 'Música' },
          { name: 'Viagens' },
          { name: 'Esportes' },
          { name: 'Arte' },
          { name: 'Livros' },
          { name: 'Estudos' },
          { name: 'Cinema' }, 
          { name: 'Ler' },   
    ]},
    {
      description: 'Sou Alina Dias, estudante tranquila, nas horas vagas gosto de ler e estudar.',
      name: 'Alina',
      age: 22,
      school: 'FACENS',
      profileImage: 'assets/common/img/Profile-picture.jpg',
      tags: [
        { name: 'Estudos' },
        { name: 'Tecnologia' },
        { name: 'Esportes' },
        { name: 'Tecnologia' },
        { name: 'Música' },
        { name: 'Viagens' },
        { name: 'Música' },
        { name: 'Literatura' },
        { name: 'Gatos' },
        { name: 'Idiomas' },
        { name: 'Voluntariado' },
        { name: 'Arte' },
        { name: 'Cachorro' },

      ]
    },
    {
      description: 'Sou João Silva, apaixonado por tecnologia e inovação.',
      name: 'João',
      age: 28,
      school: 'FACENS',
      profileImage: 'assets/common/img/Profile-picture2.jpg',
      tags: [
        { name: 'Tecnologia' },
        { name: 'Música' },
        { name: 'Viagens' },
        { name: 'Tecnologia' },
        { name: 'Música' },
        { name: 'Viagens' },
        { name: 'Esportes' },
        { name: 'Arte' },
        { name: 'Livros' },
        { name: 'Estudos' },
        { name: 'Cinema' }, 
        { name: 'Ler' },   
  ]},

      // Add more users here as needed
    ];

    return mockUsers;
  }
}
