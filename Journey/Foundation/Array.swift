//
//  Array.swift
//  Journey
//
//  Created by ltebean on 16/2/20.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import Foundation

extension Array {
    
    func findFirst(match: (Generator.Element) -> Bool) -> Generator.Element? {
        for each in self.lazy {
            if match(each) {
                return each
            }
        }
        return nil
    }
}