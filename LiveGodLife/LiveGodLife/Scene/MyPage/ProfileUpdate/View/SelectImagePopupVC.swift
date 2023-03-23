//
//  SelectImagePopupVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/28.
//

import Then
import SnapKit
import UIKit
import Combine

protocol SelectImagePopupVCDelegate: AnyObject {
    func select(urlString: String?)
}

//MARK: SelectImagePopupVC
final class SelectImagePopupVC: UIViewController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: SelectImagePopupVCDelegate?
    private var imageCollectionViewModel = ImageCollectionViewModel()
    private let visualEffectView = CustomVisualEffectView()
    private let containerView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 24.0
    }
    private let titleLabel = UILabel().then {
        $0.text = "기본 이미지"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let cancelButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-close"), for: .normal)
        $0.setImage(UIImage(named: "calendar-close"), for: .highlighted)
    }
    private lazy var imageCollectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = false
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        ImageCollectionViewCell.register($0)
    }
    let startAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    let endAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimator.startAnimation()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        let containerHeight = (UIScreen.main.bounds.width - 72) / 3 * 2 + 176.0
        print(containerHeight)
        view.backgroundColor = .clear
        
        view.addSubview(visualEffectView)
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(imageCollectionView)
        containerView.addSubview(cancelButton)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(containerHeight + 100.0)
            $0.height.equalTo(containerHeight)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(44)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(32)
        }
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        startAnimator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.containerView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            }
            self.view.layoutIfNeeded()
        }
        
        endAnimator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.containerView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(containerHeight + 100.0)
            }
            self.view.layoutIfNeeded()
        }
        
        endAnimator.addCompletion { [weak self] _ in
            self?.dismiss(animated: false)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        visualEffectView
            .backgroundButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.endAnimator.startAnimation()
            }
            .store(in: &bag)
        
        cancelButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.endAnimator.startAnimation()
            }
            .store(in: &bag)
        
        imageCollectionViewModel
            .$data
            .sink { [weak self] _ in
                self?.imageCollectionView.reloadData()
            }
            .store(in: &bag)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width - 72
        layout.itemSize = .init(width: width / 3, height: width / 3)
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 12.0
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0,
                                           bottom: 32.0, right: 24.0)
        return layout
    }
}

extension SelectImagePopupVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionViewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let url = imageCollectionViewModel.data[indexPath.item].url else { return cell }
        cell.configure(url)
        return cell
    }
}

extension SelectImagePopupVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = imageCollectionViewModel.data[indexPath.item].url else { return }
        
        delegate?.select(urlString: urlString)
        endAnimator.startAnimation()
    }
}
