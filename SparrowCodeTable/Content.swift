//
//  Content.swift
//  SparrowCodeTable
//
//  Created by Юрий Степанчук on 12.11.2023.
//

import UIKit

final class Content: Hashable {
    let id = UUID()
    let title: String
    var isChecked: Bool

    init(title: String, isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }

    static func == (lhs: Content, rhs: Content) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
