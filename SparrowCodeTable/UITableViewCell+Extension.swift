//
//  UITableViewCell+Extension.swift
//  SparrowCodeTable
//
//  Created by Юрий Степанчук on 12.11.2023.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
