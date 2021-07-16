//
//  StringExtensions.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/8/21.
//

import Foundation

extension String {
    func initials() -> String {
        self.components(separatedBy: " ")
            .prefix(2)
            .reduce("") {
                guard let first = $1.first else { return $0 }
                return "\($0)\(first.uppercased())"
            }
    }
}
