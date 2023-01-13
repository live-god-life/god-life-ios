//
//  OnboardingViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/14.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    private var scrollView: UIScrollView!
    private var pageControl = CustomPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: view.frame.height)
        scrollView.delegate = self
        view.addSubview(scrollView)

        for index in 0..<4 {
            let y = scrollView.frame.minY
            let view = OnboardingView(frame: CGRect(x: CGFloat(index) * scrollView.frame.width, y: y, width: scrollView.frame.width, height: scrollView.frame.height))
            view.delegate = self
            view.configure(image: "onboarding\(index + 1)")
            if index == 3 { view.actionButton.isHidden = false }
            scrollView.addSubview(view)
        }

        pageControl.numberOfPages = 4
        pageControl.setIndicatorImage(CustomPageControl.currentPageImage, forPage: 0)
        pageControl.currentPageIndicatorTintColor = .green
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.snp.bottom).inset(130)
        }
    }
}

extension OnboardingViewController: OnboardingViewDelegate {

    func didTapActionButton() {
        self.dismiss(animated: true)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = view.frame.width
        switch scrollView.contentOffset.x {
        case 0:
            pageControl.currentPage = 0
        case page: // 1
            pageControl.currentPage = 1
        case page * 2: // 2
            pageControl.currentPage = 2
        case page * 3: // 3
            pageControl.currentPage = 3
        default:
            break
        }
    }
}
