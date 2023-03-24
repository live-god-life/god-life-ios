//
//  FeedDetailContentsCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import UIKit
//MARK: FeedDetailContentsCell
final class FeedDetailContentsCell: UITableViewCell {
    //MARK: - Properties
    private var feed: Feed?
    private lazy var contentTableView = UITableView().then {
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
        FeedDetailContentCell.register($0)
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
        contentView.addSubview(contentTableView)
        
        contentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with feed: Feed?) {
        guard let feed else { return }
        
        self.feed = feed
        contentTableView.reloadData()
    }
}

extension FeedDetailContentsCell: UITableViewDataSource {
    static func height(with feed: Feed?) -> CGFloat {
        guard let feed else { return .zero }
        
        var height: CGFloat = 66.0
        height += CGFloat(feed.contents.count) * 36.0
        height += CGFloat(feed.contents.count) * 32.0
        height += feed.contents.reduce(0.0,
                                       { $0 + ($1.content.lineCount(font: .regular(with: 16)!, targetWidth: UIScreen.main.bounds.width - 40.0) * 26) })
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed?.contents.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feed, indexPath.row < feed.contents.count else { return UITableViewCell() }
        
        let cell: FeedDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: feed.contents[indexPath.row])
        
        return cell
    }
}

extension FeedDetailContentsCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let feed, indexPath.row < feed.contents.count else { return .zero }
        
        let content = feed.contents[indexPath.row].content
        let lineCount = content.lineCount(font: .regular(with: 16)!, targetWidth: UIScreen.main.bounds.width - 40.0)
        return 32.0 + 28.0 + 8.0 + (lineCount * 26.0)
    }
}
