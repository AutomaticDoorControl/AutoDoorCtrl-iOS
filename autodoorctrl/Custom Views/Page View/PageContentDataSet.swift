//
//  PageContentDataSet.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 8/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

/// This class represents the contnets presented in `PacgeContentViewController`.
public struct PageContentDataSet {
    let title: String
    let content: String
    let showcaseImageForiPhone: UIImage?
    let showcaseImageForiPad: UIImage?
    let imageVerticalOffset: CGFloat
    
    
    /// Designated initializer.
    /// - Parameter title: A string presenting the title shown in the vc.
    /// - Parameter content: A string showing the body text/
    /// - Parameter showcaseImage: An image repesent a showcase image shown directly below the content.
    /// - Parameter fourInchBackupImage: An image used for 4 inch iPhones to maintain visual consistency. If this is provided and the device the app runs on is a 4 inch iPhone, this image will be used instead.
    /// - Parameter imageVerticalOffset: Defaults to -100. This will move the image vertically on screen. Negative numbers move it up, poisitive is down.
    /// - The button will only be shown if there's no image in the data set. Vise versa, the button will be hidden if there's an image.
    public init(
        title: String,
        content: String,
        showcaseImage: UIImage?,
        fourInchBackupImage: UIImage? = nil,
        showcaseImageForiPad: UIImage? = nil,
        imageVerticalOffset: CGFloat = -100)
    {
        self.title = title
        self.content = content
        if let backup = fourInchBackupImage, UIScreen.main.bounds.height < 660 {
            self.showcaseImageForiPhone = backup
        } else {
            self.showcaseImageForiPhone = showcaseImage
        }
        self.imageVerticalOffset = imageVerticalOffset
        self.showcaseImageForiPad = showcaseImageForiPad
    }
}
