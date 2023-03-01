//
//  JoinCompleteVC.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit
import Combine

final class JoinCompleteVC: UIViewController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private let homeButton = UIButton()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let mainTitleLabel = UILabel()
        let subTitleLabel = UILabel()
        
        mainTitleLabel.text = "\(UserService.userInfo?.nickname ?? "")님,\n서비스 가입을 축하해요!"
        mainTitleLabel.textColor = .white
        mainTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 26)
        mainTitleLabel.numberOfLines = 0
        
        subTitleLabel.text = "꿈꾸는 갓생러들이 모인 곳에서\n이든님의 꿈에 다가가 보세요."
        subTitleLabel.textColor = .white
        subTitleLabel.font = UIFont(name: "Pretendard", size: 18)
        subTitleLabel.numberOfLines = 0
        
     
        self.homeButton.backgroundColor = .green
        self.homeButton.layer.cornerRadius = 25
        self.homeButton.setTitle("홈으로", for: .normal)
        self.homeButton.setTitleColor(.black, for: .normal)
        
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(self.homeButton)

  
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(63)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
            $0.height.equalTo(68)
        }
        self.homeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.left.equalTo(view).offset(16)
            $0.right.equalTo(view).offset(-16)
            $0.height.equalTo(56)
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
