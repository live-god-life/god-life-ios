//
//  UIViewController+Extension.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/27.
//

import UIKit

extension UIViewController {

    static func instance() -> Self? {
        let name = String(describing: self)
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: name) as? Self
    }
}
