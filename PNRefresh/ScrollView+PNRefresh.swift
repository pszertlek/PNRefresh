//
//  ScrollView+PNRefresh.swift
//  PNRefresh
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

extension PNRefresh where Base: ScrollView {
    var inset: EdgeInsets {
        get {
            if #available(iOS 11, *) {
                return base.adjustedContentInset
            } else {
                return base.contentInset
            }
        }
    }
    
    var insetTop: CGFloat {
        set {
            var inset = base.contentInset
            inset.top = newValue
            if #available(iOS 11, *) {
                inset.top -= base.adjustedContentInset.top - base.contentInset.top
            }
            base.contentInset = inset
        }
        get {
            return self.inset.top
        }
    }
    
    var insetBottom: CGFloat {
        get {
            return self.inset.bottom
        }
        set {
            var inset = base.contentInset
            inset.bottom = newValue
            if #available(iOS 11, *) {
                inset.bottom -= base.adjustedContentInset.top - base.contentInset.top
            }
            base.contentInset = inset
        }
    }
    
    var insetLeft: CGFloat {
        get {
            return self.inset.left
        }
        set {
            base.contentInset.left = newValue
        }
    }
    
    var insetRight: CGFloat {
        get {
            return self.inset.right
        }
        set {
            base.contentInset.right = newValue
        }
    }
    
    var offsetX: CGFloat {
        get {
            return base.contentOffset.x
        }
        set {
            base.contentOffset.x = newValue
        }
    }
    
    var offsetY: CGFloat {
        get {
            return base.contentOffset.y
        }
        set {
            base.contentOffset.y = newValue
        }
    }
    
    var contentWidth: CGFloat {
        get {
            return base.contentSize.width
        }
        set {
            base.contentSize.width = newValue
        }
    }
    
    var contentHeight: CGFloat {
        get {
            return base.contentSize.width
        }
        set {
            base.contentSize.height = newValue
        }
    }
}
