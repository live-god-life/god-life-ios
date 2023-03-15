//
//  JoinCompleteVC.swift
//  LiveGodLife
//
//  Created by wargi on 2022/03/08.
//

import UIKit
import Combine

final class JoinCompleteVC: UIViewController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private let firstMainTitleLabel = UILabel().then {
        $0.text = "\(UserService.userInfo?.nickname ?? "")님,"
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let secondMainTitleLabel = UILabel().then {
        $0.text = "서비스 가입을 축하해요!"
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let firstSubTitleLabel = UILabel().then {
        $0.text = "꿈꾸는 갓생러들이 모인 곳에서"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let secondSubTitleLabel = UILabel().then {
        $0.text = "\(UserService.userInfo?.nickname ?? "")님의 꿈에 다가가 보세요."
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let welcomeImageView = UIImageView().then {
        $0.image = UIImage(named: "welcomeBanner")
    }
    private let homeButton = UIButton().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 27.0
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .semiBold(with: 18)
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.addSubview(firstMainTitleLabel)
        view.addSubview(secondMainTitleLabel)
        view.addSubview(firstSubTitleLabel)
        view.addSubview(secondSubTitleLabel)
        view.addSubview(welcomeImageView)
        view.addSubview(homeButton)
        
        firstMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
        secondMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstMainTitleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
        firstSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(secondMainTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        secondSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstSubTitleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        welcomeImageView.snp.makeConstraints {
            $0.top.equalTo(secondSubTitleLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(220.7)
            $0.height.equalTo(235)
        }
        
        homeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-13)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
    
    private func bind() {
        homeButton
            .tapPublisher
            .sink { [weak self] in
                let homeVC = UINavigationController(rootViewController: RootVC())
                homeVC.modalPresentationStyle = .fullScreen
                self?.present(homeVC, animated: false, completion: {
                    self?.navigationController?.popToRootViewController(animated: false)
                })
            }
            .store(in: &bag)
    }
}
