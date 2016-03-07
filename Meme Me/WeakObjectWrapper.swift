//
//  WeakObjectWrapper.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 02/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class WeakObjectWrapper<T: AnyObject> {
    weak var item: T?
    
    init(_ item: T)
    {
        self.item = item
    }
}
