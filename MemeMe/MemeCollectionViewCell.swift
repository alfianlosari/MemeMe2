//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Alfian Losari on 18/08/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    @IBOutlet weak var memeTopLabel: UILabel!
    @IBOutlet weak var memeBottomLabel: UILabel!

    let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 17)!,
        NSStrokeWidthAttributeName: Float(-4.0)
    ]
    
    
    var meme: Meme! {
        didSet {
            guard let meme = meme else { return }
            imageView.image = meme.originalImage
            memeTopLabel.attributedText = NSAttributedString(string: meme.topText, attributes: memeTextAttributes)
            memeBottomLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes)
        }
    }
    
}
