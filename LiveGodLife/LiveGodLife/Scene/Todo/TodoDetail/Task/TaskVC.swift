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
    private let tableView = UITableView(frame: .zero, style: .grouped)
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
        view.backgroundColor = .background
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self

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

//MARK: - UITableView DataSource & Delegate
extension TaskVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(dataSource[indexPath.section], isRepeated: isRepeated)
        return cell
    }

    // section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].scheduleDate
    }

    // 섹션 헤더의 타이틀 색상 변경
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.textLabel?.font = .regular(with: 16)
        }
    }
}
