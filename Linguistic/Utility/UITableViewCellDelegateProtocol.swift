//
//  UITableViewCellDelegateProtocol.swift
//  Linguistic
//
//  Created by Anton on 19/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

protocol UITableViewCellDelegate {
    func cellWasChanged<T:UITableViewCell>(cell: T) -> Void
}
