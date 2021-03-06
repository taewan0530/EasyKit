//
//  UIView+GetConstraint.swift
//  EasyKit
//
//  IBOulet로 Constraint를 참조 시키는게 개취가 아니라 만든 extension
//  
//
//  Created by kimtaewan on 2016. 4. 27..
//  Copyright © 2016년 taewan. All rights reserved.
//

import UIKit

public extension UIView {
  
    public func getConstraint(identifier: String) -> NSLayoutConstraint? {
        if let superview = self.superview {
            for constraint in superview.constraints where constraint.identifier == identifier {
                return constraint
            }
        }
        for constraint in self.constraints where constraint.identifier == identifier {
            return constraint
        }
        return nil
    }

    public func getConstraint(attribute attr: NSLayoutAttribute) -> NSLayoutConstraint? {
        let constrinsts = getConstraints(attribute: attr)
        if constrinsts.count == 1 {
            return constrinsts.first
        }
        //active deactive도 확인한번 해줄까.
        return constrinsts.max {
             $0.0.priority < $0.1.priority
        }
    }

    public func getConstraints(attribute attr: NSLayoutAttribute) -> [NSLayoutConstraint] {
        return getConstraints(item: self, attribute: attr)
    }

    public func getConstraints(item view: AnyObject, attribute attr1: NSLayoutAttribute) -> [NSLayoutConstraint] {
        var results: [NSLayoutConstraint] = []

        if let superview = self.superview {
            results += UIView.targetFromConstraints(target: superview, item: view, attribute: attr1)
        }
        results += UIView.targetFromConstraints(target: self, item: view, attribute: attr1)
        
        return results
    }
    
    
    private class func targetFromConstraints(target: AnyObject, item view: AnyObject?, attribute attr: NSLayoutAttribute) -> [NSLayoutConstraint] {
        var results: [NSLayoutConstraint] = []
        
        for constraint in target.constraints {
            if "NSContentSizeLayoutConstraint" == classNameAsString(obj: constraint) {
                continue
            }
            
            let targetAttribute: NSLayoutAttribute
            
            if "_UILayoutGuide" == classNameAsString(obj: constraint.firstItem) {
                targetAttribute = constraint.secondAttribute
            } else {
                targetAttribute = constraint.firstAttribute
            }
         
            let firstItemEqual: Bool
            let secondItemEqual: Bool
            
            if view == nil {
                firstItemEqual =  constraint.secondItem === target
                secondItemEqual = constraint.firstItem === target
            } else {
                firstItemEqual = constraint.firstItem === view
                secondItemEqual = constraint.secondItem === view
            }
            
            guard targetAttribute == attr && (firstItemEqual || secondItemEqual) else {
                continue
            }
            
            results.append(constraint)
        }
        return results
    }


    static func classNameAsString(obj: AnyObject) -> String {
        return  type(of: obj).description().components(separatedBy:"__").last!
    }
}
