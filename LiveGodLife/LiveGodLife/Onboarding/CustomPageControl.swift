//
//  CustomPageControl.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/13.
//

import UIKit

class CustomPageControl: UIPageControl {

    static let currentPageImage = UIImage(named: "gradation_btn")

    override var currentPage: Int {
        didSet {
            if oldValue == currentPage { return }
            setIndicatorImage(CustomPageControl.currentPageImage, forPage: currentPage)
            setIndicatorImage(nil, forPage: oldValue)
        }
    }
}
