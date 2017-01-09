//
//  MapViewController.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/5.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var color = UIColor.green
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class MapViewController: UIViewController {
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapview.delegate = self
        DispatchQueue.global().async {
            var coordinates = [CLLocationCoordinate2D]()
            var annotations = [Annotation]()
            var timestamp:Date?
            for data in LogCenter.loadData() {
                let annotation = Annotation(coordinate: data.location.coordinate)
                if let first = timestamp, first > data.date {
                    annotation.color = UIColor.red
                }
                annotation.title = data.type
                annotation.subtitle = data.date.description
                
                coordinates.append(data.location.coordinate)
                annotations.append(annotation)
                
                timestamp = data.date
            }
            let polygon = MKPolyline(coordinates: coordinates, count: coordinates.count)

            DispatchQueue.main.async(execute: {
                self.mapview.add(polygon)
                self.mapview.addAnnotations(annotations)
                self.mapview.visibleMapRect = polygon.boundingMapRect
            })
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.green
            lineView.lineWidth = 1
            
            return lineView
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let anAnnotation = annotation as? Annotation else {
            return nil
        }
        
        let reuseId = "pin\(anAnnotation.color)"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if anView == nil {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        } else {
            anView?.annotation = annotation
        }
        anView?.pinTintColor = anAnnotation.color
        anView?.canShowCallout = true
        
        return anView
    }
}
