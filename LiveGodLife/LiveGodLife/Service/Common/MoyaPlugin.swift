//
//  MoyaPlugin.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/12.
//

import UIKit
import Moya
import Combine

final class MoyaPlugin: PluginType {
    var bag = Set<AnyCancellable>()
    
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let success):
            guard let statusCode = success.response?.statusCode,
                  (200...299) ~= statusCode else {
                onFail(.statusCode(success))
                return
            }
            
            if let model = try? success.mapJSON() as? [String: Any],
               let code = model["code"] as? Int,
               code == 401 {
                
            }
        case .failure(let failure):
            onFail(failure)
        }
    }
    
    func onFail(_ error: MoyaError) {
        guard let statusCode = error.response?.response?.statusCode else {
            LogUtil.e(error.localizedDescription)
            return
        }
        
        if statusCode == 400 {
            let navi = UIApplication.topViewController()?.navigationController
            let alert = UIAlertController(title: "알림", message: "올바른 정보가 아닙니다.\n다시 신청해주세요😭", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                navi?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
        } else if statusCode == 401 {
            let vc = UIApplication.topViewController()
            let alert = UIAlertController(title: "알림", message: "회원 정보 누락으로 인해 로그아웃 됩니다.\n다시 로그인해주세요😭", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                UserDefaults.standard.removeObject(forKey: UserService.ACCESS_TOKEN_KEY)
                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.removeObject(forKey: UserService.USER_INFO_KEY)
                UserDefaults.standard.synchronize()
                vc?.dismiss(animated: true)
            }
            alert.addAction(action)
        } else if statusCode == 409 {
            let navi = UIApplication.topViewController()?.navigationController
            let alert = UIAlertController(title: "알림", message: "이미 가입된 회원입니다.\n로그인 화면으로 돌아갑니다‼️", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                UserDefaults.standard.removeObject(forKey: UserService.ACCESS_TOKEN_KEY)
                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.removeObject(forKey: UserService.USER_INFO_KEY)
                UserDefaults.standard.synchronize()
                navi?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
        } else if (500 ..< 600) ~= statusCode {
            let alert = UIAlertController(title: "서버 에러", message: "잠시후 다시 시도해주세요.\n에러 코드: \(statusCode)", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
        } else {
            LogUtil.e(error.localizedDescription)
        }
    }
}
