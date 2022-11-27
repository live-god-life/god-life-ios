//
//  MasterViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import Foundation
import UIKit
class MasterViewController {
    /// 싱글톤
    static let shared: MasterViewController = {
        let master = MasterViewController()
        return master
    }()
   

}
