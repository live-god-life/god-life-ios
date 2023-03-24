//
//  TodosTableViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import UIKit
//MARK: TodosTableViewCell
final class TodosTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var feed: Feed?
    private let titleLabel = UILabel().then {
        $0.text = "TODO"
        $0.textColor = .white
        $0.font = .montserrat(with: 18, weight: .semibold)
    }
    private lazy var todoTableView = UITableView().then {
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
        contentView.addSubview(todoTableView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(28)
        }
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with feed: Feed?) {
        guard let feed else { return }
        
        self.feed = feed
        todoTableView.reloadData()
    }
}

extension TodosTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed?.todos.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feed, indexPath.row < feed.todos.count else { return UITableViewCell() }
        
        let cell: FeedMindsetTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: feed.mindsets[indexPath.row])
        
        return cell
    }
}

extension TodosTableViewCell: UITableViewDelegate {
    static func height(with feed: Feed?) -> CGFloat {
        guard let feed else { return .zero }
        
        var height: CGFloat = CGFloat(feed.todos.count * 96)
        feed.todos.forEach { height += (CGFloat($0.childs?.count ?? .zero) * 80.0) }
        
        return 40.0 + 28.0 + height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let feed, indexPath.row < feed.todos.count else { return .zero }
        
        var height = CGFloat(feed.todos[indexPath.row].childs?.count ?? .zero) * 80.0
        
        return 16.0 + 80.0 + height
    }
}
