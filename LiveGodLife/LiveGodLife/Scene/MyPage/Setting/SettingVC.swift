//
//  SettingVC.swift
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

final class SettingVC: UIViewController {
    //MARK: - Properties
    private var viewModel = UserViewModel()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "설정"
    }
    private let logoutItem = SettingMenuView(title: "로그아웃")
    private let withdrawalItem = SettingMenuView(title: "회원탈퇴")
    private let serviceItem = SettingMenuView(title: "서비스 이용약관")
    private let privacyItem = SettingMenuView(title: "개인정보처리방침")
    private let versionItem = SettingMenuView(title: "버전정보").then {
        $0.versionLabel.isHidden = false
        $0.accessoryImageView.isHidden = true
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(navigationView)
        view.addSubview(logoutItem)
        view.addSubview(withdrawalItem)
        view.addSubview(serviceItem)
        view.addSubview(privacyItem)
        view.addSubview(versionItem)

        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        logoutItem.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        withdrawalItem.snp.makeConstraints {
            $0.top.equalTo(logoutItem.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        serviceItem.snp.makeConstraints {
            $0.top.equalTo(withdrawalItem.snp.bottom).offset(41)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        privacyItem.snp.makeConstraints {
            $0.top.equalTo(serviceItem.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        versionItem.snp.makeConstraints {
            $0.top.equalTo(privacyItem.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    private func bind() {
        logoutItem
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let alert = UIAlertController(title: "알림", message: "정말로 로그아웃 하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    UserDefaults.standard.removeObject(forKey: UserService.ACCESS_TOKEN_KEY)
                    UserDefaults.standard.synchronize()
                    
                    UserDefaults.standard.removeObject(forKey: UserService.USER_INFO_KEY)
                    UserDefaults.standard.synchronize()
                    
                    self?.dismiss(animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self?.present(alert, animated: true)
            }
            .store(in: &viewModel.bag)
        
        withdrawalItem
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let unregisterVC = UnregisterVC()
                unregisterVC.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(unregisterVC, animated: true)
            }
            .store(in: &viewModel.bag)
        
        serviceItem
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.request.send(.terms(.use))
            }
            .store(in: &viewModel.bag)
        
        privacyItem
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.input.request.send(.terms(.privacy))
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestTerms
            .sink { [weak self] term in
                
                guard let self,
                      let type = term.type,
                      let contents = term.contents else { return }
                
                var vc: UIViewController
                
                switch type {
                case .use:
                    vc = CommonTextVC(title: "서비스 이용약관", content: contents)
                case .privacy:
                    vc = CommonTextVC(title: "개인정보 처리방침", content: contents)
                case .marketing:
                    vc = CommonTextVC(title: "마케팅 정보 수신 동의", content: contents)
                }
                
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }
            .store(in: &viewModel.bag)
    }
}
