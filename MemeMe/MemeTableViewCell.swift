//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Dale Henries on 12/9/15.
//  Copyright © 2015 Dale Henries. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    
    func populateCell(meme: Meme) {
        memeImageView.image = meme.memedImage
        memeImageView.contentMode = .ScaleToFill
        topTextLabel.text = meme.topText
        bottomTextLabel.text = meme.bottomText
    }

}
