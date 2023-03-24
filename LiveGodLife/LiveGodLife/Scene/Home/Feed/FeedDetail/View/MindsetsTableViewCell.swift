//
//  MindsetsTableViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import UIKit
//MARK: MindsetsTableViewCell
final class MindsetsTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var feed: Feed?
    private let titleLabel = UILabel().then {
        $0.text = "마인드셋"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private lazy var mindsetTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.alwaysBounceVertical = false
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .zero
        FeedMindsetTableViewCell.register($0)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.feed = nil
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(titleLabel)
        contentView.addSubview(mindsetTableView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(28)
        }
        mindsetTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with feed: Feed?) {
        guard let feed else { return }
        
        self.feed = feed
        mindsetTableView.reloadData()
    }
}

extension MindsetsTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed?.mindsets.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feed, indexPath.row < feed.mindsets.count else { return UITableViewCell() }
        
        let cell: FeedMindsetTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: feed.mindsets[indexPath.row])
        
        return cell
    }
}

extension MindsetsTableViewCell: UITableViewDelegate {
    static func height(with feed: Feed?) -> CGFloat {
        guard let feed else { return .zero }
        
        let height: CGFloat = feed.mindsets.reduce(0.0, { $0 + FeedMindsetTableViewCell.height(with: $1.content) + 16.0 })
        return 32.0 + 28.0 + height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let feed, indexPath.row < feed.mindsets.count else { return .zero }
        
        return FeedMindsetTableViewCell.height(with: feed.mindsets[indexPath.row].content) + 16.0
    }
}
