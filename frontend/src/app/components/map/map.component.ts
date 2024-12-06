
import {
  AfterViewInit,
  Component,
  DoCheck,
  ElementRef,
  OnDestroy,
  OnInit,
  output,
  ViewChild,
} from '@angular/core';

import { Subscription, map } from 'rxjs';
import { GoogleMapsLoaderService } from '../../services/google-maps-loader.service';
import { CollegeService } from '../../services/college.service';
import { ICollegeResponse } from '../../interfaces/ICollegeResponse';
import { PropertyService } from '../../services/property.service';
import { IPropertyResponse } from '../../interfaces/IPropertyResponse';
import { ToastrService } from 'ngx-toastr';
import { BadgeClickedComponent } from '../badge-clicked/badge-clicked.component';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss'
})
export class MapComponent {

  returnButtonOutput = output();

  lat = -23.4709;
  lng = -47.4851;
  markersCollege!: ICollegeResponse[]; 
  markersProperties!: IPropertyResponse[];

  constructor(private googleMapsLoader: GoogleMapsLoaderService, 
    private collegeService: CollegeService, 
    private propertyService: PropertyService, 
    private toastrService: ToastrService,
    private dialog: MatDialog,) {}

  

  title = 'angular-gmap';
  @ViewChild('gmapContainer', { static: false }) mapContainer?: ElementRef;

  map?: google.maps.Map;

  ngAfterViewInit(): void {
    this.googleMapsLoader.load().then(() => {
      this.mapInitializer();
    }).catch(error => {
      console.error('Google Maps failed to load:', error);
    });
    
  }

  mapInitializer() {
    const coordinates = new google.maps.LatLng(this.lat, this.lng);

    const mapOptions: google.maps.MapOptions = {
      center: coordinates,
      zoom: 12,
      panControl: false,
      disableDefaultUI: true,
      zoomControl: false,
      scaleControl: false,
      mapTypeControl: false,
      minZoom: 8,
      scrollwheel: true,
      styles: [
        {
          elementType: 'geometry',
          stylers: [
            {
              color: '#f5f5f5',
            },
          ],
        },
        {
          elementType: 'labels.icon',
          stylers: [
            {
              visibility: 'off',
            },
          ],
        },
        {
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#616161',
            },
          ],
        },
        {
          elementType: 'labels.text.stroke',
          stylers: [
            {
              color: '#f5f5f5',
            },
          ],
        },
        {
          featureType: 'administrative.land_parcel',
          elementType: 'labels',
          stylers: [
            {
              visibility: 'off',
            },
          ],
        },
        {
          featureType: 'administrative.land_parcel',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#bdbdbd',
            },
          ],
        },
        {
          featureType: 'poi',
          elementType: 'geometry',
          stylers: [
            {
              color: '#eeeeee',
            },
          ],
        },
        {
          featureType: 'poi',
          elementType: 'labels.text',
          stylers: [
            {
              visibility: 'off',
            },
          ],
        },
        {
          featureType: 'poi',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#757575',
            },
          ],
        },
        {
          featureType: 'poi.park',
          elementType: 'geometry',
          stylers: [
            {
              color: '#e5e5e5',
            },
          ],
        },
        {
          featureType: 'poi.park',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#9e9e9e',
            },
          ],
        },
        {
          featureType: 'road',
          elementType: 'geometry',
          stylers: [
            {
              color: '#ffffff',
            },
          ],
        },
        {
          featureType: 'road.arterial',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#757575',
            },
          ],
        },
        {
          featureType: 'road.highway',
          elementType: 'geometry',
          stylers: [
            {
              color: '#dadada',
            },
          ],
        },
        {
          featureType: 'road.highway',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#616161',
            },
          ],
        },
        {
          featureType: 'road.local',
          elementType: 'labels',
          stylers: [
            {
              visibility: 'off',
            },
          ],
        },
        {
          featureType: 'road.local',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#9e9e9e',
            },
          ],
        },
        {
          featureType: 'transit.line',
          elementType: 'geometry',
          stylers: [
            {
              color: '#e5e5e5',
            },
          ],
        },
        {
          featureType: 'transit.station',
          elementType: 'geometry',
          stylers: [
            {
              color: '#eeeeee',
            },
          ],
        },
        {
          featureType: 'water',
          elementType: 'geometry',
          stylers: [
            {
              color: '#c9c9c9',
            },
          ],
        },
        {
          featureType: 'water',
          elementType: 'labels.text.fill',
          stylers: [
            {
              color: '#9e9e9e',
            },
          ],
        },
      ],
    };

    if (this.mapContainer) {
      this.map = new google.maps.Map(this.mapContainer.nativeElement, mapOptions);
    }
    this.getColleges();
    this.getProperties();
  }

  onReturnButtonClick(){
    this.returnButtonOutput.emit();
  }

  //Plot

  truncateText(text: string, maxLength: number): string {
    if (!text) return '';
    return text.length > maxLength ? text.slice(0, maxLength) + '...' : text;
  }

  getColleges() {
    
    this.collegeService.getColleges().subscribe({
      next: (response) => {
        if (response) {
          this.markersCollege = response;
  
          
          this.markersCollege.forEach((college) => {
           
            const lat = parseFloat(college.latitude); 
            const lng = parseFloat(college.longitude); 
  
          
            if (isNaN(lat) || isNaN(lng)) {
              console.warn('Invalid latitude or longitude for college:', college);
              return;
            }

            const truncatedName = this.truncateText(college.collegeName || 'Unknown College', 7); // Limit to 15 characters
  
            const markerOptions: google.maps.MarkerOptions = {
              position: {
                lat: lat,
                lng: lng,
              },
              map: this.map,
              icon: 'assets/common/img/iconCollege.svg', 
              label: {
                text: truncatedName || 'Unknown College', 
                color: '#FFFFFF',
                fontFamily: 'Inter',
                fontWeight: 'bold',
              },
            };
  
            // Create and add the marker
            const newMarker = new google.maps.Marker(markerOptions);
  
         
            newMarker.addListener('click', () => {
              this.markerClickHandler();
           });
          });
        }
      },
      error: (error) => {
        this.toastrService.error("Falha ao carregar as Faculdades", error.error);
      },
    });
  }

  markerClickHandler() {
    this.dialog.open(BadgeClickedComponent, {
      width: '500px',
    });
  }
  
  

  getProperties() {
    this.propertyService.getProperties().subscribe({
      next: (response) => {
        if (response) {
          this.markersProperties = response;
  
          
          this.markersProperties.forEach((property) => {
           
            const lat = parseFloat(property.latitude); 
            const lng = parseFloat(property.longitude); 
  
          
            if (isNaN(lat) || isNaN(lng)) {
              console.warn('Invalid latitude or longitude for college:', property);
              return;
            }
  
            const markerOptions: google.maps.MarkerOptions = {
              position: {
                lat: lat,
                lng: lng,
              },
              map: this.map,
              icon: 'assets/common/img/iconProperty.svg', 
              label: {
                text: "R$ " + String(property.price), 
                color: '#FFFFFF',
                fontFamily: 'Inter',
                fontWeight: 'bold',
              },
            };
  
            // Create and add the marker
            const newMarker = new google.maps.Marker(markerOptions);
  
            // Optional: Add a click listener for modal handling
            //newMarker.addListener('click', () => {
            //  this.markerClickHandler(college);
          //  });
          });
        }
      },
      error: (error) => {
        this.toastrService.error("Falha ao carregar as Propriedades", error.error);;
      },
    });
  }
  


}
