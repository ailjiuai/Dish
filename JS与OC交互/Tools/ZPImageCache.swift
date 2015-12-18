//
//  ZPImageCache.swift
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/15.
//  Copyright © 2015年 zp. All rights reserved.
//

import UIKit

class ZPImageCache: NSObject {

    var cache : NSCache?
    var ioQueue : dispatch_queue_t!
    
    let ZPCacheName = "com.zp.JS与OC交互";
    
    let maxCacheAge = 60*60*60*7 ; // 一周
    class  func shareImageCache() -> ZPImageCache {
        let imageCache: ZPImageCache? = ZPImageCache()
        return imageCache!
    }
    override init() {
        self.ioQueue = dispatch_queue_create("com.html.dataCache", DISPATCH_QUEUE_SERIAL);
        cache = NSCache?.init()
        cache?.name = ZPCacheName;
    }
    
    func memoryCache(forkey key: String)-> NSData {
        let objc =  self.cache?.objectForKey(key) as! ZPObjectResponse;
        return objc.data!;
    }
    
    func diskCache(forKey key: String) -> NSData? {
        let objc =  self.cache?.objectForKey(key) as! ZPObjectResponse;
        if (objc.data != nil) {
        return objc.data!;
        }
        
        return self.objectFromDiskCacheForkey(key);
        
    }
    func objectFromDiskCacheForkey(key: String) -> NSData? {
        let path = self.cachePathForKey(forkey: key)
        let data = NSData.dataWithContentsOfMappedFile(path) as? NSData
        if (data != nil)  {
          let object =  NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! ZPObjectResponse;
            if object.data != nil {
                self.cache?.setObject(object, forKey: key);
                return object.data!;
            }
            
        }
        return nil;
    }
    func storeObject(objeResponse :ZPObjectResponse, forKey key :String) {
        storeObject(objeResponse, forKey: key, toDisk: true);
    }
    func storeObject(objeResponse :ZPObjectResponse, forKey key :String, toDisk isDisk: Bool) {
        self.cache?.setObject(objeResponse, forKey: key);
        if !isDisk {
            return
        }
        dispatch_async(self.ioQueue) { () -> Void in
           
            let data  = NSKeyedArchiver.archivedDataWithRootObject(objeResponse);
            let fileManager = NSFileManager.defaultManager();
            if (!fileManager.fileExistsAtPath(self.cachePath()))
            {
                do {
            try fileManager.createDirectoryAtPath(self.cachePath(), withIntermediateDirectories: true, attributes: nil);
                    
                } catch {
                    print(error)
                }
            }
            if (!fileManager.createFileAtPath(self.cachePathForKey(forkey: key), contents: data, attributes: nil)) {
                print("error");
            }
            
        };
        
    }
    
    func cachePath()-> String {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first
        let   finishPath = (path as! NSString).stringByAppendingPathComponent("com.zp.htmlContent") as String
        return finishPath;
    }
    func cachePathForKey(forkey key: String) -> String {
        print("key----\(key)");
        let md5Key = (key as NSString).toMD5ForKey();
        let path = ( self.cachePath() as NSString ).stringByAppendingPathComponent(md5Key);
        return path;
    }
  
}


