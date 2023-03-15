//
//  CommonTextVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/07.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

//MARK: CommonWebVC
final class CommonTextVC: UIViewController {
    enum Const {
        static let topSpacing: CGFloat = 162.0
        static let height = UIScreen.main.bounds.height - topSpacing + 44.0
    }
    
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let startAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    let endAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn)
    
    var textView = UITextView().then {
        $0.isEditable = false
        $0.font = .regular(with: 16)
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.backgroundColor = .black
    }
    var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    var closeButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-close"), for: .normal)
        $0.setImage(UIImage(named: "calendar-close"), for: .highlighted)
    }
    private let visualEffectView = CustomVisualEffectView()
    private let contentView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 24.0
    }
    
    
    //MARK: - Life Cycle
    init(title: String?, content: String?) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        textView.attributedText = content?.lineAndLetterSpacing(font: .regular(with: 16),
                                                                lineHeight: 26)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.backgroundColor = .clear
        
        view.addSubview(visualEffectView)
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(textView)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(Const.height)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Const.height)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(32)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-44)
        }
        
        startAnimator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.contentView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(44)
            }
            self.view.layoutIfNeeded()
        }
        
        endAnimator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.contentView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(Const.height)
            }
            self.view.layoutIfNeeded()
        }
        
        endAnimator.addCompletion { [weak self] _ in
            self?.dismiss(animated: false)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        closeButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.endAnimator.startAnimation()
            }
            .store(in: &bag)
        
        visualEffectView
            .backgroundButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.endAnimator.startAnimation()
            }
            .store(in: &bag)
    }
}
