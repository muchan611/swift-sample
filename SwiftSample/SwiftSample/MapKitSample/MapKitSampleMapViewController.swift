//
//  MapKitSampleMapViewController.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2020/10/24.
//  Copyright © 2020 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapKitSampleMapViewController: UIViewController {
    private let mapItem: MapItem
    private let mapView: MKMapView
    
    init(mapItem: MapItem) {
        self.mapItem = mapItem
        self.mapView = MKMapView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let location = CLLocationCoordinate2DMake(mapItem.lat, mapItem.lon)
        mapView.setCenter(location, animated: true)
        
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard

        let pin = MKPointAnnotation()
        pin.coordinate = location
        mapView.addAnnotation(pin)
    }
}

extension MapKitSampleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        myAnnotation.image = UIImage(named: "pin")!
        myAnnotation.annotation = annotation
        return myAnnotation
    }
}
