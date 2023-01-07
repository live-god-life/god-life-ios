//
//  TaskViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit
import SnapKit

struct TodoScheduleViewModel: Decodable {

    let todoScheduleID: Int
    let title: String
    let scheduleDate: String
    let dayOfWeek: String
    let completionStatus: Bool

    enum CodingKeys: String, CodingKey {
        case todoScheduleID = "todoScheduleId"
        case title, scheduleDate, dayOfWeek, completionStatus
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todoScheduleID = try container.decode(Int.self, forKey: .todoScheduleID)
        title = try container.decode(String.self, forKey: .title)
        scheduleDate = try container.decode(String.self, forKey: .scheduleDate)
        dayOfWeek = try container.decode(String.self, forKey: .dayOfWeek)
        completionStatus = try container.decode(Bool.self, forKey: .completionStatus)
    }
}

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
    private var dataSource: [TodoScheduleViewModel] = []

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

    // FIXME: 네이밍과 구조
    func configure(with: TaskViewModel) {
        emptyLabel.isHidden = true
        tableView.isHidden = false
    }

    func configure(with data: [TodoScheduleViewModel]) {
        dataSource = data
        tableView.reloadData()
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.configure(dataSource[indexPath.section])
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
