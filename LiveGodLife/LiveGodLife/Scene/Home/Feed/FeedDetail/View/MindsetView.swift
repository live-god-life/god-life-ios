//
//  MindSetView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/16.
//

import UIKit

final class MindsetView: UIView {
    //MARK: - Properties
    @IBOutlet weak var textLabel: UILabel!

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    //MARK: - Functions...
    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("MindsetView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
        
        backgroundColor = .clear
    }

    func configure(content: String) {
        textLabel.font = .bold(with: 16)
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.text = content
    }
}
