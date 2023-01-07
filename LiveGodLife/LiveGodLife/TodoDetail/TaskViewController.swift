//
//  TaskViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit
import SnapKit

class TaskViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .bold(with: 20)
        label.textAlignment = .center
        label.text = "등록된 일정이 없습니다."
        return label
    }()

    private var taskViewModel: TaskViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        setupUI()
    }

    private func setupUI() {
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

        tableView.isHidden = true
    }

    func configure(with: TaskViewModel) {
        emptyLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.configure()
        return cell
    }

    // section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "금요일"
    }

    // 섹션 헤더의 타이틀 색상 변경
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
        }
    }
}
