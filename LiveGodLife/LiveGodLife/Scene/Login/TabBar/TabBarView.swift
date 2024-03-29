//
//  TabBarView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/18.
//

import UIKit

protocol TabBarViewDelegate: AnyObject {
    func setViewController(with index: Int)
}

final class TabBarView: UIView {
    //MARK: - Properties
    weak var delegate: TabBarViewDelegate?
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var mypageButton: UIButton!

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
        guard let view = Bundle.main.loadNibNamed("TabBarView", owner: self)?.first as? UIView else {
            return
        }
        view.frame = self.bounds
        addSubview(view)

        view.backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerRadius = 40
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgbHexString: "39393D")?.cgColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        homeButton.setImage(UIImage(named: "tab_home"), for: .selected)
        homeButton.setImage(UIImage(named: "tab_home_disable"), for: .normal)
        todoButton.setImage(UIImage(named: "tab_calendar"), for: .selected)
        todoButton.setImage(UIImage(named: "tab_calendar_disable"), for: .normal)
        mypageButton.setImage(UIImage(named: "tab_my"), for: .selected)
        mypageButton.setImage(UIImage(named: "tab_my_disable"), for: .normal)
    }

    @IBAction func setViewController(_ sender: UIButton) {
        [homeButton, todoButton, mypageButton].enumerated().forEach { (index, button) in
            button?.isSelected = index == sender.tag
        }
        delegate?.setViewController(with: sender.tag)
    }
}
