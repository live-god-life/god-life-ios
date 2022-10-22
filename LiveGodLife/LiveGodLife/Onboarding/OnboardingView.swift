//
//  OnboardingView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/09.
//

import UIKit

protocol OnboardingViewDelegate: AnyObject {

    func didTapActionButton(from page: Int)
}

protocol OnboardingViewModelType {

    var title: String { get }
    var subtitle: String { get }
    var description: String { get }
    var buttonTitle: String { get }
}

final class OnboardingView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: RoundedButton!

    weak var delegate: OnboardingViewDelegate?

    private let page: Int

    func configure(with viewModel: OnboardingViewModelType) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        descriptionLabel.text = viewModel.description
        actionButton.configure(title: viewModel.buttonTitle)
    }

    init(frame: CGRect, page: Int) {
        self.page = page
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        guard let view = Bundle.main.loadNibNamed("OnboardingView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
    }

    @IBAction func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapActionButton(from: page)
    }
}
