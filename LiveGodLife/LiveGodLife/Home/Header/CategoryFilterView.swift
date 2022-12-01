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

struct Category: Identifiable, Decodable {

    let id: Int
    let code: String
    let name: String
}

final class CategoryFilterView: UIView {

    weak var delegate: CategoryFilterViewDelegate?

    private let scrollView = UIScrollView()

    // TODO: 카테고리 필터뷰가 super view의 중앙에 있도록
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private var itemButtons: [CategoryButton] = []
    private var items: [Category] = [] {
        didSet {
            update()
        }
    }

    func configure(items: [Category]) {
        self.items = items
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(items: [Category]) {
        self.items = items
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
}

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
