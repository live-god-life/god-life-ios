//
//  SettingViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit
import Combine
import SnapKit

struct Empty: Decodable { }

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

    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        title = "설정"

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SettingTableViewCell.indentifier, bundle: nil), forCellReuseIdentifier: SettingTableViewCell.indentifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
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
        typealias cell = SettingTableViewCellViewModel
        switch index {
        case cell.logout.rawValue:
            DefaultUserRepository().request(UserAPI.logout)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        // 로그아웃 실패
                        LogUtil.e(error)
                    case .finished:
                        // 로그인 화면으로 이동
                        NotificationCenter.default.post(name: .moveToLogin, object: self)
                    }
                } receiveValue: { (value: Empty) in
                    //
                }
                .store(in: &bag)
            
        case cell.unregister.rawValue:
            let vc = UnregisterViewController.instance()!
            navigationController?.pushViewController(vc, animated: true)
        case cell.termsOfService.rawValue, cell.privacyPolicy.rawValue:
            guard let url = URL(string: "https://knowing-amount-d01.notion.site/e758966ec3d44c4f9f9a5c6be91d758e") else {
                return
            }
            UIApplication.shared.open(url)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let divider = UIView()
            divider.backgroundColor = .gray
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
