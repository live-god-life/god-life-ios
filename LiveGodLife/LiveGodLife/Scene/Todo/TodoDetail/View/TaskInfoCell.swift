//
//  TaskInfoView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/04.
//

import Then
import SnapKit
import UIKit
//MARK: TaskInfoCell
final class TaskInfoView: UIView {
    //MARK: - Properties
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4.0
        $0.alignment = .fill
        $0.distribution = .fill
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let periodItemView = SetTodoItemView().then {
        $0.detailImageView.isHidden = true
        $0.valueLabel.textAlignment = .left
        $0.configure(logo: UIImage(named: "period"), title: "목표 기간", value: "")
    }
    private let repetitionItemView = SetTodoItemView().then {
        $0.detailImageView.isHidden = true
        $0.valueLabel.textAlignment = .left
        $0.configure(logo: UIImage(named: "repetition"), title: "반복 주기", value: "")
    }
    private let notificationItemView = SetTodoItemView().then {
        $0.detailImageView.isHidden = true
        $0.valueLabel.textAlignment = .left
        $0.configure(logo: UIImage(named: "alarm"), title: "알람 설정", value: "")
    }
    private let progressView = TodoProgressView()

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .black
        
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(periodItemView)
        stackView.addArrangedSubview(repetitionItemView)
        stackView.addArrangedSubview(notificationItemView)
        stackView.addArrangedSubview(progressView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-24)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        periodItemView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        repetitionItemView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        notificationItemView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        progressView.snp.makeConstraints {
            $0.height.equalTo(188)
        }
    }

    func configure(with viewModel: TaskInfoViewModel?) {
        guard let viewModel else { return }
        
        self.titleLabel.text = viewModel.title
        self.periodItemView.valueLabel.text = viewModel.period
        self.repetitionItemView.valueLabel.text = viewModel.repetition
        self.notificationItemView.valueLabel.text = viewModel.notification
        
        if let completedCount = viewModel.completedCount,
           let totalCount = viewModel.totalCount {
            progressView.configure(completedCount: completedCount, totalCount: totalCount)
        }
    }
}
