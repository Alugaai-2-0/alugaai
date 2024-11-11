import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class GoogleMapsLoaderService {
  private apiLoaded = false;

  load(): Promise<void> {
    return new Promise((resolve, reject) => {
      // Only load the script if we are in the browser
      if (typeof window === 'undefined') {
        reject('Google Maps can only be loaded in the browser environment');
        return;
      }

      // If API is already loaded, resolve immediately
      if (this.apiLoaded || (window as any).google) {
        this.apiLoaded = true;
        resolve();
        return;
      }

      // Load the script
      const script = document.createElement('script');
      script.src = 'https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY';
      script.async = true;
      script.defer = true;
      script.onload = () => {
        this.apiLoaded = true;
        resolve();
      };
      script.onerror = (error) => {
        reject(`Google Maps failed to load: ${error}`);
      };

      document.head.appendChild(script);
    });
  }
}
