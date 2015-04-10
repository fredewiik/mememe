//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Frédéric Lépy on 09/04/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController : UICollectionViewController, UICollectionViewDelegate {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        
        let meme = memes[indexPath.item]
        
        cell.backgroundImageView.image = meme.image
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let meme = memes[indexPath.item]
        self.performSegueWithIdentifier("showDetailViewControllerFromGrid", sender: meme)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailViewControllerFromGrid" {
            
            let detailView = segue.destinationViewController as! DetailViewController
            
            if let image = (sender as? Meme)?.memedImage {
                detailView.meme = sender as? Meme
            }
        }
    }
}
