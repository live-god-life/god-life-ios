//
//  CustomPageControl.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/13.
//

import UIKit

final class CustomPageControl: UIPageControl {
    //MARK: - Properties
    static let currentPageImage = UIImage(named: "gradation_btn")

    override var currentPage: Int {
        didSet {
            if oldValue == currentPage { return }
            setIndicatorImage(CustomPageControl.currentPageImage, forPage: currentPage)
            setIndicatorImage(nil, forPage: oldValue)
        }
    }
}
