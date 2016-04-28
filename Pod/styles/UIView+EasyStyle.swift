//
//  UIView+EasyStyle.swift
//  EasyKit
//
//  Created by kimtaewan on 2016. 4. 22..
//  Copyright © 2016년 taewan. All rights reserved.
//


import UIKit

public extension UIView {
    @IBInspectable
    public var easyStyle: String {
        get { return "support only setter" }
        set {
            let styles = newValue.componentsSeparatedByString(",")
            for style in styles {
                guard let easyStyle = EasyStyleManager.sharedInstance[style] else { continue }
                applyStyle(easyStyle)
            }
        }
    }
}


private extension UIView {
    func applyStyle(style: EasyStyle) {
        if let parent = style.parentStyle {
            self.applyStyle(parent)
        }
        style.configrationBlock(self)
    }
}