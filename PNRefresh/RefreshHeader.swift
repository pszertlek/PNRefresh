//
//  RefreshHeader.swift
//  PNRefresh
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

public class RefreshHeader: RefreshComponent {
    
    var lastUpdatedTimeKey: String!
    var insetTDelta: CGFloat = 0
    var lastUpdatedTime: Date? {
        get {
            return UserDefaults.standard.value(forKey: self.lastUpdatedTimeKey) as? Date
        }
    }
    var ignoredScrollViewContentInsetTop: CGFloat = 0
    convenience init(refreshCompletion: RefreshingCompletionBlock) {
        self.init(frame: CGRect.zero)
        self.refreshingCompletion = refreshingCompletion
    }
    
    override func prepare() {
        super.prepare()
        self.lastUpdatedTimeKey = RefreshHeaderLastUpdatedTimeKey
        self.pn.height = RefreshHeaderHeight
    }
    
    override func setState(_ oldValue: RefreshState) {
        if state == RefreshState.idle {
            if oldValue != .refreshing {
                return
            }
            UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
            UserDefaults.standard.synchronize()
            UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: { [weak self] in
                if let instance = self {
                    instance.scrollView.pn.insetTop += instance.insetTDelta
                    if instance.automaticallyChangeAlpha {
                        instance.alpha = 0
                    }
                }
                
                }, completion: { [weak self](finished) in
                    self?.pullPercent = 0
                    self?.endRefreshCompletion?()
            })
        } else if state == .refreshing {
            DispatchQueue.main.async {
                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: { [unowned self] in
                    let top = self.scrollViewOriginInset.top + self.pn.height
                    self.scrollView.pn.insetTop = top
                    var offset = self.scrollView.contentOffset
                    offset.y = -top
                    self.scrollView .setContentOffset(offset, animated: false)
                    }, completion: { [unowned self](finished) in
                        self.executeRefreshingCallback()
                })
            }
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.pn.y = 0 - self.pn.height - ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(_ changes: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(changes)
        guard let _ = window else {
            return
        }
        if self.state == RefreshState.refreshing {
            var insetTop = -scrollView.pn.offsetY > scrollViewOriginInset.top ? -scrollView.pn.offsetY : scrollViewOriginInset.top
            insetTop = insetTop > self.pn.height + scrollViewOriginInset.top ? self.pn.height + scrollViewOriginInset.top : insetTop
            scrollView.pn.insetTop = insetTop
            insetTDelta = scrollViewOriginInset.top - insetTop
            return
        }
        scrollViewOriginInset = scrollView.pn.inset
        let offsetY = scrollView.pn.offsetY
        let happenOffsetY = -scrollViewOriginInset.top
        if offsetY > happenOffsetY {
            return;
        }
        let normal2PullingOffsetY = happenOffsetY - self.pn.height
        let pullingPercent = (happenOffsetY - offsetY) / self.pn.height
        if scrollView.isDragging {
            self.pullPercent = pullingPercent
            if self.state == RefreshState.idle
                && offsetY < normal2PullingOffsetY {
                self.state = RefreshState.pull
            } else if self.state == RefreshState.pull
                && offsetY > normal2PullingOffsetY {
                self.state = RefreshState.idle
            }
        } else if (self.state == RefreshState.pull) {
            self.beginRefresh()
        } else if pullingPercent < 1 {
            self.pullPercent = pullingPercent
        }
    }
    
}
