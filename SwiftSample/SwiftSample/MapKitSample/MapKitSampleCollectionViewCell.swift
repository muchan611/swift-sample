//
//  MapKitSampleCollectionViewCell.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2020/10/26.
//  Copyright © 2020 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapKitSampleCollectionViewCell: UICollectionViewCell {
    private let placeNameLabel = UILabel()
    private let mapImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(placeNameLabel)
        placeNameLabel.tintColor = UIColor.darkGray
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            placeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            placeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])

        contentView.addSubview(mapImageView)
        mapImageView.clipsToBounds = true
        mapImageView.layer.cornerRadius = 10.0
        mapImageView.backgroundColor = UIColor.systemGroupedBackground
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 10),
            mapImageView.leadingAnchor.constraint(equalTo: placeNameLabel.leadingAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: placeNameLabel.trailingAnchor),
            mapImageView.heightAnchor.constraint(equalTo: mapImageView.widthAnchor, multiplier: 1 / 2),
            mapImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: MapItem) {
        placeNameLabel.text = item.title
        
        let location = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: 400, height: 200)
        options.region = MKCoordinateRegion(center: location, span: span)
        options.scale = UIScreen.main.scale
        options.mapType = .standard

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start(completionHandler: { [weak self] (snapshot, _) in
            guard let snapshot = snapshot else { return }
            
            let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                snapshot.image.draw(at: .zero)

                let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let pinImage = UIImage(named: "pin")!
                pinView.image = pinImage

                var point = snapshot.point(for: location)
                point.x -= pinView.bounds.width / 2
                point.y -= pinView.bounds.height / 2
                point.x += pinView.centerOffset.x
                point.y += pinView.centerOffset.y
                pinImage.draw(at: point)
            }

            self?.mapImageView.image = image
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.mapImageView.alpha = 1.0
            })
        })
    }
}
