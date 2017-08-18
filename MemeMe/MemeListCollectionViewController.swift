//
//  MemeListCollectionViewController.swift
//  MemeMe
//
//  Created by Alfian Losari on 18/08/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class MemeListCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    let detailMemeSegueIdentifier = "MemeDetail"
    
    var memes: [Meme] {
        return  (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout(size: view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setupCollectionViewLayout(size: size)
    }
    
    func setupCollectionViewLayout(size: CGSize) {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        if size.width < size.height {
            dimension = (size.width - (2 * space)) / 3.0
        } else {
            dimension = (size.width - (5 * space)) / 6.0
        }
        
        collectionFlowLayout?.minimumInteritemSpacing = space
        collectionFlowLayout?.minimumLineSpacing = space
        collectionFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.meme = memes[indexPath.item]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailMemeSegueIdentifier,
            let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first {
            let memeDetailVC = segue.destination as! MemeDetailViewController
            memeDetailVC.meme = memes[selectedIndexPath.item]
        }
    }

    
}
