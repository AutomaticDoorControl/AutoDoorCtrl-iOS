//
//  PageContentViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 8/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

open class PageContentViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    
    public var showcaseImageView: UIImageView?
    
    private var dataSet: PageContentDataSet?
    
    // MARK: - Overridables
    
    /// Override to define the text shown in the button
    open var buttonText: String? { return nil }
    
    /// Override to set the action executed when the button is tapped.
    @objc open func buttonTapped(sender: UIButton) { }
    
    /// Override to set the background color of the button.
    open var buttonBackgroundColor: UIColor { return UIColor.blue }
    
    /// Override to set the color of the text in the button.
    open var buttonTextColor: UIColor { return UIColor.black }
    
    // MARK: - Life cycle & init
    
    /// The button will only be shown if there's no image in the data set. Vise versa, the button will be hidden if there's an image.
    public init(dataSet: PageContentDataSet) {
        super.init(nibName: "PageContentViewController", bundle: .main)
        self.dataSet = dataSet
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.textContainerInset = UIEdgeInsets.zero
        contentTextView.textContainer.lineFragmentPadding = 0
        if dataSet?.showcaseImage == nil {
            actionButton.setTitle(buttonText, for: .normal)
            actionButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
        
        actionButton.setTitleColor(buttonTextColor, for: .normal)
        actionButton.backgroundColor = buttonBackgroundColor
        actionButton.addRoundedCorner()
        titleLabel.text = dataSet?.title
        contentTextView.text = dataSet?.content
        
        // scale text down if the user is on iPhone SE or 5S
        if isRunningOnFourInch {
            let ratio: CGFloat = UIScreen.main.bounds.height / 667
            titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 24 * ratio)
            contentTextView.font = UIFont(name: "AvenirNext-Regular", size: 17 * ratio)
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // need to add the showcase image manually because UIImageView in IB
        // does not allow align top + aspect fill combination
        if let image = dataSet?.showcaseImage, showcaseImageView == nil {
            actionButton.removeFromSuperview()
            let aspectRatio: CGFloat = image.size.height / image.size.width
            let showcase = UIImageView(frame: CGRect(
                x: contentTextView.frame.origin.x,
                y: contentTextView.frame.maxY + (isRunningOnFourInch ? 0 : 20),
                width: contentTextView.frame.width,
                height: contentTextView.frame.width * aspectRatio))
            showcase.image = image
            showcase.contentMode = .scaleAspectFill
            view.addSubview(showcase)
            showcaseImageView = showcase
        }
    }
    
    private var isRunningOnFourInch: Bool {
        return UIScreen.main.bounds.height < 660
    }
}
