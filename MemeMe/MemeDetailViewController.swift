//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/7/15.
//  Copyright © 2015 Dale Henries. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var memeIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
        
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func editMeme() {
        if let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NewMemeViewController") as? ViewController {
            controller.previousMemeVersion = meme
            controller.previousMemeIndex = memeIndex
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
