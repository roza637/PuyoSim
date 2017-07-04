//
//  CollectionViewCell.swift
//  PuyoSim
//
//  Created by roza on 2016/10/31.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit
import Bond

class BindableCollectionCell<T: CollectionViewCellItemModel>: UICollectionViewCell {
    
    func bind(viewController: UIViewController, itemModel:T) {
        fatalError("abstract method not implemented")
    }
    
    static var identifier:String {
        return String(describing: self)
    }
    
    static func createCell(viewController: UIViewController, collectionView: UICollectionView, indexPath: IndexPath, itemModel: T) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BindableCollectionCell
        cell.bind(viewController: viewController, itemModel: itemModel)
        return cell
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bnd_bag.dispose()
    }
}

protocol CollectionViewCellItemModel {
    var onSelected: ((UIViewController, UICollectionView, IndexPath) -> ())? {get}
    func createCell(viewController: UIViewController, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

extension CollectionViewCellItemModel {
    var onSelected: ((UIViewController, UICollectionView, IndexPath) -> ())? {
        return { _ in }
    }
}
