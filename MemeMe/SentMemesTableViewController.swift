//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/7/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit
import Foundation

class SentMemesTableViewController: BaseSentMemesViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource Implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as? MemeTableViewCell {
            let meme = memes[indexPath.row]
            cell.populateCell(meme)
//            cell.textLabel?.text = meme.topText
//            cell.detailTextLabel?.text = meme.bottomText
//            cell.imageView?.image = meme.memedImage
//            cell.imageView?.contentMode = .ScaleAspectFit
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as? MemeDetailViewController {
            controller.meme = memes[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
}

