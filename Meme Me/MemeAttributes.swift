//
//  MemeAttributes.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 14/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class MemeAttributes {

    static func attributes() -> [String: AnyObject]
    {
        struct DispatchOnce { static var token: dispatch_once_t = 0; static var value = [String: AnyObject]() }
        dispatch_once(&DispatchOnce.token) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
            paragraphStyle.alignment = .Center
            DispatchOnce.value = [
                NSStrokeColorAttributeName: UIColor.blackColor(),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeWidthAttributeName: -3.0,
                NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        }
        return DispatchOnce.value
    }
}
