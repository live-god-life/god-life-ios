//
//  DropDownView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/16.
//

import UIKit
import SnapKit

final class TodoView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}

final class TodoDropDownView: UIView {

    @IBOutlet weak var todoView: TodoView!
    @IBOutlet weak var subTodoView: TodoView!
    @IBOutlet weak var subTodoView2: TodoView!
    @IBOutlet weak var toggleButton: UIButton!

    private var isOpened: Bool = false {
        didSet {
            let up = UIImage(systemName: "chevron.up")
            let down = UIImage(systemName: "chevron.down")
            isOpened == true ? toggleButton.setImage(up, for: .normal) : toggleButton.setImage(down, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    func commonInit() {
        guard let view = Bundle.main.loadNibNamed("TodoDropDownView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        todoView.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        subTodoView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        subTodoView2.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        view.frame = self.bounds
        addSubview(view)
    }

    func configure(_ todo: Feed.FeedTodo) {
        todoView.titleLabel.text = todo.title
        guard let childs = todo.childs, !childs.isEmpty else {
            subTodoView.isHidden = true
            subTodoView2.isHidden = true
            return
        }
        // TODO: 코드 개선
        if let child = childs.first {
            subTodoView.titleLabel.text = child.title
        } else {
            subTodoView.isHidden = true
        }

        if let child = childs.last {
            subTodoView2.titleLabel.text = child.title
        } else {
            subTodoView2.isHidden = true
        }
    }

    @IBAction func toggle(_ sendser: UIButton) {
//        UIView.animate(withDuration: 0.4, animations: {
//            if self.isOpened {
//                self.subTodoView.isHidden = true
//                self.subTodoView2.isHidden = true
//            } else {
//                self.subTodoView.isHidden = false
//                self.subTodoView2.isHidden = false
//            }
//        }, completion: { [weak self] _ in
//            guard let self = self else { return }
//            self.isOpened = !self.isOpened
//        })
    }
}
