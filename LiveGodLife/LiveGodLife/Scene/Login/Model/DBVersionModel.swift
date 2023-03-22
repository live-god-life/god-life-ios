//
//  DBVersionModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/27.
//

import Foundation
import Firebase

final class DBVersionModel: NSObject {
    var lastest_version_code: String        /** 최신버전 코드     */
    var lastest_version_name: String        /** 최신버전 명      */
    var minimum_version_code: String        /** 최소버전 코드     */
    var minimum_version_name: String        /** 최소버전 명      */
    
    
    init(lastest_version_code: String, lastest_version_name: String,
         minimum_version_code: String, minimum_version_name: String) {
        
        self.lastest_version_code       = lastest_version_code
        self.lastest_version_name       = lastest_version_name
        self.minimum_version_code       = minimum_version_code
        self.minimum_version_name       = minimum_version_name
    }
    
    convenience override init() {
        self.init(lastest_version_code: "", lastest_version_name: "",
                  minimum_version_code: "", minimum_version_name: "")
    }
}

//MARK: - 버전 체크
extension DBVersionModel {
    static func appVersionCheck() {
        let ref = Database.database().reference()

        let data = ref.child("version")
        
        data.observeSingleEvent(of: .value, with: { snapshot in
            guard let versionData = snapshot.value as? NSDictionary,
                  let versionDic = versionData as? [String: String],
                  let lastest_version_code = versionDic["lastest_version_code"],
                  let lastest_version_name = versionDic["lastest_version_name"],
                  let minimum_version_code = versionDic["minimum_version_code"],
                  let minimum_version_name = versionDic["minimum_version_name"]
            else { return }
            
            let versionDbData = DBVersionModel(lastest_version_code: lastest_version_code,
                                              lastest_version_name: lastest_version_name,
                                              minimum_version_code: minimum_version_code,
                                              minimum_version_name: minimum_version_name)
            
            checkUpdateVersion(dbdata: versionDbData)
        })
    }
    
    static private func checkUpdateVersion(dbdata: DBVersionModel){
        let appLastestVersion = dbdata.lastest_version_code
        let appMinimumVersion = dbdata.minimum_version_code
        let appLastestVersionName = dbdata.lastest_version_name
        let appMinimumVersionName = dbdata.minimum_version_name
        
        guard let infoDic = Bundle.main.infoDictionary,
              let appBuildVersion = infoDic["CFBundleVersion"] as? String,
              let appVersionName = infoDic["CFBundleShortVersionString"] as? String,
              let _appBuildVersion = Int(appBuildVersion),
              let _appMinimumVersion = Int(appMinimumVersion),
              let _appLastestVersion = Int(appLastestVersion) else { return }
        
        #if DEBUG
        return
        #else
        if (appVersionName < appMinimumVersionName) ||
            (appVersionName == appMinimumVersionName &&
             _appBuildVersion < _appMinimumVersion)  {
            forceUdpateAlert()
        } else if appVersionName < dbdata.lastest_version_name ||
                    (appVersionName == appLastestVersionName &&
                     _appBuildVersion < _appLastestVersion) {
            optionalUpdateAlert(version: _appLastestVersion)
        }
        #endif
    }
    
    static private func forceUdpateAlert() {
        let msg = "최신 버전의 앱으로 업데이트해주세요."
        let refreshAlert = UIAlertController(title: "업데이트 알림", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            let id = "6446139522"
            if let appURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)"),
               UIApplication.shared.canOpenURL(appURL) {
                // 유효한 URL인지 검사
                if #available(iOS 10.0, *) { //iOS 10.0부터 URL를 오픈하는 방법이 변경 되었습니다.
                    UIApplication.shared.open(appURL, options: [:]) { _ in
                        exit(0)
                    }
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        }
        
        refreshAlert.addAction(okAction)
        UIApplication.topViewController()?.present(refreshAlert,
                                                   animated: true,
                                                   completion: nil)
    }
    
    static private func optionalUpdateAlert(version:Int) {
        let msg = "새로운 버전이 출시되었습니다.\n업데이트를 하지 않는 경우 서비스 이용에 제한이 있을 수 있습니다. 업데이트를 진행하시겠습니까?"
        let refreshAlert = UIAlertController(title: "업데이트", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "지금 업데이트 하기", style: .default) { _ in
            let id = "6446139522"
            if let appURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)"),
               UIApplication.shared.canOpenURL(appURL) {
                // 유효한 URL인지 검사
                if #available(iOS 10.0, *) { //iOS 10.0부터 URL를 오픈하는 방법이 변경 되었습니다.
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "나중에 하기", style: .destructive, handler: nil)
        refreshAlert.addAction(cancelAction)
        refreshAlert.addAction(okAction)
        
        UIApplication.topViewController()?.present(refreshAlert,
                                                   animated: true,
                                                   completion: nil)
    }
}
