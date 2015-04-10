//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Frédéric Lépy on 09/04/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class SentMemesTableViewController : UITableViewController, UITableViewDelegate {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lines = memes.count
        return lines
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let meme = memes[indexPath.item]
        
        var cell = tableView.dequeueReusableCellWithIdentifier("prototypeCell") as! UITableViewCell
        cell.imageView?.image = meme.memedImage
        
        cell.textLabel?.text = meme.topString
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let meme = memes[indexPath.item]
        self.performSegueWithIdentifier("showDetailViewController", sender: meme)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailViewController" {
        
            let detailView = segue.destinationViewController as! DetailViewController
        
            if let image = (sender as? Meme)?.memedImage {
                detailView.meme = sender as? Meme
            }
        }
    }
}
