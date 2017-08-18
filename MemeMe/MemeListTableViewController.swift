//
//  MemeListTableViewController.swift
//  MemeMe
//
//  Created by Alfian Losari on 18/08/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class MemeListTableViewController: UITableViewController {
    
    let detailMemeSegueIdentifier = "MemeDetail"
    
    var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    var memes: [Meme] {
       return  appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MemeTableViewCell
        cell.meme = memes[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailMemeSegueIdentifier,
            let selectedIndexPath = tableView.indexPathForSelectedRow{
            let memeDetailVC = segue.destination as! MemeDetailViewController
            memeDetailVC.meme = memes[selectedIndexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            if isEditing && memes.count == 0 {
                setEditing(false, animated: true)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }

}
