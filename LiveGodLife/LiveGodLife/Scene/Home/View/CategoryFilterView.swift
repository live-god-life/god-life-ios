//
//  CategoryFilterVIew.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/31.
//

import UIKit
import SnapKit

protocol CategoryFilterViewDelegate: AnyObject {
    func filtered(from category: String)
}

final class CategoryFilterView: UIView {
    //MARK: - Properties
    weak var delegate: CategoryFilterViewDelegate?
    private let scrollView = UIScrollView()
    private var itemButtons: [CategoryButton] = []
    // TODO: 카테고리 필터뷰가 super view의 중앙에 있도록
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    private var items: [Category] = [] {
        didSet {
            update()
        }
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions...
    private func makeUI() {
        backgroundColor = .background

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.trailing.bottom.equalToSuperview()
        }
        scrollView.contentSize = stackView.intrinsicContentSize
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func update() {
        guard !items.isEmpty else { return }
        items.forEach { category in
            let button = CategoryButton()
            button.delegate = self
            button.configure(title: category.name)
            itemButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        itemButtons.first?.isSelected = true
    }
    
    func configure(items: [Category]) {
        self.items = items
    }
}

//MARK: - CategoryButtonDelegate
extension CategoryFilterView: CategoryButtonDelegate {
    func didTapButton(_ sender: CategoryButton) {
        guard let selected = itemButtons.filter({ $0.isSelected }).first, selected != sender else {
            return
        }
        selected.isSelected = !selected.isSelected
        sender.isSelected = !sender.isSelected

        guard let index = itemButtons.firstIndex(of: sender) else {
            return
        }
        delegate?.filtered(from: items[index].code)
    }
}
