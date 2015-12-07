//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/7/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }
    
}
