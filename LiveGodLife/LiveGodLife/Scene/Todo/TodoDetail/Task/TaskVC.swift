//
//  TaskVC.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit
import SnapKit

final class TaskVC: UIViewController {
    //MARK: - Properties
    private var isRepeated: Bool = false
    private var dataSource: [TodoScheduleViewModel] = []
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let emptyLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .bold(with: 20)
        $0.textAlignment = .center
        $0.text = "등록된 일정이 없습니다."
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")

        tableView.rowHeight = 72 + 16
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(with data: [TodoScheduleViewModel], isRepeated: Bool) {
        guard !data.isEmpty else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
            return
        }
        emptyLabel.isHidden = true
        self.isRepeated = isRepeated
        dataSource = data
        tableView.reloadData()
    }
}
