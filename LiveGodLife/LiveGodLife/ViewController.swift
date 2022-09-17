//
//  ViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept": "application/json"]
        AF.request("http://192.168.33.60:8080/hello", method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    print(jsonData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}

