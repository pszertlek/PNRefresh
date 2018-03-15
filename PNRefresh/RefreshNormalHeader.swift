//
//  RefreshNormalHeader.swift
//  PNRefresh
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

public class RefreshNormalHeader: RefreshHeader {
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            self.setNeedsLayout()
        }
    }
    lazy var arrowView: UIImageView = UIImageView(image: nil)
    lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorViewStyle)
    override func setState(_ oldValue: RefreshState) {
        if state == .idle {
            if oldValue == .refreshing {
                self.arrowView.transform = CGAffineTransform.identity
                UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: { [unowned self] in
                    self.loadingView.alpha = 0.0
                }, completion: { [unowned self] (finished) in
                    if self.state == .idle {
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                })
            } else {
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: { [unowned self] in
                    self.arrowView.transform = .identity
                })
            }
        } else if state == .pull {
            UIView.animate(withDuration: RefreshFastAnimationDuration, animations: { [unowned self] in
                self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(0.000001 - Double.pi))
            })
        } else if state == .refreshing {
            self.loadingView.alpha = 1.0
            self.loadingView.startAnimating()
            self.arrowView.isHidden = true
        }
    }
    
    
}
