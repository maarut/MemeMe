//
//  MemeListViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 14/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class SentMemeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var memes: [MemeModel]?
    private var memeToDisplay: MemeModel?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memes?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let model = memes?[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("memeSummaryView")!
        let image = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        image.image = memes?[indexPath.row].composedImage
        label.text = "\(model?.topTextField ?? "")\n\(model?.bottomTextField ?? "")"
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let nextVC = storyboard?.instantiateViewControllerWithIdentifier("memeDetail") as? MemeDetailViewController {
            nextVC.memeToDisplay = memes?[indexPath.row]
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }

}
