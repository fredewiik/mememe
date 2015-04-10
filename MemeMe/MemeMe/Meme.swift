//
//  Meme.swift
//  MemeMe
//
//  Created by Frédéric Lépy on 08/04/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class Meme {
    
    var topString : String?
    var bottomString : String?
    var image : UIImage?
    var memedImage : UIImage?
   
    init (topText: String?, bottomText: String?, image: UIImage?, memedImage: UIImage?) {
        
        self.topString = topText
        self.bottomString = bottomText
        self.image = image
        self.memedImage = memedImage
        
    }
    
}

