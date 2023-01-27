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
    //MARK: - Properties
    private var id: Int?
    weak var delegate: FeedCollectionViewCellDelegate?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var userProfileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewCountLabel: UILabel!
    @IBOutlet private weak var pickCountLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var todoCountLabel: UILabel!
    @IBOutlet private weak var todoScheduleDay: UILabel!
    @IBOutlet private weak var feedInfoView: UIView!

    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        makeUI()
    }
    
    private func makeUI() {
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

    @IBAction
    private func didTapBookmarkButton(_ sender: UIButton) {
        guard let id else { return }
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        delegate?.bookmark(feedID: id, status: bookmarkButton.isSelected)
    }
}
