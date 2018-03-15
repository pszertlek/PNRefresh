//
//  RefreshComponent.swift
//  PNRefresh
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

public enum RefreshState {
    case idle
    case pull
    case refreshing
    case willRefresh
    case noMoreData
}

public typealias RefreshingCompletionBlock = () -> Void
public typealias BeginRefreshCompletionBlock = () -> Void
public typealias EndRefreshCompletionBlock = () -> Void

public class RefreshComponent: UIView {
    var scrollViewOriginInset: UIEdgeInsets!
    
    var refreshingCompletion: RefreshingCompletionBlock?
    var beginRefreshCompletion: BeginRefreshCompletionBlock?
    var endRefreshCompletion: EndRefreshCompletionBlock?
    
    var refreshing: Bool {
        return state == .refreshing || state == .willRefresh
    }
    var state = RefreshState.idle {
        didSet {
            guard state != oldValue else {
                return
            }
            self.setState(oldValue)
        }
    }
    var automaticallyChangeAlpha: Bool = false {
        didSet {
            if automaticallyChangeAlpha {
                self.alpha = pullPercent
            } else {
                alpha = 1.0
            }
        }
    }
    var pullPercent: CGFloat = 0 {
        didSet {
            if !refreshing {
                alpha = self.pullPercent
            }
        }
    }
    weak var scrollView: UIScrollView!
    
    private var pan: UIPanGestureRecognizer!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override public func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    
    func setState(_ oldValue: RefreshState) {
        if Thread.isMainThread {
            setNeedsLayout()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }
    
    //MARK: KVO
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new,.old]
        self.addObserver(self, forKeyPath: RefreshKeyPathContentOffset, options: options, context: nil)
        self.addObserver(self, forKeyPath: RefreshKeyPathContentSize, options: options, context: nil)
        self.pan = self.scrollView.panGestureRecognizer
        self.pan.addObserver(self, forKeyPath: RefreshKeyPathPanState, options: options, context: nil)
    }
    
    func removeObservers() {
        self.removeObserver(self, forKeyPath: RefreshKeyPathContentSize)
        self.removeObserver(self, forKeyPath: RefreshKeyPathContentOffset)
        self.pan = nil
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard isUserInteractionEnabled else {
            return
        }
        if keyPath == RefreshKeyPathContentSize {
            scrollViewContentSizeDidChange(change)
            return
        }
        guard !isHidden else {
            return
        }
        
        if keyPath == RefreshKeyPathContentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == RefreshKeyPathPanState {
            scrollViewStateDidChange(change)
        }
        
    }
    
    
    //MARK: 控制刷新
    public func beginRefresh() {
        UIView.animate(withDuration: RefreshFastAnimationDuration) { [weak self] in
            self?.alpha = 1.0
        }
        self.pullPercent = 1.0
        if self.window != nil {
            self.state = .refreshing
        } else {
            if (self.state != .refreshing) {
                self.state = .willRefresh
                setNeedsDisplay()
            }
        }
    }
    
    public func beginRefresh(completion: @escaping BeginRefreshCompletionBlock) {
        self.beginRefreshCompletion = completion
        beginRefresh()
    }
    
    public func endRefresh() {
        if Thread.isMainThread {
            self.state = .idle
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.state = .idle
            }
        }
    }
    
    public func endRefresh(completion: @escaping EndRefreshCompletionBlock) {
        self.endRefreshCompletion = completion
        endRefresh()
    }
    
    func executeRefreshingCallback() {
        DispatchQueue.main.async { [unowned self] in
            self.beginRefreshCompletion?()
            self.refreshingCompletion?()
        }
    }
    
    //MARK: subclasses overrides
    func prepare() {
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    func placeSubviews() {
        
    }
    
    func scrollViewContentOffsetDidChange(_ changes: [NSKeyValueChangeKey: Any]?) {
        
    }
    
    func scrollViewContentSizeDidChange(_ changes: [NSKeyValueChangeKey: Any]?) {
        
    }
    
    func scrollViewStateDidChange(_ changes: [NSKeyValueChangeKey: Any]?) {
        
    }
    
}
