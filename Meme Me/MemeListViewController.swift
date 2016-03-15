//
//  MemeListViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 14/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class SentMemeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    private var memes: [MemeModel]?
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
