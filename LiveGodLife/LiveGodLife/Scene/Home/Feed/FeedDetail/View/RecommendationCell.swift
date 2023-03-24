//
//  RecommendationCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import Combine
import UIKit

protocol RecommendationCellDelegate: AnyObject {
    func load()
}

//MARK: RecommendationCell
final class RecommendationCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: RecommendationCellDelegate?
    private var bag = Set<AnyCancellable>()
    private let recommendationLabel = UILabel().then {
        $0.text = "추천 리스트"
        $0.textColor = .white
        $0.font = .semiBold(with: 24)
    }
    private let loadView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 18.0
    }
    private let loadLabel = UILabel().then {
        $0.text = "가져오기"
        $0.textColor = .black
        $0.font = .semiBold(with: 16)
    }
    private let loadImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow_right_black")
    }
    private let lineView = DashView().then {
        $0.backgroundColor = .black
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
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(lineView)
        contentView.addSubview(recommendationLabel)
        contentView.addSubview(loadView)
        loadView.addSubview(loadLabel)
        loadView.addSubview(loadImageView)
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        recommendationLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(65)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(44)
        }
        loadView.snp.makeConstraints {
            $0.centerY.equalTo(recommendationLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(103)
            $0.height.equalTo(36)
        }
        loadLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        loadImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-8)
            $0.size.equalTo(24)
        }
    }
    
    private func bind() {
        loadView
            .gesture()
            .sink { [weak self] _ in
                self?.delegate?.load()
            }
            .store(in: &bag)
    }
}

