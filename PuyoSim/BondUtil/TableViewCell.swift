//
//  TableViewCell.swift
//  PuyoSim
//
//  Created by roza on 2016/10/03.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit
import Bond


/// UITableViewCellのバインディング対応のベースクラス
class BindableCell<T: TableViewCellItemModel>: UITableViewCell {
    
    /// バインディング定義
    /// オーバーライドされない場合、ランタイムで落とす（Swiftでは抽象クラスを定義できないため暫定対応）
    ///
    /// - Parameters:
    ///   - viewController: TableViewを所有しているViewController
    ///   - itemModel: セルのViewModel
    func bind(viewController: UIViewController, itemModel:T) {
        fatalError("abstract method not implemented")
    }

    
    /// セルの再利用のためにidentifierをクラス名から生成している（StoryBoardでのセル定義でも同じ文字列にしておく必要がある）
    static var identifier:String {
        return String(describing: self)
    }
    
    /// セルの生成しビューモデルとのバインディングを行う
    ///
    /// - Parameters:
    ///   - viewController: TableViewを所有しているViewController
    ///   - tableView: Cellを表示するTableView
    ///   - indexPath: CellのindexPath
    ///   - itemModel: ビューモデル
    /// - Returns: 生成されたセルを返す
    static func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath, itemModel: T) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as! BindableCell
        cell.bind(viewController: viewController, itemModel: itemModel)
        cell.tintColor = FXColorUtil.OrangeYellow   //チェックマークの色変更のため
        cell.selectedBackgroundView = {
            let view = CellSelectedView()
            view.backgroundColor = cell.backgroundColor
            return view
        }()
        return cell
    }

    // セルの再利用される前にバインディングを重複しないように解除する
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bnd_bag.dispose()
    }
}

class CellSelectedView: UIView {
    private lazy var filterView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(hex: 0xcccccc, alpha: 0.25)
        self.addFilter(view)
        return view
    }()
    
    private func addFilter(_ view: UIView) {
        self.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        filterView.frame = self.bounds
    }
}

//FIXME:extension ではオーバーライドできないため prepareForResuseでのdispose処理が共通化できない
//そのため上記のような抽象クラスに見せかけたクラスで代用する

//protocol BindableCell {
//    static var identifier:String{get}
//    associatedtype itemType : TableViewCellItemModel
//    func bind(itemModel:itemType)
//}
//
//extension BindableCell where Self: UITableViewCell {
//    static var identifier:String {
//        return String(describing: self)
//    }
//    
//    static func createCell(tableView: UITableView, itemModel: itemType) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier) as! Self
//        cell.bind(itemModel: itemModel)
//        return cell
//    }
//}


/// BindableCellに対するモデルのプロトコル
protocol TableViewCellItemModel {
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())? {get}
    
    // 本来はビューモデル側でビューの生成の定義はしたくないが、分離すると冗長になりそうなので許容している（良い解決方法があれば分離する）
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

extension TableViewCellItemModel {
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())? {
        return { _ in }
    }
}

//MARK: 凡例

/// バインディングに対応したテキスト表示セル
class TextCell : BindableCell<TextCellItemModel> {
    
    /// バインディングの定義をオーバーライドで実装する
    /// セルが生成or再利用で呼びだされたタイミングで呼ばれる
    ///
    /// - Parameters:
    ///   - viewController: TableViewを所有しているViewCOntroller
    ///   - itemModel: ViewModel
    override func bind(viewController: UIViewController, itemModel: TextCellItemModel) {
        itemModel.image.bind(to: imageView!.bnd_image).dispose(in: self.bnd_bag)
        itemModel.title.bind(to: textLabel!.bnd_text).dispose(in: self.bnd_bag)
        _ = itemModel.hasDisclosure.observeNext { [weak self] in
            self?.accessoryType = $0 ? .disclosureIndicator : .none
            }.dispose(in: self.bnd_bag)
        selectionStyle = itemModel.onSelected == nil ? .none : .default
    }
    
    override func layoutSubviews() {
        bindColor()
        super.layoutSubviews()
    }
    
    func bindColor() {
        self.backgroundColor = ColorSettingModel.themeColor.commonCellBackgroundColor
        self.textLabel?.textColor = ColorSettingModel.themeColor.commonFontColor
    }
    
}

