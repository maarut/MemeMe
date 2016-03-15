//
//  MemeGridViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 14/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class SentMemeGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    var memes: [MemeModel]?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeSummaryView", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = memes?[indexPath.row].composedImage
        return cell
    }
}
