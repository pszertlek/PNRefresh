//
//  UIView+Extension.swift
//  PNRefresh
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

public extension PNRefresh where Base: UIView {
    var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            base.frame.origin.x = newValue
        }
    }
    var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            base.frame.origin.y = newValue
        }
    }
    var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            base.frame.size.width = newValue
        }
    }
    var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            base.frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get {
            return base.frame.size
        }
        set {
            base.frame.size = newValue
        }
    }
    
    var origin: CGPoint {
        get {
            return base.frame.origin
        }
        set {
            base.frame.origin = newValue
        }
    }
}
