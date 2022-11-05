//
//  SettingViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit
import SnapKit

enum SettingTableViewSection {

    case first([SettingTableViewCellViewModel])
    case second([SettingTableViewCellViewModel])
}

final class SettingViewController: UIViewController {

    private let tableView = UITableView()
    private let sections: [SettingTableViewSection] = [
        SettingTableViewSection(rawValue: 0),
        SettingTableViewSection(rawValue: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        title = "설정"

        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SettingTableViewCell.indentifier, bundle: nil), forCellReuseIdentifier: SettingTableViewCell.indentifier)
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.indentifier, for: indexPath) as? SettingTableViewCell else {
            preconditionFailure()
        }
        switch sections[indexPath.section] {
        case let .first(value), let .second(value):
            cell.configure(with: value[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
}

extension SettingViewController: SettingTableViewCellDelegate {

    func didTapActionButton(with index: Int) {
        switch index {
        case SettingTableViewCellViewModel.unregister.rawValue:
            let vc = UnregisterViewController.instance()!
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let divider = UIView()
            divider.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1) // #444444
            return divider
        }
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 0
    }
}

extension SettingTableViewSection: RawRepresentable {

    typealias RawValue = Int

    var rawValue: Int {
        switch self {
        case let .first(value), let .second(value):
            return value.count
        }
    }

    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .first([.logout, .unregister])
        case 1:
            self = .second([.termsOfService, .privacyPolicy, .version])
        default:
            fatalError()
        }
    }
}
