//
//  OnboardingViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/14.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: view.frame.height)
        view.addSubview(scrollView)

        for index in 0..<4 {
            let y = scrollView.frame.minY
            let view = OnboardingView(frame: CGRect(x: CGFloat(index) * scrollView.frame.width, y: y, width: scrollView.frame.width, height: scrollView.frame.height))
            view.delegate = self
            view.configure(image: "onboarding\(index + 1)")
            if index == 3 { view.actionButton.isHidden = false }
            scrollView.addSubview(view)
        }
    }
}

extension OnboardingViewController: OnboardingViewDelegate {

    func didTapActionButton() {
        self.dismiss(animated: true)
    }
}
