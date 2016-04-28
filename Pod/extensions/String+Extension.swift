//
//  String+Extension.swift
//  EasyKit
//
//  Created by kimtaewan on 2016. 4. 22..
//  Copyright © 2016년 taewan. All rights reserved.
//

import Foundation
import UIKit

public typealias TWKitAttributesWithKey = [String: [String: AnyObject]]
public let TWKitUIImageAttributeName: String = "TWKitUIImageAttributeName"
public let TWKitUIImageOffsetYAttributeName: String = "TWKitUIImageOffsetYAttributeName"

public extension String {
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (idx i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substringWithRange(startIndex.advancedBy(r.startIndex)..<startIndex.advancedBy(r.endIndex))
    }
    
    public func toAttributedString(attrs: TWKitAttributesWithKey) -> NSAttributedString {
        let searchAttr = NSMutableAttributedString(string: self)
        var replacesOffset = 0
        for (key, value) in attrs {
            let ranges = searchAttr.string.rangesOfString(key)
            for range in ranges {
                //이미지를 포함하고 있는건 리플레이스!
                if let image = value[TWKitUIImageAttributeName] as? UIImage {
                    let imageSize = image.size
                    var bounds = CGRectMake(0, 0, imageSize.width, imageSize.height)
                    let newRange = NSMakeRange(range.location - replacesOffset, range.length)
                    
                    //x는 적용해도 반응이 없네.
                    bounds.origin.y -= value[TWKitUIImageOffsetYAttributeName] as? CGFloat ?? 0
                    
                    let attachment = NSTextAttachment()
                    attachment.image = image
                    attachment.bounds = bounds
                    
                    let imageAttrString = NSAttributedString(attachment: attachment)
                    searchAttr.replaceCharactersInRange(newRange, withAttributedString: imageAttrString)
                    //range를 미리 가져오기때문에 offset으로 밀어내준다.
                    replacesOffset += range.length - 1
                } else {
                    searchAttr.addAttributes(value, range: range)
                }
            }
            replacesOffset = 0
        }
        return searchAttr
    }
    
    public func rangesOfString(searchString: String, options mask: NSStringCompareOptions = .LiteralSearch) -> [NSRange] {
        let nsStr = self as NSString
        var results = [NSRange]()
        var searchRange = NSMakeRange(0, nsStr.length);
        var range = nsStr.rangeOfString(searchString, options: mask, range: searchRange)
        
        while range.location != NSNotFound {
            results.append(range)
            searchRange = NSMakeRange(NSMaxRange(range), nsStr.length - NSMaxRange(range))
            range = nsStr.rangeOfString(searchString, options: mask, range: searchRange)
        }
        return results
        
    }
}



