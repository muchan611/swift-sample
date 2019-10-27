import UIKit

class NestedGroupCollectionViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case main
    }
    
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nested Groups"
        configureHierarchy()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(cellType: NestedGroupCollectionViewCell.self)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        let outsideLeadingInset: CGFloat = 18
        let outsideTrailingInset: CGFloat = 18
        let insideInset: CGFloat = 8
        let topInset: CGFloat = 8
        let viewWidth: CGFloat = view.bounds.width
        let smallSquareWidth: CGFloat = (viewWidth - (outsideLeadingInset + outsideTrailingInset + insideInset * 2)) / 3
        let mediumSquareWidth: CGFloat = smallSquareWidth * 2 + insideInset
        let nestedGroupHeight: CGFloat = mediumSquareWidth + topInset
        let smallSquareGroupHeight: CGFloat = smallSquareWidth + topInset
        
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let nestedGroupTypeA: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(smallSquareWidth + insideInset)))
                smallSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: outsideLeadingInset, bottom: 0, trailing: insideInset)
                let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(outsideLeadingInset + smallSquareWidth + insideInset),
                                                      heightDimension: .fractionalHeight(1.0)),
                    subitem: smallSquareItem, count: 2)

                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(mediumSquareWidth + outsideTrailingInset),
                                                      heightDimension: .fractionalHeight(1.0)))
                mediumSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: outsideTrailingInset)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(nestedGroupHeight)),
                    subitems: [smallSquareGroup, mediumSquareItem])
                return nestedGroup
            }()
            
            let nestedGroupTypeB: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(outsideLeadingInset + mediumSquareWidth + insideInset),
                                                      heightDimension: .fractionalHeight(1.0)))
                mediumSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: outsideLeadingInset, bottom: 0, trailing: insideInset)

                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(smallSquareWidth + insideInset)))
                smallSquareItem.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: outsideTrailingInset)
                let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth + outsideTrailingInset),
                                                      heightDimension: .fractionalHeight(1.0)),
                    subitem: smallSquareItem, count: 2)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(nestedGroupHeight)),
                    subitems: [mediumSquareItem, smallSquareGroup])
                return nestedGroup
            }()
            
            let nestedGroupTypeC: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                      heightDimension: .fractionalHeight(1.0)))

                let smallSquareGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(smallSquareGroupHeight)),
                    subitems: [smallSquareItem, smallSquareItem, smallSquareItem])
                smallSquareGroup.interItemSpacing = .fixed(insideInset)
                smallSquareGroup.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: outsideLeadingInset, bottom: 0, trailing: outsideTrailingInset)
                
                return smallSquareGroup
            }()
            
            let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(nestedGroupHeight * 2 + smallSquareGroupHeight * 2)),
            subitems: [nestedGroupTypeA, nestedGroupTypeC, nestedGroupTypeB, nestedGroupTypeC])
            let section = NSCollectionLayoutSection(group: group)
            return section

        }
        return layout
    }
}

extension NestedGroupCollectionViewController: UICollectionViewDelegate {}

extension NestedGroupCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .main:
            let cell = collectionView.dequeueReusableCell(with: NestedGroupCollectionViewCell.self, for: indexPath)
            cell.update(text: "\(indexPath.section), \(indexPath.row)")
            return cell
        }
    }
}
