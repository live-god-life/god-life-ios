//
//  SettingViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit
import SnapKit

final class SettingViewController: UIViewController {

    private let tableView = UITableView()

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
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingTableViewCellViewModel.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.indentifier, for: indexPath) as? SettingTableViewCell else {
            preconditionFailure()
        }
        cell.configure(with: SettingTableViewCellViewModel.allCases[indexPath.row])
        cell.delegate = self
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
}
