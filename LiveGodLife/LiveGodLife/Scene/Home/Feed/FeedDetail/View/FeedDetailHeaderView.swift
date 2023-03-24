//
//  FeedDetailHeaderView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import UIKit
//MARK: FeedDetailHeaderView
final class FeedDetailHeaderView: UIView {
    //MARK: - Properties
    private let imageView = UIImageView()
    private let viewImageView = UIImageView().then {
        $0.image = UIImage(named: "eye")
    }
    private let viewCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .montserrat(with: 16, weight: .regular)
    }
    private let downloadImageView = UIImageView().then {
        $0.image = UIImage(named: "download")
    }
    private let downloadCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .montserrat(with: 16, weight: .regular)
    }
    private let categoryLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.font = .semiBold(with: 24)
    }
    private let listImageView = UIImageView().then {
        $0.image = UIImage(named: "lightning")
    }
    private let listCountLabel = UILabel().then {
        $0.textColor = .green
        $0.font = .montserrat(with: 16, weight: .semibold)
    }
    private let calendarImageView = UIImageView().then {
        $0.image = UIImage(named: "calendar")
    }
    private let daysLabel = UILabel().then {
        $0.textColor = .green
        $0.font = .montserrat(with: 16, weight: .semibold)
    }
    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmark_disable"), for: .normal)
        $0.setImage(UIImage(named: "bookmark"), for: .highlighted)
        $0.setImage(UIImage(named: "bookmark"), for: .selected)
    }
    private let lineView = UIView().then {
        $0.backgroundColor = UIColor(rgbHexString: "32323F")
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        addSubview(imageView)
        addSubview(viewImageView)
        addSubview(viewCountLabel)
        addSubview(downloadImageView)
        addSubview(downloadCountLabel)
        addSubview(categoryLabel)
        addSubview(titleLabel)
        addSubview(listImageView)
        addSubview(listCountLabel)
        addSubview(calendarImageView)
        addSubview(daysLabel)
        addSubview(favoriteButton)
        addSubview(lineView)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(242)
        }
        downloadCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(24)
        }
        downloadImageView.snp.makeConstraints {
            $0.centerY.equalTo(downloadCountLabel.snp.centerY)
            $0.right.equalTo(downloadCountLabel.snp.left).offset(-4)
            $0.size.equalTo(16)
        }
        viewCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(downloadImageView.snp.centerY)
            $0.right.equalTo(downloadImageView.snp.left).offset(-8)
            $0.height.equalTo(24)
        }
        viewImageView.snp.makeConstraints {
            $0.centerY.equalTo(viewCountLabel.snp.centerY)
            $0.right.equalTo(viewCountLabel.snp.left).offset(-4)
            $0.size.equalTo(16)
        }
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(64)
        }
        listCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(40)
            $0.height.equalTo(40)
        }
        listImageView.snp.makeConstraints {
            $0.centerY.equalTo(listCountLabel.snp.centerY)
            $0.right.equalTo(listCountLabel.snp.left).offset(-7.1)
            $0.width.equalTo(9.8)
            $0.height.equalTo(15)
        }
        calendarImageView.snp.makeConstraints {
            $0.centerY.equalTo(listCountLabel.snp.centerY)
            $0.left.equalTo(listCountLabel.snp.right).offset(11)
            $0.size.equalTo(10)
        }
        daysLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalTo(calendarImageView.snp.right).offset(7)
            $0.height.equalTo(40)
        }
        favoriteButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(daysLabel.snp.centerY)
            $0.size.equalTo(40)
        }
        lineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(with feed: Feed?) {
        guard let feed else { return }
        
        imageView.kf.setImage(with: URL(string: feed.image))
        viewCountLabel.text = "\(feed.viewCount)"
        downloadCountLabel.text = "\(feed.pickCount)"
        categoryLabel.text = CategoryCode.name(category: feed.category)
        titleLabel.text = feed.title
        listCountLabel.text = "\(feed.todoCount) List"
        daysLabel.text = "\(feed.todoScheduleDay) Day"
        favoriteButton.isSelected = feed.isBookmark
    }
}
