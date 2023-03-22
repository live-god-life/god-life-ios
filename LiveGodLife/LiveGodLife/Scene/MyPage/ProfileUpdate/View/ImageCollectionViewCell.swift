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
    //MARK: - Properties
    private lazy var imageView = UIImageView().then {
        let width = contentView.frame.width - 40
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = width / 2
        $0.frame.size = CGSize(width: width, height: width)
        $0.center = contentView.center
    }

    func configure(_ image: String) {
        contentView.backgroundColor = UIColor(rgbHexString: "#1C1C1D")
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.addSubview(imageView)
        imageView.kf.setImage(with: URL(string: image))
    }
}
