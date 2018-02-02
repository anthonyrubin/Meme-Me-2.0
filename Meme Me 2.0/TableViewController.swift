//
//  ViewController.swift
//  Meme Me 2.0
//
//  Created by Anthony Rubin on 1/31/18.
//  Copyright © 2018 Anthony Rubin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var memes: [Meme] {
      //  return (UIApplication.shared.delegate as! AppDelegate).memes
    //}
    var memes = [Meme]()
    
    @IBOutlet weak var memeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeTableView.delegate = self
        memeTableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
 
    override func viewWillAppear(_ animated: Bool) {
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        memeTableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let meme = memes[indexPath.row]
      
        var memeImageView = cell.viewWithTag(1) as! UIImageView

        memeImageView.image = meme.memeImage
       return cell
    }
}
