//
//  UICollectionViewCellDelegateProtocol.swift
//  Linguistic
//
//  Created by Anton on 24/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

protocol UICollectionViewCellDelegate {
    func cellPerformAction<T:UICollectionViewCell>(cell: T) -> Void
}
