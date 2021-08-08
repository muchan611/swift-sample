//
//  ProgressBar.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2021/08/08.
//  Copyright © 2021 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit

protocol ProgressBarDelegate: AnyObject {
    func didCompleteAnimation(index: Int)
}

class ProgressBar: UIView {
    weak var delegate: ProgressBarDelegate?
    private let progressView = UIProgressView()

    private let duration: CFTimeInterval = 4.0
    private var currentTime: CFTimeInterval = 0.0
    private var lastTimeStamp: CFTimeInterval?
    private let index: Int

    private var displayLink: CADisplayLink?
    private var isPaused: Bool = true

    init(with index: Int) {
        self.index = index
        super.init(frame: .zero)

        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        progressView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        progressView.progressTintColor = UIColor.white
        progressView.layer.cornerRadius = 2.0
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        displayLink?.invalidate()
        displayLink = nil
        if newWindow != nil {
            let displayLink = CADisplayLink(target: self, selector: #selector(update))
            displayLink.add(to: .main, forMode: .common)
            self.displayLink = displayLink
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func update(_ displayLink: CADisplayLink) {
        if isPaused { return }
        if let lastTimeStamp = lastTimeStamp {
            currentTime += displayLink.timestamp - lastTimeStamp
        } else {
            currentTime = 0.0
        }
        lastTimeStamp = displayLink.timestamp
        progressView.progress = min(max(0.0, Float(currentTime / duration)), 1.0)

        if progressView.progress >= 1.0 {
            delegate?.didCompleteAnimation(index: index)
            isPaused = true
        }
    }

    func reset() {
        currentTime = 0.0
        lastTimeStamp = nil
        progressView.progress = 0.0
    }

    func runAnimation() {
        reset()
        isPaused = false
    }

    func pauseAnimation() {
        isPaused = true
    }

    func fill() {
        currentTime = duration
        progressView.progress = 1.0
    }
}
