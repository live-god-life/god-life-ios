//
//  ImageCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import UIKit
import SnapKit

final class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let width = contentView.frame.width - 10
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = width / 2
        imageView.frame.size = CGSize(width: width, height: width)
        imageView.center = contentView.center
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.makeBorderGradation(startColor: .green, endColor: .blue)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ image: String) {
        imageView.image = UIImage(named: image)
    }
}
