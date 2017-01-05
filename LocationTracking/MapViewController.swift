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
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
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
            for location in LogCenter.loadData() {
                coordinates.append(location.coordinate)
                
                
                annotations.append(Annotation(coordinate: location.coordinate, title: location.timestamp.description, subtitle: ""))
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
}
