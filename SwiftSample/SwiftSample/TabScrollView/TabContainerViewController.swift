//
//  TabContainerViewController.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2020/06/26.
//  Copyright © 2020 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit

class TabChildViewController: UIViewController {
    var index: Int
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TabContainerViewController: UIPageViewController {
    private var controllers: [TabChildViewController] = []
    private var displayedController: TabChildViewController?
    
    private static let tabHeight: CGFloat = 50
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: tabHeight)
        return flowLayout
    }()
    private var tabCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TabContainerViewController"
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        // ナビゲーションバーのブラーを解除し・下線をなくす
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // PageViewに表示するためのViewContollerを生成
        controllers = (0...9).map { index in
            let vc = TabChildViewController(index: index)
            vc.view.backgroundColor = .white
            let label = UILabel()
            label.text = "View \(index)"
            label.textColor = .gray
            vc.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
            return vc
        }
        updateDisplayedController(with: 0)
        
        setupTabCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // ナビゲーションバーの状態を戻す
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func setupTabCollectionView() {
        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        tabCollectionView.backgroundColor = .white
        tabCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(tabCollectionView)
        tabCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabCollectionView.heightAnchor.constraint(equalToConstant: Self.tabHeight).isActive = true
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(cellType: TabCollectionCell.self)
    }
    
    private func updateDisplayedController(with index: Int) {
        let direction: UIPageViewController.NavigationDirection
        if let oldDisplayedController = displayedController, oldDisplayedController.index < index {
            direction = .forward
        } else {
            direction = .reverse
        }
        // 表示するViewControllerをセットする時に、前に表示していたViewよりも後の画面だったら.forward(右に進む)、前の画面だったら.reverse(左に戻る)のアニメーションを指定する
        setViewControllers([controllers[index]], direction: direction, animated: true, completion: nil)
        displayedController = controllers[index]
    }
    
    private func scrollTabToCenter(of indexPath: IndexPath) {
        tabCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension TabContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? TabChildViewController,
            let index = controllers.firstIndex(of: viewController),
            index > 0 else { return nil }
        // 左にフリックした時は、ひとつ前の画面を返す
        return controllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? TabChildViewController,
            let index = controllers.firstIndex(of: viewController),
            index < controllers.count - 1 else { return nil }
        // 右にフリックした時は、ひとつ前の画面を返す
        return controllers[index+1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        // 最初に生成したcontrollersの数だけ表示する
        return controllers.count
    }
}

extension TabContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first as? TabChildViewController else { return }
        if completed {
            // ページングのアニメーションが完了したら、今見ている画面に合わせてTabのアクティブ状態とタブの位置を変更する(tabCollectionViewの更新と、CollectionViewの表示位置を変更)
            displayedController = viewController
            tabCollectionView.reloadData()
            scrollTabToCenter(of: IndexPath(row: viewController.index, section: 0))
        }
    }
}

extension TabContainerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: TabCollectionCell.self, for: indexPath)
        let isActive: Bool
        // 今表示しているViewControllerのIndexに合わせて、タブのアクティブ状態を判定
        if let index = displayedController?.index, index == indexPath.row {
            isActive = true
        } else {
            isActive = false
        }
        cell.configure(title: "View\(indexPath.row)", isActive: isActive)
        return cell
    }
}

extension TabContainerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // tabCollectionViewに表示しているCellがタップされたら、そのIndexに合わせて表示するViewControllerを変え、Tabのアクティブ状態とタブの位置を変更する
        updateDisplayedController(with: indexPath.row)
        tabCollectionView.reloadData()
        scrollTabToCenter(of: indexPath)
    }
}

