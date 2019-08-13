import Foundation
import UIKit

class SampleListViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case customCellList
    }
    private var names = ["CustomCellListViewController"]
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
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        let name = names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
