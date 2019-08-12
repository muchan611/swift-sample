import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = UIViewController()
        firstViewController.view.backgroundColor = .white
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        firstNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .white
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        secondNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        
        let viewControllers = [firstNavigationController, secondNavigationController]
        setViewControllers(viewControllers, animated: false)
    }
}
