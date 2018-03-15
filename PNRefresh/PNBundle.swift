//
//  PNBundle.swift
//  PNRefresh
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 Pszertlek. All rights reserved.
//

import Foundation

class PNBundle {
    static var refreshBundle: Bundle = Bundle(path: Bundle(for: RefreshComponent.self).path(forResource: "Refresh", ofType: "bundle")!)!
    
    static var arrowImage: UIImage = UIImage(contentsOfFile: PNBundle.refreshBundle.path(forResource: "arrow@2x", ofType: "png")!)!
}
