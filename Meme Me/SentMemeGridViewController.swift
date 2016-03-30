//
//  MemeGridViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 14/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class SentMemeGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [MemeModel]?

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let itemsPerRow = CGFloat(size.height > size.width ? 3.0 : 4.0)
        let spacing = CGFloat(5.0)
        let width = (size.width - (itemsPerRow - 1) * spacing) / itemsPerRow
        flowLayout.itemSize = CGSizeMake(width, width)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
    }
    
    override func viewDidAppear(animated: Bool)
    {
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let nextVC = storyboard?.instantiateViewControllerWithIdentifier("memeDetail") as? MemeDetailViewController {
            nextVC.memeToDisplay = memes?[indexPath.row]
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
