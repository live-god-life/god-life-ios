//
//  SettingTableViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit

protocol SettingTableViewCellDelegate {

    func didTapActionButton(with index: Int)
}

final class SettingTableViewCell: UITableViewCell {

    static let indentifier = "SettingTableViewCell"

    private var index: Int = -1

    var delegate: SettingTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!

    func configure(with viewModel: SettingTableViewCellViewModel) {
        index = viewModel.rawValue
        titleLabel.text = viewModel.title
        titleLabel.textColor = .BBBBBB
        titleLabel.font = .bold(with: 16)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    @IBAction func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapActionButton(with: index)
    }
}
