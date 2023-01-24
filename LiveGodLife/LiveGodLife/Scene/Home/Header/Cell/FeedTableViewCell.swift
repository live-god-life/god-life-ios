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

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var pickCountLabel: UILabel! // 가져가기
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var todoCountLabel: UILabel!
    @IBOutlet weak var todoScheduleDay: UILabel!
    @IBOutlet weak var feedInfoView: UIView!

    weak var delegate: FeedTableViewCellDelegate?

    private var id: Int?

    override func awakeFromNib() {
        super.awakeFromNib()

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

    @IBAction func didTapBookmarkButton(_ sender: UIButton) {
        // throttle?
        guard let id = id else { return }
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        LogUtil.d(bookmarkButton.isSelected)
        delegate?.bookmark(feedID: id, status: bookmarkButton.isSelected)
    }
}
