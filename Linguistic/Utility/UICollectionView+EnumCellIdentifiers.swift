//
//  UICollectionView+EnumCellIdentifiers.swift
//  Linguistic
//
//  Created by Anton on 24/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCellWithIdentifier<T: RawRepresentable where T.RawValue == String>(cellIdentifier: T, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCellWithReuseIdentifier(cellIdentifier.rawValue, forIndexPath: indexPath)
    }
}
