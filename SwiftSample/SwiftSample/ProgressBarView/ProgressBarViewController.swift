//
//  ProgressBarViewController.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2021/08/08.
//  Copyright © 2021 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit

class ProgressBarViewController: UIViewController {
    private let containerScrollView = UIScrollView()
    private let progressBarStackView = UIStackView()

    private var currentIndex: Int = 0
    private let imageIDs: [String] = ["happoike", "happoike2", "enzansou"]

    private var imageViews: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        containerScrollView.backgroundColor = UIColor(red: 177 / 255, green: 172 / 255, blue: 185 / 255, alpha: 1.0)
        containerScrollView.isPagingEnabled = true
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.delegate = self
        view.addSubview(containerScrollView)
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        progressBarStackView.axis = .horizontal
        progressBarStackView.spacing = 3.2
        progressBarStackView.distribution = .fillEqually
        view.addSubview(progressBarStackView)
        progressBarStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            progressBarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            progressBarStackView.heightAnchor.constraint(equalToConstant: 4)
        ])

        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.isUserInteractionEnabled = true
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.topAnchor.constraint(equalTo: progressBarStackView.bottomAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: progressBarStackView.trailingAnchor)
        ])

        imageIDs.enumerated().forEach { index, id in
            let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 300, height: 200))
            containerScrollView.addSubview(imageView)
            imageView.image = UIImage(named: "\(id).jpg")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageViews.append(imageView)
            let progressBar = ProgressBar(with: index)
            progressBar.delegate = self
            progressBarStackView.addArrangedSubview(progressBar)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(imageIDs.count), height: view.bounds.height)
        for (i, imageView) in imageViews.enumerated() {
            let frame = CGRect(x: CGFloat(i) * view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
            imageView.frame = frame
        }
        scrollContentToCurrentIndex()
        runAnimationOfCurrentIndex()
    }

    private func scrollContentToCurrentIndex() {
        let x = containerScrollView.contentSize.width / CGFloat(imageIDs.count) * CGFloat(currentIndex)
        containerScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: currentIndex != 0)
    }

    private func runAnimationOfCurrentIndex() {
        if progressBarStackView.arrangedSubviews.isEmpty { return }
        guard let progressBar = progressBarStackView.arrangedSubviews[currentIndex] as? ProgressBar else { return }
        progressBar.runAnimation()
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProgressBarViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPageIndex = Int((scrollView.contentOffset.x + (0.5 * scrollView.bounds.width)) / scrollView.bounds.width)
        if currentPageIndex == currentIndex { return }

        let isMovingRight = scrollView.panGestureRecognizer.translation(in: scrollView.superview).x < 0
        if isMovingRight {
            if currentIndex == (imageIDs.count - 1) {
                return
            } else {
                currentIndex = currentPageIndex
            }
        } else {
            if currentIndex == 0 {
                currentIndex = 0
            } else {
                currentIndex = currentPageIndex
            }
        }
        progressBarStackView.arrangedSubviews.enumerated().forEach { index, subview in
            if let bar = subview as? ProgressBar {
                bar.pauseAnimation()
                bar.reset()
                if index < currentIndex {
                    bar.fill()
                }
            }
        }
        runAnimationOfCurrentIndex()
    }
}

extension ProgressBarViewController: ProgressBarDelegate {
    func didCompleteAnimation(index: Int) {
        if index < (imageIDs.count - 1) {
            currentIndex = index + 1
        } else {
            progressBarStackView.arrangedSubviews.forEach { subview in
                if let bar = subview as? ProgressBar {
                    bar.reset()
                }
            }
            currentIndex = 0
        }
        runAnimationOfCurrentIndex()
        scrollContentToCurrentIndex()
    }
}
