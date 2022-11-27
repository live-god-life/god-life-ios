//
//  TodoListTableViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/15.
//

import UIKit
import SwiftyJSON

/**
 알림함 탭 열거형
 - 탭타입에 따라 해당 알림만 표시 한다.
 */
enum TodoType: Int {
    /// 캘린더
    case calendar
    /// 마인드셋
    case mindSet
    /// 목표
    case goals
}

class TodoListTableViewController: UIViewController {
    
    private var focusType:TodoType = .calendar
    
    private let allLineView     = UIView()
    private let oilLineView     = UIView()
    private let washLineView    = UIView()
    
    private let totalLabel      = UILabel()
    private let totalLabel1     = UILabel()
    private let totalLabel2     = UILabel()
    
    private let tableLine       = UIView()
    private let tableView       = UITableView()
    
    lazy var footerView:UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: self.tableView.frame.width, height: 30))
        let moreLabel = UILabel()
        let moreIcon = UIImageView()
        let lineView = UIView()
        
//        moreLabel.attributedText = "더보기".localized.con13Gray9
//        moreIcon.image = #imageLiteral(resourceName: "iconMore")
        
        view.addSubview(moreLabel)
        view.addSubview(moreIcon)
        view.addSubview(lineView)
        
        moreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        moreIcon.snp.makeConstraints { make in
            make.top.equalTo(moreLabel)
            make.left.equalTo(moreLabel.snp.right).offset(5)
            make.height.equalTo(12)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(moreLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(51)
            make.height.equalTo(1)
        }
//        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(self.more(_:)))

//        moreLabel.isUserInteractionEnabled = true
//        moreLabel.addGestureRecognizer(tapGesture)

        return view
    }()
    //
    @objc func more(_ sender:UITapGestureRecognizer){
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.footerSelected(.Non)
        self.init_UI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = "알림함"
        let url = "/noticeactivity"
        /// GA-Page 알림함
    }
}

extension TodoListTableViewController {
    
    // MARK: - Button Action
    
    
}
//
//// MARK: - TableView Delegate
//extension TodoListTableViewController: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        switch self.focusType {
//        case .calendar:
//            return 1
//        case .mindSet:
//            return 1
//        case .goals:
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    //#앱크래쉬
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell:PushItemCell = tableView.dequeueReusableCell(withIdentifier: "PushItemCell", for: indexPath) as? PushItemCell else {
//            return UITableViewCell()
//        }
//        if self.allData.count == 0 {
//            return cell
//        }
//
//        var itemArray:[JSON] = []
//        var itemHeader: String = ""
//        if let items = self.allData[safe: indexPath.section] {
//            itemArray = items["data"].arrayValue
//            itemHeader = items["dateGroup"].stringValue
//        }
//
//        switch self.focusPush {
//        case .oil:
//            guard self.oilData.count != 0 else {
//                return cell
//            }
//            guard let items = self.oilData[safe: indexPath.section] else {
//                return cell
//            }
//
//            itemArray = items["data"].arrayValue
//            itemHeader = items["dateGroup"].stringValue
//        case .all:
//            break
//        case .wash:
//            guard self.washData.count != 0 else {
//                return cell
//            }
//            guard let items = self.washData[safe: indexPath.section] else {
//                return cell
//            }
//            itemArray = items["data"].arrayValue
//            itemHeader = items["dateGroup"].stringValue
//        case .etc:
//            guard self.etcData.count != 0 else {
//                return cell
//            }
//            guard let items = self.etcData[safe: indexPath.section] else {
//                return cell
//            }
//            itemArray = items["data"].arrayValue
//            itemHeader = items["dateGroup"].stringValue
//        }
//
//        guard let item = itemArray[safe: indexPath.row] else {
//            return cell
//        }
//
//        let dateString      = item["date"].stringValue
//        let link            = item["link"].stringValue
//        let categoryname    = item["categoryname"].stringValue
//
//        if indexPath.row == 0 {
//            cell.headerView.isHidden = false
//            cell.headerDate.text = itemHeader
//            cell.setHearder(indexPath.section == 0)
//        } else {
//            cell.headerView.isHidden = true
//            cell.setHearder(false)
//        }
//
//        cell.icon.image = #imageLiteral(resourceName: "img_etc")
//        if "OIL" == categoryname {
//            cell.icon.image = #imageLiteral(resourceName: "img_oil")
//        } else if "WSH" == categoryname {
//            cell.icon.image = #imageLiteral(resourceName: "img_wash")
//        }
//        cell.dateLabel.text = UIApplication.getDotDateTime(dateString)
//        cell.iconCancel.isHidden = !self.isDelete
//        cell.titleLabel.text = item["title"].stringValue
//        cell.messageLabel.text = item["content"].stringValue
//        cell.linkLabel.isHidden = link.count < 1
//        cell.linkImg.isHidden = link.count < 1
//
//        /// 주유/충전시작, 세차등에서 바로가기 숨김 처리
//        let template = item["templatecode"].stringValue
//        if template.isEmpty == false {
//            if let _ = LogoutPushNotifcation(rawValue: template) {
//                cell.linkLabel.isHidden = true
//                cell.linkImg.isHidden = true
//            }
//
//            let notification = OilNotificationType(rawValue: template) ?? .unknown
//            if notification == .fillingStarted ||
//                notification == .carwashUsed ||
//                notification == .fillingGasStarted {
//                cell.linkLabel.isHidden = true
//                cell.linkImg.isHidden = true
//            }
//        }
//
//        cell.setLinkView()
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var itemArray:[JSON] = []
//        if let items = self.allData[safe: indexPath.section] {
//            itemArray = items["data"].arrayValue
//        }
//
//        if self.focusPush == .oil, let items = self.oilData[safe: indexPath.section] {
//            itemArray = items["data"].arrayValue
//        } else if self.focusPush == .wash, let items = self.washData[safe: indexPath.section] {
//            itemArray = items["data"].arrayValue
//        } else if self.focusPush == .etc, let items = self.etcData[safe: indexPath.section] {
//            itemArray = items["data"].arrayValue
//        }
//
//        guard let item = itemArray[safe: indexPath.row] else {
//            return
//        }
//
//        let link = item["link"].stringValue
//        let template = item["templatecode"].stringValue
//
//        if let _ = LogoutPushNotifcation(rawValue: template) {
//            return
//        }
//        if template.isEmpty == false, template.uppercased().hasPrefix(OilNotificationType.Prefix) {
//            SKLog.log("\(template.uppercased())", category: "PUSH")
//            let notification = OilNotificationType(rawValue: template) ?? .unknown
//            if notification == .fillingStarted ||
//                notification == .carwashUsed ||
//                notification == .fillingGasStarted {
//                return
//            }
//            if notification == .couponIssued, link.count > 0 {
//                UIApplication.goWebview(link)
//                return
//            }
//
//            OilNotification.present(
//                OilNotification.parse(
//                    type: OilNotificationType(rawValue: template) ?? .unknown,
//                    with: link
//                )
//            )
//        } else if link.count > 0 {
//            SKLog.log("\(link)", category: "PUSH")
//            UIApplication.goWebview(link)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30.0
//    }
//}

extension TodoListTableViewController {
    // MARK: - UI Init
    func init_UI(){
        
    }
}
