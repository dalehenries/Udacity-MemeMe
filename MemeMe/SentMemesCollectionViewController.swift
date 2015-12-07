//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/7/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: BaseSentMemesViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource Implementation
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as? MemeCollectionViewCell {
            let meme = memes[indexPath.row]
            // TODO: add image to cell
            cell.populateCell(meme)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as? MemeDetailViewController {
            controller.meme = memes[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
