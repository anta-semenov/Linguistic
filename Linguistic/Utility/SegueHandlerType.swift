//
//  SegueHandlerType.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let segueIdentifier = SegueIdentifier(rawValue: segue.identifier!) else {
            fatalError("Can't perfom segue with identifier \(segue.identifier)")
        }
        
        return segueIdentifier
    }
}
