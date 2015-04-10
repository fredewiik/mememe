//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Frédéric Lépy on 10/04/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme : Meme?
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.image = meme?.memedImage
    }
}
