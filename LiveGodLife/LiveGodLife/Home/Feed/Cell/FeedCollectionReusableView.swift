//
//  FeedCollectionReusableView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/07.
//

import UIKit
import SnapKit

class FeedCollectionReusableView: UICollectionReusableView {

    static let identifier = "FeedCollectionReusableView"

    @IBOutlet weak var titleLabel: UILabel!

    private(set) var filterView: CategoryFilterView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let items: [Category] = []
        filterView = CategoryFilterView(frame: bounds, items: items)
        addSubview(filterView)
        filterView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func setupCategoryItems(_ items: [Category] ) {
        filterView.update(items: items)
    }
}