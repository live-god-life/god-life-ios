//
//  AgreementVC.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit
import Combine
import CombineCocoa

final class AgreementVC: UIViewController {
    //MARK: - Properties
    private var user: UserModel?
    private var viewModel = UserViewModel()
    private let firstTitleLabel = UILabel().then {
        $0.text = "서비스 이용 약관에"
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let secondTitleLabel = UILabel().then {
        $0.text = "동의해주세요."
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let allAgreementItemView = AgreeButtonView().then {
        $0.titleLabel.text = "약관 전체 동의"
        $0.titleLabel.font = .semiBold(with: 18)
        $0.detailImageView.isHidden = true
        $0.agreeButton.isUserInteractionEnabled = false
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.2)
    }
    private let serviceItemView = AgreeButtonView().then {
        $0.titleLabel.text = "(필수) 서비스 이용약관"
    }
    private let privacyItemView = AgreeButtonView().then {
        $0.titleLabel.text = "(필수) 개인정보 처리방침"
    }
    private let marketingItemView = AgreeButtonView().then {
        $0.titleLabel.text = "(선택) 마케팅 정보 수신 동의"
    }
    private let nextButton = UIButton().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 27
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .semiBold(with: 18)
    }

    //MARK: - Initializer
    init() {
        self.user = UserService.userInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    //MARK: - Fuctions...
    private func makeUI() {
        view.backgroundColor = .black
        navigationItem.backButtonTitle = ""
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(firstTitleLabel)
        view.addSubview(secondTitleLabel)
        view.addSubview(allAgreementItemView)
        view.addSubview(lineView)
        view.addSubview(serviceItemView)
        view.addSubview(privacyItemView)
        view.addSubview(marketingItemView)
        view.addSubview(nextButton)

        firstTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
        secondTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstTitleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
        allAgreementItemView.snp.makeConstraints {
            $0.top.equalTo(secondTitleLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(allAgreementItemView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        serviceItemView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        privacyItemView.snp.makeConstraints {
            $0.top.equalTo(serviceItemView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        marketingItemView.snp.makeConstraints {
            $0.top.equalTo(privacyItemView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
    
    private func bind() {
        allAgreementItemView
            .gesture()
            .sink { [weak self] _ in
                guard let self else { return }
                self.allAgreementItemView.isSelected.toggle()
            }
            .store(in: &viewModel.bag)

        Publishers.CombineLatest3(serviceItemView.$isSelected,
                                  privacyItemView.$isSelected,
                                  marketingItemView.$isSelected)
            .map { $0 && $1 && $2 }
            .sink { [weak self] isSelected in
                self?.allAgreementItemView.isSelected = isSelected
            }
            .store(in: &viewModel.bag)
        
        allAgreementItemView
            .gesture()
            .map { _ in !self.allAgreementItemView.isSelected }
            .sink { [weak self] isSelected in
                self?.serviceItemView.isSelected = isSelected
                self?.privacyItemView.isSelected = isSelected
                self?.marketingItemView.isSelected = isSelected
            }
            .store(in: &viewModel.bag)
        
        serviceItemView
            .gesture()
            .sink { [weak self] _ in
                self?.viewModel.input.request.send(.terms(.use))
            }
            .store(in: &viewModel.bag)
        
        privacyItemView
            .gesture()
            .sink { [weak self] _ in
                self?.viewModel.input.request.send(.terms(.privacy))
            }
            .store(in: &viewModel.bag)
        
        marketingItemView
            .gesture()
            .sink { [weak self] _ in
                self?.viewModel.input.request.send(.terms(.marketing))
            }
            .store(in: &viewModel.bag)
        
        nextButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard self.serviceItemView.isSelected,
                      self.privacyItemView.isSelected else {
                    let alert = UIAlertController(title: "알림", message: "약관을 동의해주세요 :)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                
                guard var user = UserService.userInfo else { return }
                user.marketingYn = self.marketingItemView.isSelected ? "Y" : "N"
                
                UserDefaults.standard.set(user.toDictionary, forKey: UserService.USER_INFO_KEY)
                UserDefaults.standard.synchronize()
                
                self.viewModel.input.request.send(.signup(user))
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestSignUp
            .sink { [weak self] isComplete in
                guard let self else { return }
                
                guard isComplete else {
                    let alert = UIAlertController(title: "알림", message: "회원가입이 실패하였습니다.\n다시 시도해주세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                
                let completedVC = JoinCompleteVC()
                self.navigationController?.pushViewController(completedVC, animated: true)
            }
            .store(in: &viewModel.bag)
    }
}
