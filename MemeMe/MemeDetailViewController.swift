//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alfian Losari on 18/08/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    let editMemeSegueIdentifier = "EditMeme"

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme?.memedImage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editMemeSegueIdentifier {
            guard let editMemeViewController = segue.destination as? MemeEditViewController else { fatalError("Unknown Segue") }
            editMemeViewController.editMeme = meme
            editMemeViewController.memeDetailViewController = self
        }
        
    }

}
