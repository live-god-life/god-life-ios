//
//  ProfileUpdateViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit
import Combine

final class ProfileUpdateViewController: UIViewController {

    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: TextFieldView!
    @IBOutlet weak var imageContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var dimmedView: UIView!

    var userProfileImage: String?

    private var isHiddenImageContainerView: Bool = true
    private let repository: UserRepository = DefaultUserRepository()
    private var imageCollectionViewModel = ImageCollectionViewModel()

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        title = "프로필 수정"

        setupProfileImageView()
        setupImageCollectionView()
        imageContainerViewBottomConstraint.constant = 400
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideProfileImageSelectView))
        dimmedView.addGestureRecognizer(gesture)
        nicknameTextField.delegate = self

        requestImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    private func setupProfileImageView() {
        let radius = profileImageContainerView.frame.height / 2
        profileImageContainerView.layer.cornerRadius = radius
        profileImageContainerView.makeBorderGradation(startColor: .green, endColor: .blue, radius: radius)
        profileImageView.contentMode = .scaleAspectFit
        if let image = userProfileImage, let url = URL(string: image) {
            profileImageView.kf.setImage(with: url)
        }
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfileImageSelectView))
        profileImageView.addGestureRecognizer(gesture)
    }

    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }

    @objc private func showProfileImageSelectView() {
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

    @objc private func hideProfileImageSelectView() {
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

    func requestImages() {
        DefaultMyPageRepository().requestImages(endpoint: .images)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] asset in
                self?.imageCollectionViewModel.data = asset
                DispatchQueue.main.async {
                    self?.imageCollectionView.reloadData()
                }
            }
            .store(in: &cancellable)
    }

    @IBAction func didTapImageContainerViewClose() {
        hideProfileImageSelectView()
    }

    @IBAction func didTapCompleteButton() {
        // 닉네임 중복 체크
        let nickname = nicknameTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let data = ["nickname": nickname,
                    "image": imageCollectionViewModel.selectedImage]

        repository.validateNickname(endpoint: .nickname(nickname))
            .sink(receiveCompletion: { completion in
                print("nickname: \(completion)")
                switch completion {
                case .failure(_):
                    self.showPopup()
                case .finished:
                    self.updateUserInfo(with: data)
                }
            }, receiveValue: { value in
                print(value)

            })
            .store(in: &cancellable)
    }

    func updateUserInfo(with data: [String: String]) {
        repository.updateProfile(endpoint: .profileUpdate(data))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellable)
    }

    // TODO: 공통 로직으로 분리
    func showPopup() {
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

extension ProfileUpdateViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionViewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
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

extension ProfileUpdateViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
