//
//  FeedDetailViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/12.
//

import UIKit
import SnapKit

final class FeedDetailViewController: UIViewController {

    private let baseScrollView = UIScrollView()
    private let containerView = UIView()
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = false

        // baseScrollView
        baseScrollView.contentSize = containerView.bounds.size
        view.addSubview(baseScrollView)
        baseScrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        // containerStackView
        baseScrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(view.safeAreaLayoutGuide)
        }

        // imageView
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(250)
        }
        imageView.image = UIImage(named: "frog")
        imageView.contentMode = .scaleAspectFit

        // categoryLabel
        let categoryLabel = UILabel()
        categoryLabel.text = "카테고리"
        categoryLabel.textColor = .BBBBBB
        categoryLabel.font = .regular(with: 14)
        containerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }

        let titleLabel = UILabel()
        titleLabel.text = "제목이길면제목이길면제목이길면제목이길면제목이길면제목이길면제목이길면"
        titleLabel.textColor = .white
        titleLabel.font = .bold(with: 24)
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(70)
        }

        let dividerView = UIView()
        dividerView.backgroundColor = .gray
        containerView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        let nicknameLabel = UILabel()
        nicknameLabel.text = "네카라쿠배당돌한얼음이요?"
        nicknameLabel.textColor = .white
        nicknameLabel.font = .bold(with: 20)
        nicknameLabel.numberOfLines = 1
        containerView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let text = """
        """

        let contentLabel = UILabel()
        contentLabel.attributedText = text.attributed()
        contentLabel.textColor = .white
        contentLabel.font = .medium(with: 16)
        contentLabel.numberOfLines = 0
        containerView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let dividerView2 = UIView()
        dividerView2.backgroundColor = .gray
        containerView.addSubview(dividerView2)
        dividerView2.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(58)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        let recommandTitle = UILabel()
        recommandTitle.text = "추천 리스트"
        recommandTitle.textColor = .white
        recommandTitle.font = .bold(with: 26)
        containerView.addSubview(recommandTitle)
        recommandTitle.snp.makeConstraints {
            $0.top.equalTo(dividerView2.snp.bottom).offset(69)
            $0.leading.equalToSuperview().inset(24)
        }

        let mindsetLabel = UILabel()
        mindsetLabel.text = "마인드셋"
        mindsetLabel.textColor = .white
        mindsetLabel.font = .bold(with: 20)
        containerView.addSubview(mindsetLabel)
        mindsetLabel.snp.makeConstraints {
            $0.top.equalTo(recommandTitle.snp.bottom).offset(19)
            $0.leading.equalToSuperview().inset(24)
        }

        let mindsetView = MindsetView()
        mindsetView.configure()
        containerView.addSubview(mindsetView)
        mindsetView.snp.makeConstraints {
            $0.top.equalTo(mindsetLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let todoLabel = UILabel()
        todoLabel.text = "Todo"
        todoLabel.textColor = .white
        todoLabel.font = .bold(with: 20)
        containerView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints {
            $0.top.equalTo(mindsetView.snp.bottom).offset(49)
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(34)
        }
    }
}
