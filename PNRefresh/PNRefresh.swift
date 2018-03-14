//
//  PNRefresh.swift
//  PNRefresh
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
    public typealias ScrollView = NSScrollView
#else
    import UIKit
    public typealias ScrollView = UIScrollView
    public typealias EdgeInsets = UIEdgeInsets
#endif

public final class PNRefresh<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol PNRefreshCompatible {
    associatedtype CompatibleType
    var pn: CompatibleType { get }
}

public extension PNRefreshCompatible {
    public var pn: PNRefresh<Self> {
        get { return PNRefresh(self) }
    }
}

extension ScrollView: PNRefreshCompatible {}
extension UIView: PNRefreshCompatible {}
