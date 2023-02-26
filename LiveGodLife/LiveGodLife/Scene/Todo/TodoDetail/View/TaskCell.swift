//
//  TaskCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/04.
//

import Then
import SnapKit
import UIKit
//MARK: TaskCell
final class TaskCell: UICollectionViewCell {
    //MARK: - Properties
    private var schedules = [TodoScheduleViewModel]() {
        didSet {
            todoTableView.reloadData()
        }
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = .zero
        $0.alignment = .fill
        $0.distribution = .fill
    }
    private lazy var todoTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: .zero, left: .zero,
                                       bottom: .zero, right: .zero)
    }
    private let emptyLabel = UILabel().then {
        $0.text = "등록된 일정이 없습니다."
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.font = .semiBold(with: 20)
    }
    
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
        contentView.backgroundColor = .black
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(todoTableView)
        stackView.addArrangedSubview(emptyLabel)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints {
            $0.height.equalTo(350)
        }
    }
    
    func configure(with schedules: [TodoScheduleViewModel]) {
        self.schedules = schedules
    }
}

extension TaskCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108.0
    }
}

extension TaskCell: UITableViewDelegate {
    
}
