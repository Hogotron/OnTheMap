//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/8/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Variables
    
    var locations = [StudentLocation]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.isHidden = false
        
        ParseClient.sharedInstance().getStudentLocations(limit: 5, skip: 10, order: "") { (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.locations = studentLocations
                print("These are the locations in the MapViewController: \(self.locations)")
            }
            
            var annotations = [MKPointAnnotation]()
            
            for dictionary in self.locations {
                
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
                print("These are the annotations: \(annotations)")
            }
            
            self.mapView.delegate = self
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for annotation: MKAnnotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("The MapViewController was deinitialized")
    }
}
