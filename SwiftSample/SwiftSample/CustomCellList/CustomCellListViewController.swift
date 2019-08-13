import Foundation
import UIKit

struct CustomCellItem {
    let date: String
    let title: String
}

class CustomCellListViewController: UIViewController {
    private var sampleItems = [CustomCellItem]()
    private let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CustomCellListViewController"
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(cellType: CustomCell.self)
        
        sampleItems = [
            CustomCellItem(date: "2019/01/01", title: "あいうえお"),
            CustomCellItem(date: "2019/01/02", title: "かきくけこ"),
            CustomCellItem(date: "2019/01/03", title: "さしすせそ")
        ]
    }
}

extension CustomCellListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sampleItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: CustomCell.self, for: indexPath)
        cell.update(item: item)
        return cell
    }
}

extension CustomCellListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
