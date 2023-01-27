//
//  OnboardingView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/09.
//

import UIKit

protocol OnboardingViewDelegate: AnyObject {
    func didTapActionButton()
}

final class OnboardingView: UIView {
    //MARK: - Properties
    @IBOutlet weak var actionButton: RoundedButton!
    @IBOutlet private weak var imageView: UIImageView!

    weak var delegate: OnboardingViewDelegate?

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("OnboardingView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
    }

    func configure(image: String) {
        imageView.image = UIImage(named: image)
        actionButton.configure(title: "시작하기", titleColor: .white)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.green.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        actionButton.layer.addSublayer(gradient)
    }

    @IBAction
    private func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapActionButton()
    }
}
