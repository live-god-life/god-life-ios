//
//  DropDownView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/16.
//

import UIKit
import SnapKit

final class DropDownView: UIView {

    // TODO: 네이밍 고민
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var toggleButton: UIButton!

    private var isOpened: Bool = false {
        didSet {
            let up = UIImage(systemName: "chevron.up")
            let down = UIImage(systemName: "chevron.down")
            isOpened == true ? toggleButton.setImage(up, for: .normal) : toggleButton.setImage(down, for: .normal)
        }
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
        guard let view = Bundle.main.loadNibNamed("DropDownView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        firstView.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        secondView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        thirdView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        view.frame = self.bounds
        addSubview(view)
    }

    @IBAction func toggle(_ sendser: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            if self.isOpened {
                self.secondView.isHidden = true
                self.thirdView.isHidden = true
            } else {
                self.secondView.isHidden = false
                self.thirdView.isHidden = false
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.isOpened = !self.isOpened
        })
    }
}
