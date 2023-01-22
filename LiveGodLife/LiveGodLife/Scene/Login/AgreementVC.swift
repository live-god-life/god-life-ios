//
//  AgreementVC.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit
import Combine

final class AgreementVC: UIViewController {
    //MARK: - Properties
    let nextButton = UIButton()
    private var user: UserModel
    private var cancellable = Set<AnyCancellable>()

    //MARK: - Initializer
    init(_ user: UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    //MARK: - Fuctions...
    private func makeUI() {
        view.backgroundColor = .black
        navigationItem.backButtonTitle = ""
        navigationController?.isNavigationBarHidden = false
        
        let mainTitleLabel = UILabel()
        let allAgreementLabel = UILabel()
        let lineView = UIView()
        let serviceLabel = UILabel()
        let privacyLabel = UILabel()
        let marketingLabel = UILabel()
        
        mainTitleLabel.text = "서비스 이용 약관에\n동의해주세요."
        mainTitleLabel.textColor = .white
        mainTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 26)
        mainTitleLabel.numberOfLines = 0
        
        allAgreementLabel.text = "약관 전체 동의"
        allAgreementLabel.textColor = .white
        allAgreementLabel.font = UIFont(name: "Pretendard", size: 18)
        allAgreementLabel.numberOfLines = 0
        
        lineView.backgroundColor = .white
        
        serviceLabel.text = "(필수) 서비스 이용약관"
        serviceLabel.textColor = .BBBBBB
        serviceLabel.font = UIFont(name: "Pretendard", size: 18)
        serviceLabel.numberOfLines = 0

        privacyLabel.text = "(필수) 개인정보 처리방침"
        privacyLabel.textColor = .BBBBBB
        privacyLabel.font = UIFont(name: "Pretendard", size: 18)
        privacyLabel.numberOfLines = 0
        
        marketingLabel.text = "(선택) 마케팅 정보 수신 동의"
        marketingLabel.textColor = .BBBBBB
        marketingLabel.font = UIFont(name: "Pretendard", size: 18)
        marketingLabel.numberOfLines = 0
        
        self.nextButton.backgroundColor = .green
        self.nextButton.layer.cornerRadius = 25
        self.nextButton.setTitle("다음", for: .normal)
        self.nextButton.setTitleColor(.black, for: .normal)
        self.nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        
        view.addSubview(mainTitleLabel)
        view.addSubview(allAgreementLabel)
        view.addSubview(lineView)
        view.addSubview(serviceLabel)
        view.addSubview(privacyLabel)
        view.addSubview(marketingLabel)
        view.addSubview(self.nextButton)

  
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(63)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
            $0.height.equalTo(68)
        }
        allAgreementLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(58)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(allAgreementLabel.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-26)
            $0.height.equalTo(1)
        }
        serviceLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
        }
        privacyLabel.snp.makeConstraints {
            $0.top.equalTo(serviceLabel.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
        }
        marketingLabel.snp.makeConstraints {
            $0.top.equalTo(privacyLabel.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
        }
        self.nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.left.equalTo(view).offset(16)
            $0.right.equalTo(view).offset(-16)
            $0.height.equalTo(56)
        }
    }
    
    @objc
    private func next(_ sender: UIButton) {
        // 회원가입
        DefaultUserRepository().signup(endpoint: .signup(user))
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] token in
                LogUtil.i(token)
                guard let self else { return }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(JoinCompleteVC(self.user), animated: true)
                }
            })
            .store(in: &cancellable)
    }
}
