//
//  ZPDishModel.swift
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/17.
//  Copyright © 2015年 zp. All rights reserved.
//

import Foundation
class ZPDishModel: NSObject {
    var htmlURl: NSString?
    var title : NSString?
    var imageUrl : NSString?
    var content: NSString?
       var toUrl: NSString? {
        get {
            return self.htmlURl;
        }
        set {
            if ((newValue?.stringByDeletingPathExtension.containsString("#")) != nil) {
            self.htmlURl =  newValue?.stringByReplacingOccurrencesOfString("#", withString: "")
            }
        }
    }
}
