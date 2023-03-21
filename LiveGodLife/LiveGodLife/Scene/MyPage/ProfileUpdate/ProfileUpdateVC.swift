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
    private var bag = Set<AnyCancellable>()
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
    
    private var isHiddenImageContainerView: Bool = true
    private var imageCollectionViewModel = ImageCollectionViewModel()
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    
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
            $0.edges.equalToSuperview().inset(32)
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
        
        setupProfileImageView()
        setupImageCollectionView()
    }
    
    private func bind() {
        requestImages()
    }
    
    func configure(_ user: UserModel?) {
        self.user = user
    }

    private func requestImages() {
//        DefaultMyPageRepository().requestImages(endpoint: .images)
//            .sink { _ in
//            } receiveValue: { [weak self] asset in
//                self?.imageCollectionViewModel.data = asset
//                DispatchQueue.main.async {
//                    self?.imageCollectionView.reloadData()
//                }
//            }
//            .store(in: &bag)
    }

    private func validateNickname() {
        let text = nickNameTextField.text ?? ""
        var data = ["image": imageCollectionViewModel.selectedImage]

        if let nickname = user?.nickname, nickname != text {
            data["nickname"] = text
            repository.validateNickname(endpoint: .nickname(nickname))
                .sink(receiveCompletion: { [weak self] completion in
                    LogUtil.i("nickname: \(completion)")
                    switch completion {
                    case .failure(_):
                        self?.showPopup()
                    case .finished:
                        self?.updateUserInfo(with: data)
                    }
                }, receiveValue: { _ in })
                .store(in: &bag)
        } else {
            updateUserInfo(with: data)
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
            .store(in: &bag)
    }
    
    @objc
    private func showProfileImageSelectView() {
        guard isHiddenImageContainerView else { return }

        isHiddenImageContainerView = false
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.4) {
                self?.view.layoutIfNeeded()
            }
        }
    }

    @objc
    private func hideProfileImageSelectView() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.4, animations: {
                self?.view.layoutIfNeeded()
            }, completion: { _ in
                self?.isHiddenImageContainerView = true
            })
        }
    }
    
    @IBAction
    private func didTapImageContainerViewClose() {
        hideProfileImageSelectView()
    }

    @IBAction
    private func didTapCompleteButton() {
        validateNickname()
    }
}

extension ProfileUpdateVC {
    private func setupProfileImageView() {
        nickNameTextField.text = user?.nickname

        let radius = profileImageContainerView.frame.height / 2
        profileImageContainerView.layer.cornerRadius = radius
        profileImageContainerView.makeBorderGradation(startColor: .green, endColor: .blue, radius: radius)
        profileImageView.contentMode = .scaleAspectFit
        if let image = user?.image, let url = URL(string: image) {
            profileImageView.kf.setImage(with: url)
        }
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfileImageSelectView))
        profileImageView.addGestureRecognizer(gesture)
    }

    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.id)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    // TODO: 공통 로직으로 분리
    private func showPopup() {
        DispatchQueue.main.async { [weak self] in
            let popup = PopupView()
            popup.negativeButton.isHidden = true
            popup.configure(title: "중복된 닉네임입니다.",
                            negativeHandler: { },
                            positiveHandler: {
                popup.removeFromSuperview()
            })
            self?.view.addSubview(popup)
            popup.snp.makeConstraints {
                $0.width.equalTo(327)
                $0.height.equalTo(188)
                $0.center.equalToSuperview()
            }
        }
    }
}

extension ProfileUpdateVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionViewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let url = imageCollectionViewModel.data[indexPath.item].url else { return cell }
        cell.configure(url)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = imageCollectionViewModel.data[indexPath.item].url else {
            return
        }
        imageCollectionViewModel.selectedImage = url
        profileImageView.kf.setImage(with: URL(string: url))
    }
}

extension ProfileUpdateVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
