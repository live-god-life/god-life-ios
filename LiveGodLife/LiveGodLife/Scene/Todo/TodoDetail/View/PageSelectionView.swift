//
//  PageSelectionView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/04.
//

import Then
import SnapKit
import Combine
import UIKit

protocol PageSelectionViewDelegate: AnyObject {
    func select(isNext: Bool)
}

//MARK: PageSelectionCell
final class PageSelectionView: UIView {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: PageSelectionViewDelegate?
    private var type: TodoDetailVC.TaskType = .todo
    let nextButton = UIButton()
    private let nextBottomLine = UIView().then {
        $0.isHidden = true
    }
    private let nextLabel = UILabel().then {
        $0.text = "앞으로 일정"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.font = .semiBold(with: 18)
    }
    let prevButton = UIButton()
    private let prevBottomLine = UIView().then {
        $0.isHidden = true
    }
    private let prevLabel = UILabel().then {
        $0.text = "지난 일정"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.font = .semiBold(with: 18)
    }

    private let lineView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.4)
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .black
        
        addSubview(prevLabel)
        addSubview(nextLabel)
        addSubview(lineView)
        addSubview(prevBottomLine)
        addSubview(nextBottomLine)
        addSubview(nextButton)
        addSubview(prevButton)
        
        let width = UIScreen.main.bounds.width / 2.0
        
        nextLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(width)
        }
        prevLabel.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(width)
        }
        lineView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        nextBottomLine.snp.makeConstraints {
            $0.centerX.equalTo(nextLabel.snp.centerX)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(114)
            $0.height.equalTo(2)
        }
        prevBottomLine.snp.makeConstraints {
            $0.centerX.equalTo(prevLabel.snp.centerX)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(98)
            $0.height.equalTo(2)
        }
        nextButton.snp.makeConstraints {
            $0.edges.equalTo(nextLabel)
        }
        prevButton.snp.makeConstraints {
            $0.edges.equalTo(prevLabel)
        }
    }
    
    private func bind() {
        nextButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.configure(with: self.type, isNext: true)
                self.delegate?.select(isNext: true)
            }
            .store(in: &bag)
        
        prevButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.configure(with: self.type, isNext: false)
                self.delegate?.select(isNext: false)
            }
            .store(in: &bag)
    }
    
    func configure(with type: TodoDetailVC.TaskType, isNext: Bool) {
        self.type = type
        
        nextBottomLine.backgroundColor = type == .todo ? .green : .blue
        prevBottomLine.backgroundColor = type == .todo ? .green : .blue
        
        nextButton.isSelected = isNext
        nextLabel.textColor = isNext ? .white : .white.withAlphaComponent(0.6)
        nextBottomLine.isHidden = !isNext
        
        prevButton.isSelected = !isNext
        prevLabel.textColor = isNext ? .white.withAlphaComponent(0.6) : .white
        prevBottomLine.isHidden = isNext
    }
}

