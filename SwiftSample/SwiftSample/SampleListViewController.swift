import Foundation
import UIKit

class SampleListViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case xibScrollView
        case tabScrollView
        case nestedGroupCollectionView
        case overlayClippedView
        case customCellList
    }
    private let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SampleListViewController"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension SampleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .customCellList:
            let viewController = CustomCellListViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .overlayClippedView:
            let viewController = OverlayClippedBaseViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        case .nestedGroupCollectionView:
            let viewController = NestedGroupCollectionViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        case .tabScrollView:
            let viewController = TabContainerViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        case .xibScrollView:
            let viewController = XIBScrollViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SampleListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch section {
        case .customCellList:
            cell.textLabel?.text = "CustomCellListViewController"
        case .overlayClippedView:
            cell.textLabel?.text = "OverlayClippedBaseViewController"
        case .nestedGroupCollectionView:
            cell.textLabel?.text = "NestedGroupCollectionViewController"
        case .tabScrollView:
            cell.textLabel?.text = "TabContainerViewController"
        case .xibScrollView:
            cell.textLabel?.text = "XIBScrollViewController"
        }
               
        return cell
    }
}
