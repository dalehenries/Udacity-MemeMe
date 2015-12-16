//
//  BaseSentMemesViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/7/15.
//  Copyright © 2015 Dale Henries. All rights reserved.
//

import UIKit

class BaseSentMemesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newMeme")
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func newMeme() {
        if let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NewMemeViewController") as? ViewController {
            navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
