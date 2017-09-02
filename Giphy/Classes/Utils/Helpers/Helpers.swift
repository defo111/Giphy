//
//  Helpers.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.


import UIKit


// MARK: - Types

enum Result<T> {
    case success(T)
    case failure(APIError)
    case userCancelled(String)
}

