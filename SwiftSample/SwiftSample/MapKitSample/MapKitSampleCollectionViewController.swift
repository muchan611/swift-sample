//
//  MapKitSampleCollectionViewController.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2020/10/24.
//  Copyright © 2020 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit

class MapKitSampleCollectionViewController: UIViewController {
    enum Section {
        case main
    }
    private var dataSource: UICollectionViewDiffableDataSource<Section, MapItem>! = nil
    private var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MapKitSampleCollectionView"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        view.addSubview(collectionView)
        configureDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MapKitSampleCollectionViewCell, MapItem>.init(handler: {(cell, indexPath, identifier) in
            cell.update(item: identifier)
        })
        
        dataSource = UICollectionViewDiffableDataSource<Section, MapItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: MapItem) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MapItem>()
        snapshot.appendSections([.main])
        let mapItems: [MapItem] = [
            .init(title: "東京タワー", lat: 35.658581, lon: 139.745433),
            .init(title: "六本木ヒルズ", lat: 35.6602384, lon: 139.7300767)
        ]
        snapshot.appendItems(mapItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MapKitSampleCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.snapshot().itemIdentifiers[indexPath.item]
        let viewController = MapKitSampleMapViewController(mapItem: item)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

struct MapItem: Hashable {
    var title: String
    var lat: Double
    var lon: Double
}
