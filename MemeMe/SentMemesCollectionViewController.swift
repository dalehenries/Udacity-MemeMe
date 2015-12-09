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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateFlowLayout(view.frame.size)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: Custom Methods
    func calculateFlowLayout(size: CGSize) {
        let space: CGFloat = 3.0
        // 3 items along the short side and 5 along the long side.
        let dimension = size.width < size.height ? (size.width - (2 * space)) / 3.0 : (size.width - (4 * space)) / 5.0
        // fixes crash when rotate right after launch.
        if flowLayout != nil {
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSizeMake(dimension, dimension)
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // When the screen rotates, recalculate the flow layout
        calculateFlowLayout(size)
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
