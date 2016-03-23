//
//  MemeModel.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 08/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

struct MemeModel: Equatable
{
    var topTextField: String
    var bottomTextField: String
    var originalImage: UIImage
    var composedImage: UIImage
    var contentOffset: CGPoint
    var contentSize: CGSize
    var zoomScale: Float
}

func ==(lhs: MemeModel, rhs: MemeModel) -> Bool
{
    return lhs.topTextField == rhs.topTextField &&
    lhs.bottomTextField == rhs.bottomTextField &&
    lhs.originalImage == rhs.originalImage &&
    lhs.contentOffset == rhs.contentOffset &&
    lhs.contentSize == rhs.contentSize &&
    lhs.zoomScale == rhs.zoomScale
}
