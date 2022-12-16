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
        profileImageView.image = UIImage(named: userProfileImage ?? "")
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
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] data in
                let images = data.compactMap { ImageAsset(name: $0) }
                let defaultImages = [ImageAsset(name: "frog1"),
                                     ImageAsset(name: "frog2"),
                                     ImageAsset(name: "frog3"),
                                     ImageAsset(name: "frog4"),
                                     ImageAsset(name: "frog5"),
                                     ImageAsset(name: "frog6")]
                self?.imageCollectionViewModel.data = images.isEmpty ? defaultImages : images
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
        let nickname = nicknameTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let param: [String: String] = ["nickname": nickname,
                                       "image": imageCollectionViewModel.selectedImage]
        DefaultUserRepository().updateProfile(endpoint: .profileUpdate(param))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    // 프로필 업데이트 실패
                    print(error)
                case .finished:
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            } receiveValue: { user in
                //
            }
            .store(in: &cancellable)
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
        cell.configure(imageCollectionViewModel.data[indexPath.item].name)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageName = imageCollectionViewModel.data[indexPath.item].name
        imageCollectionViewModel.selectedImage = imageName
        profileImageView.image = UIImage(named: imageName)
    }
}

extension ProfileUpdateViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
