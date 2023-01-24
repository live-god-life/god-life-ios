//
//  FeedCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/28.
//

import UIKit
import SnapKit
import Kingfisher

protocol FeedCollectionViewCellDelegate: AnyObject {

    func bookmark(feedID: Int, status: Bool)
}

final class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var pickCountLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var todoCountLabel: UILabel!
    @IBOutlet weak var todoScheduleDay: UILabel!
    @IBOutlet weak var feedInfoView: UIView!

    private var id: Int?

    var delegate: FeedCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 30
        bookmarkButton.setImage(UIImage(named: "bookmark_disable"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .selected)
        feedInfoView.layer.borderWidth = 1
        feedInfoView.layer.borderColor = UIColor.green.cgColor
        feedInfoView.layer.cornerRadius = feedInfoView.frame.height / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .default
    }

    func configure(with feed: Feed) {
        id = feed.id
        imageView.kf.setImage(with: URL(string: feed.image))
        userNameLabel.text = feed.user.nickname
        titleLabel.text = feed.title
        viewCountLabel.text = "\(feed.viewCount)"
        pickCountLabel.text = "\(feed.pickCount)"
        bookmarkButton.isSelected = feed.isBookmark
        todoCountLabel.text = "\(feed.todoCount) List"
        todoScheduleDay.text = "\(feed.todoScheduleDay) Day"
    }

    @IBAction func didTapBookmarkButton(_ sender: UIButton) {
        guard let id else { return }
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        delegate?.bookmark(feedID: id, status: bookmarkButton.isSelected)
    }
}
