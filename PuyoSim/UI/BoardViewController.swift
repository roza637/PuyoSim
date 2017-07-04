//
//  BoardViewController.swift
//  PuyoSim
//
//  Created by roza on 2017/07/04.
//  Copyright © 2017年 roza. All rights reserved.
//

import UIKit
import Bond

class BoardViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    private var views: [[PuyoView]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createViews()
    }
    
    private func createViews() {
        (0 ..< UIDefines.Numbers.row).forEach{ row in
            views.append([])
            (0 ..< UIDefines.Numbers.column).forEach{ column in
                let view = PuyoView()
                backgroundView.addSubview(view)
                views[row].append(view)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = view.frame.width / CGFloat(UIDefines.Numbers.column)
        let height = view.frame.height / CGFloat(UIDefines.Numbers.row)
        
        views.enumerated().forEach{ row in
            row.element.enumerated().forEach{ column in
                column.element.frame = CGRect(x: CGFloat(column.offset) * width, y: height * CGFloat(UIDefines.Numbers.row - row.offset - 1), width: width, height: height)
                column.element.cornerRadius = height / 2
            }
        }
    }

}

class PuyoView: UIView {
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.brown
    }
    
    func bind(viewModel: PuyoViewModel) {
        viewModel.type.map{ $0.color }.bind(to: self.reactive.backgroundColor).dispose(in: self.bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension PuyoType {
    var color: UIColor {
        switch self {
        case .blank:
            return UIColor.clear
        case .red:
            return UIDefines.Colors.red
        case .green:
            return UIDefines.Colors.green
        case .blue:
            return UIDefines.Colors.blue
        case .yellow:
            return UIDefines.Colors.yellow
        case .purple:
            return UIDefines.Colors.puple
        }
    }
}

class UIDefines{
    
    class Numbers {
        static let row: Int = 13
        static let column: Int = 6
    }
    
    class Colors {
        static let red: UIColor = UIColor.red
        static let green: UIColor = UIColor.green
        static let blue: UIColor = UIColor.blue
        static let yellow: UIColor = UIColor.yellow
        static let puple: UIColor = UIColor.purple
    }
}

