//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Dale Henries on 12/7/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populateCell(meme: Meme) {
        //self.backgroundView = UIImageView(image: meme.memedImage)
        imageView.image = meme.memedImage
    }

}
