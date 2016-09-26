//
//  String+Extension.swift
//  EasyKit
//
//  Created by kimtaewan on 2016. 4. 22..
//  Copyright © 2016년 taewan. All rights reserved.
//

import Foundation


public extension String {
    public subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript(idx i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript(r: Range<Int>) -> String {
        let lower = self.index(self.startIndex, offsetBy: r.lowerBound)
        let upper = self.index(self.startIndex, offsetBy: r.upperBound)
        return substring(with: lower ..< upper)
        
    }
}