/// TextCellに対するビューモデル
class TextCellItemModel : TableViewCellItemModel {
    var image: Observable<UIImage?>
    var title: Observable<String>
    var hasDisclosure: Observable<Bool>
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())?
    
    // 初期化（必要に応じて自由に定義する）
    init(image: UIImage? = nil, title: String, hasDisclosure: Bool = false, onSelected: ((UIViewController, UITableView, IndexPath) -> ())? = nil) {
        self.image = Observable<UIImage?>(image)
        self.title = Observable<String>(title)
        self.hasDisclosure = Observable(hasDisclosure)
        self.onSelected = onSelected
    }
    
    // 対象のセルを生成して返す
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        // 生成するセルのクラスが一つならば、BindingCellクラスで実装されているcreateCellを呼び出すだけで良い
        return TextCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

class TextDetailCell : BindableCell<TextDetailCellItemModel> {
    
    override func bind(viewController: UIViewController, itemModel: TextDetailCellItemModel) {
        itemModel.image.bind(to: imageView!.bnd_image).dispose(in: self.bnd_bag)
        itemModel.title.bind(to: textLabel!.bnd_text).dispose(in: self.bnd_bag)
        itemModel.detail.bind(to: detailTextLabel!.bnd_text).dispose(in: self.bnd_bag)
        itemModel.titleColor.bind(to: textLabel!.bnd_textColor).dispose(in: self.bnd_bag)
        itemModel.detailColor.bind(to: detailTextLabel!.bnd_textColor).dispose(in: self.bnd_bag)
        _ = itemModel.hasDisclosure.observeNext { [weak self] in
            self?.accessoryType = $0 ? .disclosureIndicator : .none
            }.dispose(in: self.bnd_bag)
        
        selectionStyle = itemModel.onSelected == nil ? .none : .default
    }
}

class TextDetailCellItemModel : TableViewCellItemModel {
    var image: Observable<UIImage?>
    var title: Observable<String>
    var detail: Observable<String>
    var titleColor: Observable<UIColor?>
    var detailColor: Observable<UIColor?>
    var hasDisclosure: Observable<Bool>
    
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())?

    init(image: UIImage? = nil , title: String, detail: String, titleColor: UIColor? = nil, detailColor: UIColor? = nil, hasDisclosure: Bool = false, onSelected: ((UIViewController, UITableView, IndexPath) -> ())? = nil) {
        self.image = Observable<UIImage?>(image)
        self.title = Observable<String>(title)
        self.detail = Observable<String>(detail)
        self.titleColor = Observable<UIColor?>(titleColor ?? UIColor.white)
        self.detailColor = Observable<UIColor?>(detailColor ?? UIColor.lightGray)
        self.hasDisclosure = Observable(hasDisclosure)
        self.onSelected = onSelected
    }
    
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return TextDetailCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

//TextDetailCellと要素としては同じだが、StoryBoard上でそれそれ定義しておく必要があるため継承の形で用意する
class TextSubtitleCell: TextDetailCell {
}
class TextSubtitleCellItemModel: TextDetailCellItemModel {
    override func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return TextSubtitleCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

class SelectItemCell: BindableCell<SelectItemModel> {
    override func bind(viewController: UIViewController, itemModel: SelectItemModel) {
        itemModel.title.bind(to: self.textLabel!.bnd_text)
        itemModel.image.map{ $0?() }.bind(to: imageView!.bnd_image)
        // アクセサリータイプにデータバインディングがなさそう？そもそもデータバインディングしにくい
        self.accessoryType = itemModel.isSelected() ? .checkmark : .none
    }
}

class SelectItemModel: TableViewCellItemModel {
    
    var title: Observable<String>
    var image: Observable<(() -> UIImage?)?>
    var isSelected: (() -> Bool)
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())?
    
    init(title: String, image: (() -> UIImage?)? = nil, isSelected: @escaping (() -> Bool), onSelected: ((UIViewController, UITableView, IndexPath) -> ())? = nil) {
        self.image = Observable(image)
        self.title = Observable<String>(title)
        self.isSelected = isSelected
        self.onSelected = onSelected
    }
    
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return SelectItemCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

class TextSwitchCell: BindableCell<TextSwitchItemModel> {
    override func bind(viewController: UIViewController, itemModel: TextSwitchItemModel) {
        itemModel.title.bind(to: self.textLabel!.bnd_text).dispose(in: self.bnd_bag)
        itemModel.image.map{ $0 }.bind(to: imageView!.bnd_image).dispose(in: self.bnd_bag)
        let aswitch = UISwitch()
        self.accessoryView = aswitch

        itemModel.isEnabled.bind(to: aswitch.bnd_isEnabled).dispose(in: self.bnd_bag)
        
        let weakVC = viewController
        let weakItem = itemModel
        
        itemModel.isOn.bidirectionalBind(to: aswitch.bnd_isOn).dispose(in: self.bnd_bag)
        itemModel.isOn.skip(first: 1).observeNext { [weak weakVC, weak weakItem] in
            weakItem?.onChanged?($0, weakVC!)
        }.dispose(in: self.bnd_bag)
    }
}

class TextSwitchItemModel: TableViewCellItemModel {
    
