//
//  JoinCompleteViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit

class JoinCompleteViewController: UIViewController {
    let homeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupUI()
    }

    private func setupUI() {
        let mainTitleLabel = UILabel()
        let subTitleLabel = UILabel()
        
        mainTitleLabel.text = "이든님,\n서비스 가입을 축하해요!"
        mainTitleLabel.textColor = .white
        mainTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 26)
        mainTitleLabel.numberOfLines = 0
        
        subTitleLabel.text = "꿈꾸는 갓생러들이 모인 곳에서\n이든님의 꿈에 다가가 보세요."
        subTitleLabel.textColor = .white
        subTitleLabel.font = UIFont(name: "Pretendard", size: 18)
        subTitleLabel.numberOfLines = 0
        
     
        self.homeButton.backgroundColor = .green
        self.homeButton.layer.cornerRadius = 25
        self.homeButton.setTitle("홈으로", for: .normal)
        self.homeButton.setTitleColor(.black, for: .normal)
        self.homeButton.addTarget(self, action: #selector(home(_:)), for: .touchUpInside)
        
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(self.homeButton)

  
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(63)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
            $0.height.equalTo(68)
        }
        self.homeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.left.equalTo(view).offset(16)
            $0.right.equalTo(view).offset(-16)
            $0.height.equalTo(56)
        }
    }
    
    @objc func home(_ sender:UIButton) {
        self.dismiss(animated: true)
        // 회원가입 성공
        UserDefaults.standard.set(true, forKey: "IS_LOGIN") // 키체인으로 변경해야 함
        NotificationCenter.default.post(name: .moveToHome, object: self)
    }

}
