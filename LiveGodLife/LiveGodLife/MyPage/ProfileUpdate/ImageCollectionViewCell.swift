//
//  ImageCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import UIKit
import Kingfisher
import SnapKit

final class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let width = contentView.frame.width - 40
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = width / 2
        imageView.frame.size = CGSize(width: width, height: width)
        imageView.center = contentView.center
        return imageView
    }()

    func configure(_ image: String) {
        contentView.addSubview(imageView)
        contentView.makeBorderGradation(startColor: .green, endColor: .blue, radius: frame.height / 2)
        imageView.kf.setImage(with: URL(string: image))
    }
}
