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
    private var isHiddenImageContainerView: Bool = true
    private var imageCollectionViewModel = ImageCollectionViewModel()
    
    @IBOutlet private weak var profileImageContainerView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nicknameTextField: TextFieldView!
    @IBOutlet private weak var imageContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    @IBOutlet private weak var dimmedView: UIView!

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .background

        title = "프로필 수정"
        
        setupProfileImageView()
        setupImageCollectionView()
        imageContainerViewBottomConstraint.constant = 400
    }
    
    private func bind() {
        nicknameTextField.delegate = self

        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideProfileImageSelectView))
        dimmedView.addGestureRecognizer(gesture)

        requestImages()
    }
    
    func configure(_ user: UserModel?) {
        self.user = user
    }

    private func requestImages() {
        DefaultMyPageRepository().requestImages(endpoint: .images)
            .sink { _ in
            } receiveValue: { [weak self] asset in
                self?.imageCollectionViewModel.data = asset
                DispatchQueue.main.async {
                    self?.imageCollectionView.reloadData()
                }
            }
            .store(in: &bag)
    }

    private func validateNickname() {
        let text = nicknameTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
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
            self?.dimmedView.isHidden = false
            self?.imageContainerViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.4) {
                self?.view.layoutIfNeeded()
            }
        }
    }

    @objc
    private func hideProfileImageSelectView() {
        DispatchQueue.main.async { [weak self] in
            self?.imageContainerViewBottomConstraint.constant = 400
            UIView.animate(withDuration: 0.4, animations: {
                self?.view.layoutIfNeeded()
            }, completion: { _ in
                self?.dimmedView.isHidden = true
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
        nicknameTextField.text = user?.nickname

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
