//
//  TaskCheckButton.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/31.
//

import UIKit

final class TaskCheckButton: UIButton {
    private var selectImage: String = ""

    override var isSelected: Bool {
        didSet {
            setImage(UIImage(named: selectImage), for: .selected)
            setImage(UIImage(named: "btn_toggle_checkbox_off"), for: .normal)
        }
    }

    func configure(selectImage: String) {
        self.selectImage = selectImage
    }
}
