//
//  LottieSubtitledView.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import Lottie

class LottieSubtitledView: UIView {
    @IBOutlet weak var animationView: LOTAnimationView!
    @IBOutlet weak var subtitle: UILabel!
    var animationName: String = ""
    var subtitleName: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LottieSubtitledView", owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            animationView.setAnimation(named: animationName)
            animationView.loopAnimation = true
            animationView.play()
            subtitle.text = subtitleName
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }
        animationView.prepareForAutolayout()
        subtitle.prepareForAutolayout()
        addSubview(animationView)
        addSubview(subtitle)
        
        // create layout constraints
        let horizontalConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal,
                                                      toItem: superview, attribute: .centerX,
                                                      multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal,
                                                      toItem: superview, attribute: .centerY,
                                                      multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
                                                toItem: nil, attribute: .notAnAttribute,
                                                multiplier: 1, constant: frame.width)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute,
                                                  multiplier: 1, constant: frame.height)
        superview.addConstraints([horizontalConstraint, verticalConstraint,
                                  widthConstraint, heightConstraint])
        self.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 1
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            self?.animationView.alpha = 0
            self?.subtitle.alpha = 0
        }, completion: { [weak self] _ in
            self?.animationView.stop()
            self?.animationView.removeFromSuperview()
            self?.subtitle.removeFromSuperview()
            self?.removeFromSuperview()
        })
 
    }
    
}

private extension UIView {
    
    func prepareForAutolayout() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
