//
//  Meme.swift
//  MemeMe
//
//  Created by Dale Henries on 12/3/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit

class Meme {
    var topText: String?
    var bottomText: String?
    let originalImage: UIImage?
    var memedImage: UIImage?
    
    init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage?) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}