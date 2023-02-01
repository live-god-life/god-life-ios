//
//  HomeFeedCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/28.
//

import UIKit
import SnapKit
import Kingfisher

protocol FeedTableViewCellDelegate: AnyObject {
    func bookmark(feedID: Int, status: Bool)
}

final class FeedTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var id: Int?
    weak var delegate: FeedTableViewCellDelegate?
    
    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var userProfileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var viewCountLabel: UILabel!
    @IBOutlet private weak var pickCountLabel: UILabel! // 가져가기
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var todoCountLabel: UILabel!
    @IBOutlet private weak var todoScheduleDay: UILabel!
    @IBOutlet private weak var feedInfoView: UIView!

    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
    }

    //MARK: - Functions...
    private func makeUI() {
        backgroundColor = .background
        
        bookmarkButton.setImage(UIImage(named: "bookmark_disable"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .selected)
        
        feedInfoView.layer.borderWidth = 1
        feedInfoView.layer.borderColor = UIColor.green.cgColor
        feedInfoView.layer.cornerRadius = feedInfoView.frame.height / 2
        
        feedImageView.backgroundColor = .default
        feedImageView.layer.cornerRadius = 30
    }
    
    func configure(with feed: Feed) {
        id = feed.id
        feedImageView.contentMode = .scaleAspectFill
        feedImageView.kf.setImage(with: URL(string: feed.image))
        userNameLabel.text = feed.user.nickname
        viewCountLabel.text = "\(feed.viewCount)"
        pickCountLabel.text = "\(feed.pickCount)"
        titleLabel.text = feed.title
        bookmarkButton.isSelected = feed.isBookmark
        todoCountLabel.text = "\(feed.todoCount) List"
        todoScheduleDay.text = "\(feed.todoScheduleDay) Day"
    }

    @IBAction
    private func didTapBookmarkButton(_ sender: UIButton) {
        // throttle?
        guard let id = id else { return }
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        LogUtil.d(bookmarkButton.isSelected)
        delegate?.bookmark(feedID: id, status: bookmarkButton.isSelected)
    }
}