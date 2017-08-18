//
//  Meme.swift
//  MemeMe
//
//  Created by Alfian Losari on 17/08/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}

extension Meme: Equatable {
    
    public static func ==(lhs: Meme, rhs: Meme) -> Bool {
        return lhs.topText == rhs.topText &&
            lhs.bottomText == rhs.bottomText &&
            lhs.originalImage == rhs.originalImage &&
            lhs.memedImage == rhs.memedImage
    }

}
