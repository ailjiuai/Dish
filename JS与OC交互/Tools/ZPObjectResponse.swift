//
//  ZPObjectResponse.swift
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/15.
//  Copyright © 2015年 zp. All rights reserved.
//

import UIKit

let responseKey = "kResponseKey"
let dataKey = "kDataKey"
class ZPObjectResponse: NSObject,NSCoding {
    var response :NSURLResponse?
    var data :NSData?
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.data, forKey: dataKey)
        aCoder.encodeObject(self.response, forKey: responseKey)
    }
    required init?(coder aDecoder: NSCoder) {
         super.init()
         self.response =   aDecoder.decodeObjectForKey(responseKey) as? NSURLResponse;
        self.data = aDecoder.decodeObjectForKey(dataKey) as? NSData
    }
    override init() {
        super.init()
    }
    
}
