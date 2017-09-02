//
//  Extensions.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

// MARK: - String
extension String {
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
