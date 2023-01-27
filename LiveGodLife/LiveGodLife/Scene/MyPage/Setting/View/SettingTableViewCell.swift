//
//  SettingTableViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit

protocol SettingTableViewCellDelegate: AnyObject {
    func didTapActionButton(with index: Int)
}

final class SettingTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var index: Int = -1
    
    weak var delegate: SettingTableViewCellDelegate?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    //MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    //MARK: - Functions...
    func configure(with viewModel: SettingTableViewCellViewModel) {
        index = viewModel.rawValue
        titleLabel.text = viewModel.title
        titleLabel.textColor = .BBBBBB
        titleLabel.font = .bold(with: 16)
        button.setImage(UIImage(systemName: viewModel.image), for: .normal)
        button.tintColor = .BBBBBB
        button.setTitle(viewModel.subtitle, for: .normal)
    }
    
    @IBAction
    private func didTapActionButton(_ sender: UIButton) {
        delegate?.didTapActionButton(with: index)
    }
}
