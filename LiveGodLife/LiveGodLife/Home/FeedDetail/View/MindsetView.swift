//
//  MindSetView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/16.
//

import UIKit

class MindsetView: UIView {

    @IBOutlet weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let view = Bundle.main.loadNibNamed("MindsetView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(content: String) {
        textLabel.font = .bold(with: 16)
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.text = content
    }
}
