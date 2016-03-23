//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 22/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memeToDisplay: MemeModel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        imageView.image = memeToDisplay?.composedImage
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        let rightItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(MemeDetailViewController.editPressed(_:)))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightItem
    }
    
    func editPressed(sender: UIBarButtonItem)
    {
        if let nextVC = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as? MemeEditorViewController {
            nextVC.memeModel = memeToDisplay
            presentViewController(nextVC, animated: true, completion: nil)
        }
    }

}
