//
//  UIReusable+.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import UIKit

extension UIView {
    static var id: String {
        return "\(Self.self)"
    }
}

extension UITableViewCell {
    static func register(_ target: UITableView) {
        target.register(Self.self, forCellReuseIdentifier: Self.id)
    }
    
    static func xibRegister(_ target: UITableView) {
        target.register(UINib(nibName: Self.id, bundle: nil), forCellReuseIdentifier: Self.id)
    }
}

extension UICollectionViewCell {
    static func register(_ target: UICollectionView) {
        target.register(Self.self, forCellWithReuseIdentifier: Self.id)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as? T else { fatalError() }
        
        return cell
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.id, for: indexPath) as? T else { fatalError() }
        
        return cell
    }
}
