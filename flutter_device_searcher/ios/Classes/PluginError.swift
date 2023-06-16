//
//  PluginException.swift
//  flutter_device_searcher
//
//  Created by Peter Wong (Engineering) on 20/1/2023.
//

import Foundation

struct PluginError: Error {
    let code: Int
    let message: String
}
