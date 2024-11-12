
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

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss'
})
export class MapComponent {

  returnButtonOutput = output();

  lat = -23.4709;
  lng = -47.4851;
  markersCollege: any[] = []; 

  constructor(private googleMapsLoader: GoogleMapsLoaderService) {}

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
  }

  onReturnButtonClick(){
    this.returnButtonOutput.emit();
  }

  //Plot

  getColleges() {
    // Mock marker data
    const mockCollege = {
      text: 'Facens',
      position: { lat: -23.470619, lng: -47.429145 },
      options: {
        label: {
          text: 'FACENS',
          color: '#FFFFFF',
          fontFamily: 'Inter',
          fontWeight: 'bold',
        },
        icon: 'assets/common/img/iconCollege.svg'
      } as google.maps.MarkerOptions
    };
  
      // Create a new marker
      const newMarker = new google.maps.Marker({
        position: {
          lat: mockCollege.position.lat,
          lng: mockCollege.position.lng,
        },
        map: this.map,
        icon: mockCollege.options.icon,
        label: mockCollege.options.label,
      });

      console.log(newMarker);
      
   
      // Add a click listener to open the modal
      //newMarker.addListener('click', () => {
       // this.markerClickHandler(college);
      //});
  }
  


}
