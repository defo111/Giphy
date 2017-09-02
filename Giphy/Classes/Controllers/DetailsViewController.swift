//
//  DetailsViewController.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class DetailsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!    
    @IBOutlet weak var soucreLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var giphy = Giphy()
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.sd_setImage(with: giphy.url!)
        
        if let userAvatarUrl = giphy.authorAvatarURL {
            userAvatarImageView.sd_setImage(with: userAvatarUrl)
        }
        
        userNameLabel.text = giphy.authorName
        soucreLabel.text = giphy.source
    }
}
