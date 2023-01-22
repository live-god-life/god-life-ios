//
//  PopupView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/12/06.
//

import UIKit

final class PopupView: UIView {
    //MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var negativeButton: RoundedButton!
    @IBOutlet weak var positiveButton: RoundedButton!

    var negativeHandler: (() -> Void)?
    var positiveHandler: (() -> Void)?

    //MARK: - Initalizer
    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let view = Bundle.main.loadNibNamed("PopupView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.makeBorderGradation(startColor: .green, endColor: .blue, radius: 24)
        view.frame = self.bounds
        addSubview(view)

        negativeButton.configure(title: "취소", titleColor: .DDDDDD, backgroundColor: .gray3)
        positiveButton.configure(title: "확인")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Functions...
    func configure(title: String = "", subtitle: String = "", negativeHandler: @escaping () -> Void, positiveHandler: @escaping () -> Void) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        if subtitle.isEmpty { subtitleLabel.isHidden = true }
        self.negativeHandler = negativeHandler
        self.positiveHandler = positiveHandler
    }

    @IBAction
    private func didTapNegativeButton(_ sender: UIButton) {
        negativeHandler?()
    }

    @IBAction
    private func didTapPositiveButton(_ sender: UIButton) {
        positiveHandler?()
    }
}
