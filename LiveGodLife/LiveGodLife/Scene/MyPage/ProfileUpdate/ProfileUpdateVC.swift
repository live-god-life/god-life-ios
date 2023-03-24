//
//  ProfileUpdateVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit
import Combine

final class ProfileUpdateVC: UIViewController {
    //MARK: - Properties
    private let viewModel = UserViewModel()
    private var user: UserModel?
    private let repository = DefaultUserRepository()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "프로필 수정"
    }
    private let profileImageContainerView = UIView().then {
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 50.0
        let gradient = UIImage()
        let gradientColor = UIColor(patternImage: gradient
            .gradientImage(bounds: CGRect(x: 0, y: 0,
                                          width: 100.0, height: 100.0),
                           colors: [.green, .blue]))
        $0.layer.borderColor = gradientColor.cgColor
        $0.clipsToBounds = true
    }
    var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private lazy var nickNameTextField = TextFieldView().then {
        $0.delegate = self
        $0.layer.cornerRadius = 28
    }
    private let completedButton = UIButton().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 27.0
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .semiBold(with: 18)
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
        view.addSubview(profileImageContainerView)
        view.addSubview(nickNameTextField)
        view.addSubview(completedButton)
        
        profileImageContainerView.addSubview(profileImageView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        profileImageContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageContainerView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        completedButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-13)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
    
    private func bind() {
        completedButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self, let user = self.user, let newName = self.nickNameTextField.text else {
                    return
                }
                
                guard newName.validateNickname() else {
                    let alert = UIAlertController(title: "알림", message: "잘못된 형식의 닉네임입니다\n다시 설정해주세요🥲", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    return
                }
                
                if user.nickname != newName {
                    self.viewModel.input.request.send(.nickname(newName))
                } else {
                    self.viewModel.input.request.send(.profile(user.nickname, user.image ?? ""))
                }
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestNickname
            .sink { [weak self] isSuccess in
                guard let self, let user = self.user, let newName = self.nickNameTextField.text else {
                    return
                }
                
                if isSuccess {
                    self.viewModel.input.request.send(.profile(newName, user.image ?? ""))
                } else {
                    let alert = UIAlertController(title: "알림", message: "중복된 닉네임입니다🥲", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestProfile
            .sink { [weak self] isSuccess in
                guard isSuccess else {
                    let alert = UIAlertController(title: "알림", message: "수정이 실패했습니다.\n다시 시도해주세요😭", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true)
                    return
                }
                
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        profileImageContainerView
            .gesture()
            .sink { [weak self] _ in
                let selectImagePopupVC = SelectImagePopupVC()
                selectImagePopupVC.modalPresentationStyle = .overFullScreen
                selectImagePopupVC.delegate = self
                self?.present(selectImagePopupVC, animated: false)
            }
            .store(in: &viewModel.bag)
    }
    
    func configure(_ user: UserModel?) {
        self.user = user
        self.nickNameTextField.text = user?.nickname
        if let image = user?.image, let url = URL(string: image) {
            profileImageView.kf.setImage(with: url)
        }
    }

    private func updateUserInfo(with data: [String: String]) {
        repository.updateProfile(endpoint: .profileUpdate(data))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    LogUtil.e(error)
                case .finished:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } receiveValue: { _ in }
            .store(in: &viewModel.bag)
    }
}

extension ProfileUpdateVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileUpdateVC: SelectImagePopupVCDelegate {
    func select(urlString: String?) {
        guard let urlString, let imageUrl = URL(string: urlString) else { return }
        
        user?.image = urlString
        profileImageView.kf.setImage(with: imageUrl)
    }
}
