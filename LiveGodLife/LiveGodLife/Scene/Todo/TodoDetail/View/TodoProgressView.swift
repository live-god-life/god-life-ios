//
//  TodoProgressView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/04.
//

import UIKit

final class TodoProgressView: UIView {
    //MARK: - Properties
    private let progressView = CircleProgressBar(backgroundCircleColor: .gray7,
                                                 foregroundCircleColor: .green,
                                                 startGradientColor: .green.withAlphaComponent(0.1),
                                                 endGradientColor: .green)
    private let titleLabel = UILabel().then {
        $0.text = "달성율"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.font = .regular(with: 16)
    }
    private let rateLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .right
        $0.font = .montserrat(with: 28, weight: .semibold)
    }
    private let percentLabel = UILabel().then {
        $0.text = "%"
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = .semiBold(with: 20)
    }
    private let countLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }

    //MARK: - Functions...
    func makeUI() {
        backgroundColor = .black
        
        addSubview(progressView)
        addSubview(titleLabel)
        addSubview(rateLabel)
        addSubview(percentLabel)
        addSubview(countLabel)
        
        progressView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.top).offset(34)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview().offset(-10)
            $0.height.equalTo(40)
        }
        percentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.left.equalTo(rateLabel.snp.right).offset(1)
            $0.width.equalTo(19)
            $0.height.equalTo(28)
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
    }

    func configure(completedCount: Int, totalCount: Int) {
        let attrString = NSMutableAttributedString(string: "\(completedCount)회/\(totalCount)회", attributes: [.foregroundColor: UIColor.white,
                                                                                                             .font: UIFont.semiBold(with: 16)!])
        countLabel.attributedText = attrString.apply(word: "/\(totalCount)회",
                                                     attrs: [.foregroundColor: UIColor.white.withAlphaComponent(0.6),
                                                             .font: UIFont.regular(with: 16)!])
        let rate = Double(completedCount) / Double(totalCount)
        progressView.progress = rate
        rateLabel.text = "\(Int(ceil(rate * 100)))"
    }
}
