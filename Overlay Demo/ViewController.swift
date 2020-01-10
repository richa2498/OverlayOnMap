//
//  ViewController.swift
//  Overlay Demo
//
//  Created by MacStudent on 2020-01-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    let places = Place.getPlaces()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        addAnnotation()
       // addPoliline()
        addPoligon()
       // locationManager.startUpdatingLocation()
    }

    func addAnnotation(){
        
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        let overlays = places.map { (MKCircle(center: $0.coordinate, radius: 5000))}
        mapView.addOverlays(overlays)
    }
    
    func addPoliline(){
        
        let points = places.map{$0.coordinate}
        let polylines = MKPolyline(coordinates: points, count:points.count)
        mapView.addOverlay(polylines)
    }
    
    func addPoligon(){
        
        let points = places.map{$0.coordinate}
        let poligon = MKPolygon(coordinates: points, count: places.count)
        mapView.addOverlay(poligon)
    }

}

extension ViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            
            return nil
        }else{
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named:"ic_place_2x" )
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    //this function is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle{
                let renders = MKCircleRenderer(overlay: overlay)
                renders.fillColor = UIColor.black.withAlphaComponent(0.5)
                renders.strokeColor = UIColor.blue
                renders.lineWidth = 4
                return renders
        }else if overlay is MKPolyline{
             let renders = MKPolylineRenderer(overlay: overlay)
            renders.lineWidth = 4
            renders.strokeColor = UIColor.black
            return renders
        }
        else if overlay is MKPolygon{
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.black
            renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place,let title = annotation.title  else {
            return
        }
        let alertControler = UIAlertController(title: "Welcome to \(title)", message: "You may enjoy the place", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertControler.addAction(cancle)
        present(alertControler,animated: true,completion: nil)
    }
    
}

