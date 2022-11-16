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

    func configure() {
        textLabel.font = .bold(with: 16)
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.text = "사는건 레벨업이 아닌 스펙트럼을 넓히는거란 얘길 들었다. 어떤 말보다 용기가 된다."
    }
}