    var title: Observable<String>
    //var image: Observable<(() -> UIImage?)?>
    var image: Observable<UIImage?>
    var isOn: Observable<Bool>
    var isEnabled: Observable<Bool>
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())? = nil
    var onChanged: ((Bool, UIViewController) -> ())?
    
    init(title: String, image: UIImage? = nil, isOn: Bool, onChanged: ((Bool, UIViewController) -> ())? = nil) {
        self.image = Observable(image)
        self.title = Observable<String>(title)
        self.isOn = Observable(isOn)
        self.isEnabled = Observable(true)
        self.onChanged = onChanged
    }
    
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return TextSwitchCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

class TextCheckCell: BindableCell<TextCheckItemModel> {
    override func bind(viewController: UIViewController, itemModel: TextCheckItemModel) {
        itemModel.title.bind(to: self.textLabel!.bnd_text).dispose(in: self.bnd_bag)
        itemModel.image.map{ $0?() }.bind(to: imageView!.bnd_image).dispose(in: self.bnd_bag)
        itemModel.isChecked.observeNext{ [weak self] in
            self?.accessoryType = $0 ?.checkmark : .none
            }.dispose(in: self.bnd_bag)
    }
}

class TextCheckItemModel: TableViewCellItemModel {
    
    var title: Observable<String>
    var image: Observable<(() -> UIImage?)?>
    var isChecked: Observable<Bool>
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())?
    
    init(title: String, image: (() -> UIImage?)? = nil, isChecked: Bool, onSelected: ((UIViewController, UITableView, IndexPath) -> ())? = nil) {
        self.image = Observable(image)
        self.title = Observable(title)
        self.isChecked = Observable(isChecked)
        self.onSelected = onSelected
    }
    
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return TextCheckCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

class TextDetailSelectItemCell: BindableCell<TextDetailSelectItemModel> {
    override func bind(viewController: UIViewController, itemModel: TextDetailSelectItemModel) {
        itemModel.title.bind(to: self.textLabel!.bnd_text).dispose(in: self.bnd_bag)
        itemModel.detail.bind(to: self.detailTextLabel!.bnd_text).dispose(in: self.bnd_bag)
        itemModel.image.map{ $0?() }.bind(to: imageView!.bnd_image).dispose(in: self.bnd_bag)
        itemModel.isSelected.observeNext{
            self.accessoryType = $0 ? .checkmark : .none
            }.dispose(in: self.bnd_bag)
    }
}

class TextDetailSelectItemModel: TableViewCellItemModel {
    
    var title: Observable<String>
    var detail: Observable<String>
    var image: Observable<(() -> UIImage?)?>
    var isSelected: Observable<Bool>
    var onSelected: ((UIViewController, UITableView, IndexPath) -> ())?
    
    init(title: String, detail: String, image: (() -> UIImage?)? = nil, isSelected: Bool, onSelected: ((UIViewController, UITableView, IndexPath) -> ())? = nil) {
        self.image = Observable(image)
        self.title = Observable(title)
        self.detail = Observable(detail)
        self.isSelected = Observable(isSelected)
        self.onSelected = onSelected
    }
    
    func createCell(viewController: UIViewController, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return TextDetailSelectItemCell.createCell(viewController: viewController, tableView: tableView, indexPath: indexPath, itemModel: self)
    }
}

// SwiftBondの bind(to: UITableView, using: TableViewBond) のusingにUIViewControllerを直接渡すと
// SwiftBond側のラムダでUIViewControllerをキャプチャし、循環参照、メモリリークが発生するため、弱参照で保持するためのWrapperを使用する
class TableViewBondWrapper<T: AnyObject>: TableViewBond where T: TableViewBond {
    typealias DataSource = T.DataSource
    
    weak var delegate: T?
    
    init (_ delegate: T) {
        self.delegate = delegate
    }
    
    var animated: Bool {
        return delegate?.animated ?? false
    }

    func cellForRow(at indexPath: IndexPath, tableView: UITableView, dataSource: DataSource) -> UITableViewCell {
        return delegate!.cellForRow(at: indexPath, tableView: tableView, dataSource: dataSource)
    }
    
    func titleForHeader(in section: Int, dataSource: T.DataSource) -> String? {
        return delegate?.titleForHeader(in: section, dataSource: dataSource)
    }
    
    func titleForFooter(in section: Int, dataSource: T.DataSource) -> String? {
        return delegate?.titleForFooter(in: section, dataSource: dataSource)
    }
}
