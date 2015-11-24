//
//  UITableView+EnumsCellIdentifiers.swift
//  Linguistic
//
//  Created by Anton on 22/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCellWithIdentifier<T: RawRepresentable where T.RawValue == String>(cellIdentifier: T, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.dequeueReusableCellWithIdentifier(cellIdentifier.rawValue, forIndexPath: indexPath)
    }
    func dequeueReusableCellWithIdentifier<T: RawRepresentable where T.RawValue == String>(identifier:T) -> UITableViewCell? {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue)
    }
}


