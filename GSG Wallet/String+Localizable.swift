//
//  String+Localizable.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation

extension String {
    var localized: String {
        return Localizable.localizedString(for: self)
    }
}

class Localizable {
    static var bundle: Bundle = .main

    static func setLanguage(_ language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = .main
        }
    }

    static func localizedString(for key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
