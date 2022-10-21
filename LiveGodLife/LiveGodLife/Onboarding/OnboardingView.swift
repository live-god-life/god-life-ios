//
//  OnboardingView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/09.
//

import UIKit

protocol OnboardingViewModelType {

    var title: String { get }
    var subtitle: String { get }
    var description: String { get }
    var buttonTitle: String { get }
    var actionHandler: (() -> Void)? { get }
}

class OnboardingView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: RoundedButton!

    var actionHandler: (() -> Void)?

    func configure(with viewModel: OnboardingViewModelType) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        descriptionLabel.text = viewModel.description
        actionButton.configure(title: viewModel.buttonTitle)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        guard let view = Bundle.main.loadNibNamed("OnboardingView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
    }

    @IBAction func didTapActionButton(_ sender: UIButton) {
        actionHandler?()
    }
}
