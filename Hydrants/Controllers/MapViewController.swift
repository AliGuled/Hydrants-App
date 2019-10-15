//
//  ViewController.swift
//  Hydrants
//
//  Created by Guled Ali on 3/26/19.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var hydrantMap: MKMapView!
    var locationManger: CLLocationManager?
    
    var hydrantStore: HydrantStore?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger = CLLocationManager()
        locationManger?.delegate = self
        locationManger?.requestWhenInUseAuthorization()
        hydrantMap.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            hydrantMap.showsUserLocation = true
            locationManger?.startUpdatingLocation()
        } else {
            print("Location not perimitted for app - TODO show dialog for user")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapONUserLocation()
    }
    
    func centerMapONUserLocation() {
        if let location = locationManger?.location{
            hydrantMap.setCenter(location.coordinate, animated: true)
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50000, longitudinalMeters: 5000)
            hydrantMap.setRegion(region, animated: true)
            
        } else {
            print("No location availabe")
        }
    }

    @IBAction func addHydrantUpdate(_ sender: UIBarButtonItem) {
        
        centerMapONUserLocation()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "Enter Comment", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Add optinal comment"
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {_ in
            let comment = alertController.textFields?.first?.text
            let hydrantUpdate = HydrantUpdate(coordinate: (self.locationManger?.location?.coordinate)!, comment: comment!)
            self.hydrantStore?.addHydrantUpdate(hydrant: hydrantUpdate, image: image)
            let annotation = HydrantAnnotation(hydrant: hydrantUpdate)
            annotation.coordinate = hydrantUpdate.coordinate
            self.hydrantMap.addAnnotation(annotation)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is HydrantAnnotation {
            
                let hydrantAnnotation = annotation as! HydrantAnnotation
                let pinAnnotationview = MKPinAnnotationView()
                pinAnnotationview.annotation = hydrantAnnotation
                pinAnnotationview.canShowCallout = true
                
                let image = hydrantStore?.getImage(forKey: hydrantAnnotation.hydrant.imageKey)
                
                let photoView = UIImageView()
                photoView.contentMode = .scaleAspectFit
                photoView.image = image
                let heightConstraint = NSLayoutConstraint(item: photoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
                
                photoView.addConstraint(heightConstraint)
                pinAnnotationview.detailCalloutAccessoryView = photoView
                
                return pinAnnotationview
            }
            return nil
        }
    
    
}

