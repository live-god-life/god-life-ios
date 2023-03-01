//
//  CommonWebVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/07.
//

import Then
import SnapKit
import UIKit
import Combine
import WebKit

//MARK: CommonWebVC
final class CommonWebVC: UIViewController {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    var webView = WKWebView()
    var titleLabel = UILabel().then {
        $0.font = .semiBold(with: 20)
    }
    var closeButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-close"), for: .normal)
        $0.setImage(UIImage(named: "calendar-close"), for: .highlighted)
    }
    
    //MARK: - Life Cycle
    init(title: String?, urlString: String?) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        
        if let urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(webView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(32)
        }
        webView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        closeButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
    }
}
