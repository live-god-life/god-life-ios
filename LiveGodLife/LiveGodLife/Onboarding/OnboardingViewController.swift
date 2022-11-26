//
//  OnboardingViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/14.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private var scrollView: UIScrollView!

    private let data: [OnboardingViewModelType] = [
        OnboardingViewModel(title: "함께 나누는 갓생", subtitle: "Step 01", description: "다양한 사람들의 갓생을 만나\n시야를 넓히고 영감을 얻으세요.", buttonTitle: "다음으로 가요"),
        OnboardingViewModel(title: "나에게 딱맞는 투두", subtitle: "Step 02", description: "작은 습관부터 인생 목표까지\n원하는 대로 가져오고 추가하세요.", buttonTitle: "다음으로 가요"),
        OnboardingViewModel(title: "간편한 오늘의 할일", subtitle: "Step 03", description: "작은 습관부터 인생 목표까지\n원하는 대로 가져오고 추가하세요.", buttonTitle: "시작하기")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
        view.addSubview(scrollView)

        for index in 0..<data.count {
            let y = scrollView.frame.minY
            let view = OnboardingView(frame: CGRect(x: CGFloat(index) * scrollView.frame.width, y: y, width: scrollView.frame.width, height: scrollView.frame.height), page: index)
            view.delegate = self
            view.configure(with: data[index])
            scrollView.addSubview(view)
        }
    }
}

extension OnboardingViewController: OnboardingViewDelegate {

    func didTapActionButton(from page: Int) {
        let lastPage = data.count - 1
        if page == lastPage {
            self.dismiss(animated: true)
//            NotificationCenter.default.post(name: .moveToLogin, object: self)
            
        } else {
            let point = CGPoint(x: CGFloat(page + 1) * self.scrollView.frame.width, y: 0)
            self.scrollView.setContentOffset(point, animated: true)
        }
    }
}
