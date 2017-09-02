//
//  Giphy.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class Giphy: NSObject {
    
    //MARK: - Types
    
    enum JSONKeys: String {
        case user = "user"
        case userName = "username"
        case name = "name"
        case images = "images"
        case previewGif = "preview_gif"
        case avatarUrl = "avatar_url"
        case url = "url"
        case source = "source"
        case photo = "photos"
    }
    
    //MARK: - Properties
    
    var tag = ""
    var source = "No source"
    var name = "No name"
    var url: URL!
    var authorName = "No username"
    var authorAvatarURL: URL?
    
    //MARK: - Init method
    
    override init() {
    }
    
    init (data: [String : Any]) {
        
        source = data[JSONKeys.source.rawValue] as! String
        
        if let images = data[JSONKeys.images.rawValue] as? [String: Any] {
            if let previewGif = images[JSONKeys.previewGif.rawValue] as? [String: Any] {
                url = URL(string: previewGif[JSONKeys.url.rawValue] as! String)
            }
        }
        
        if let user = data[JSONKeys.user.rawValue] as? [String: Any] {
            
            authorName = user[JSONKeys.userName.rawValue] as! String
            authorAvatarURL = URL(string: user[JSONKeys.avatarUrl.rawValue] as! String)
        }
    }
}
