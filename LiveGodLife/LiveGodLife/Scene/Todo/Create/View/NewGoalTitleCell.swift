//
//  NewGoalTitleCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/02.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol NewGoalTitleCellDelegate: AnyObject {
    func textEditingChanged(_ text: String?)
}

//MARK: NewGoalTitleCell
final class NewGoalTitleCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: NewGoalTitleCellDelegate?
    private var bag = Set<AnyCancellable>()
    private var text: String? {
        didSet {
            textLineView.isHidden = !(text?.isEmpty ?? true)
            pencilImageView.isHidden = !(text?.isEmpty ?? true)
        }
    }
    private let textField = UITextField().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .semiBold(with: 28)
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
        $0.spellCheckingType = .no
        $0.autocorrectionType = .no
        $0.smartInsertDeleteType = .no
        $0.returnKeyType = .done
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let attrString = NSAttributedString(string: "목표 작성",
                                            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.4),
                                                         .font: UIFont.semiBold(with: 28)!])
        $0.attributedPlaceholder = attrString
        $0.tintColor = .clear
    }
    private let pencilImageView = UIImageView().then {
        $0.image = UIImage(named: "pencil")
    }
    private let textLineView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.2)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textField.text = nil
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(textField)
        contentView.addSubview(pencilImageView)
        contentView.addSubview(textLineView)
        
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        textLineView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(-1)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(101)
            $0.height.equalTo(1)
        }
        pencilImageView.snp.makeConstraints {
            $0.bottom.equalTo(textLineView.snp.bottom)
            $0.left.equalTo(textLineView.snp.right).offset(6)
            $0.size.equalTo(24)
        }
    }
    
    private func bind() {
        textField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.delegate?.textEditingChanged(text)
            }
            .store(in: &bag)
        
        textField
            .textPublisher
            .map { !($0?.isEmpty ?? true) }
            .assign(to: \.isHidden, on: pencilImageView)
            .store(in: &bag)
        
        textField
            .textPublisher
            .map { !($0?.isEmpty ?? true) }
            .assign(to: \.isHidden, on: textLineView)
            .store(in: &bag)
    }
    
    func configure(with title: String?) {
        self.textLineView.isHidden = !(title?.isEmpty ?? true)
        self.pencilImageView.isHidden = !(title?.isEmpty ?? true)
        self.textField.text = title
    }
}
