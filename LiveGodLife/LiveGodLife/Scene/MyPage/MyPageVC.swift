//
//  MyPageVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/23.
//

import UIKit
import Combine
import Kingfisher
import SnapKit
import Then

final class MyPageVC: UIViewController {
    //MARK: - Properties
    private var viewModel = UserViewModel()
    private var user: UserModel?
    private var feeds: [Feed] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "MY PAGE"
        $0.font = .montserrat(with: 20, weight: .semibold)
    }
    private var navigationView = CommonNavigationView().then {
        $0.leftBarButton.isHidden = true
        $0.rightBarButton.setImage(UIImage(named: "setting"), for: .normal)
    }
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.keyboardDismissMode = .onDrag
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0,
                                       bottom: 104.0, right: 0)
        FeedTableViewCell.xibRegister($0)
    }
    private let profileView = ProfileView(frame: CGRect(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: 106.0))
    private let items = [SegmentItem(title: "찜한글"), SegmentItem(title: "내 작성글")]
    private lazy var segmentControlView = SegmentControlView(frame: .zero,
                                                        items: items).then {
        $0.delegate = self
    }
    private let emptyLabel = UILabel().then {
        $0.numberOfLines = 0
        let text = "내 작성글 기능을 준비중입니다.\n다음 업데이트를 기대해주세요."
        $0.attributedText = text.lineAndLetterSpacing(font: .regular(with: 18),
                                                      lineHeight: 30)
        $0.font = .regular(with: 18)
        $0.textColor = .white.withAlphaComponent(0.4)
        $0.isHidden = true
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        viewModel.input.request.send(.user)
        if segmentControlView.selectedIndex == 0 {
            viewModel.input.request.send(.heart)
        }
    }
    
    private func makeUI() {
        view.backgroundColor = .black
        
        tableView.tableHeaderView = profileView
        
        view.addSubview(navigationView)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        navigationView.addSubview(titleLabel)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        emptyLabel.snp.makeConstraints {
            $0.center.equalTo(tableView)
        }
        
        didMove(toParent: self)
    }
}

// MARK: - Setup
extension MyPageVC {
    private func bind() {
        navigationView.rightBarButton
            .tapPublisher
            .sink { [weak self] in
                let settingVC = SettingVC()
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
            .store(in: &viewModel.bag)
        
        profileView
            .gesture()
            .sink { [weak self] _ in
                guard let self, let profileUpdateVC = ProfileUpdateVC.instance() else {
                    LogUtil.e("ProfileUpdateVC 생성 실패")
                    return
                }
                profileUpdateVC.configure(self.user)
                self.navigationController?.pushViewController(profileUpdateVC, animated: true)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.user = model
                self?.profileView.nicknameLabel.text = model?.nickname
                if let imageUrlString = model?.image {
                    self?.profileView.profileImageView.kf.setImage(with: URL(string: imageUrlString))
                }
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestHeart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] models in
                self?.feeds = models
            }
            .store(in: &viewModel.bag)
    }
}

extension MyPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configure(with: feeds[indexPath.row])
        return cell
    }
}

extension MyPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentControlView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 362
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}

extension MyPageVC: SegmentControlViewDelegate {
    func didTapItem(index: Int) {
        if index == 0 {
            emptyLabel.isHidden = true
            viewModel.input.request.send(.heart)
        } else {
            feeds = []
            emptyLabel.isHidden = false
        }
    }
}

extension MyPageVC: FeedTableViewCellDelegate {
    func bookmark(_ cell: FeedTableViewCell, feedID: Int, status: Bool) {
        guard let index = tableView.indexPath(for: cell)?.row,
              index < feeds.count else {
            return
        }
        viewModel.input.request.send(.bookmark(feedID, "false"))
        feeds.remove(at: index)
    }
}
