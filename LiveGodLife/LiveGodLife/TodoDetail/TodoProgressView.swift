//
//  TodoProgressView.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit

class TodoProgressView: UIView {

    @IBOutlet weak var progressView: CircularProgressBar!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        guard let view = Bundle.main.loadNibNamed("TodoProgressView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
    }

    func configure(completedCount: Int, totalCount: Int) {
        countLabel.text = "\(completedCount)회 / \(totalCount)회"
        let rate = ceil(Double(completedCount) / Double(totalCount) * 100)
        rateLabel.text = "\(rate)"
        progressView.value = rate
    }
}
