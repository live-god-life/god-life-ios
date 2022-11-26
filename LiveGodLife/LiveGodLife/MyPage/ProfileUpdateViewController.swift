//
//  ProfileUpdateViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit
import Combine

final class ProfileUpdateViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: TextFieldView!
    @IBOutlet weak var imageContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    private var isHiddenImageContainerView: Bool = true
    private let imageCollectionViewModel = ImageCollectionViewModel()

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        title = "프로필 수정"

        setupProfileImageView()
        setupImageCollectionView()
        imageContainerViewBottomConstraint.constant = 400
        nicknameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.makeBorderGradation(startColor: .green, endColor: .blue)
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfileImageSelectView))
        profileImageView.addGestureRecognizer(gesture)
    }

    private func setupImageCollectionView() {
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }

    @objc func showProfileImageSelectView() {
        guard isHiddenImageContainerView else { return }

        isHiddenImageContainerView = false
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.4) {
                self?.imageContainerViewBottomConstraint.constant = 0
                self?.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func didTapImageContainerViewClose() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.4, animations: {
                self?.imageContainerViewBottomConstraint.constant = 400
                self?.view.layoutIfNeeded()
            }, completion: { _ in
                self?.isHiddenImageContainerView = true
            })
        }
    }

    @IBAction func didTapCompleteButton() {
        let nickname = nicknameTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let param: [String: String] = ["nickname": nickname]
        DefaultUserRepository().updateProfile(endpoint: .profileUpdate(param))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    // 프로필 업데이트 실패
                    print(error)
                default:
                    print("finished")
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
        profileImageView.image = UIImage(named: "frog")
    }
}

extension ProfileUpdateViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
