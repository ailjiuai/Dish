//
//  ZPImageCacheProtocol.swift
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/15.
//  Copyright © 2015年 zp. All rights reserved.
//

import UIKit
import Foundation
class ZPImageCacheProtocol: NSURLProtocol ,NSURLConnectionDataDelegate {
    
    var  kZPImageCacheProtocolKey: NSString = "kZPImageCacheProtocolKey"
    

    var connect :NSURLConnection?
    var data :NSMutableData?
    var response :NSURLResponse?
   override  internal  class func canInitWithRequest(request: NSURLRequest) -> Bool
    {
        let imageURL  = (request.URL?.absoluteString)!  as NSString;
        print(imageURL)
        if ((NSURLProtocol.propertyForKey("kZPImageCacheProtocolKey", inRequest: request)) != nil) {

            return false;
        }
        if (imageURL.pathExtension == "jpg" ) || (imageURL.pathExtension == "png"){

            return false;
        }
        return false;
    }
    override  internal  class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest
    {
        return request;
    }
    override internal class func requestIsCacheEquivalent(a: NSURLRequest, toRequest b: NSURLRequest) -> Bool
    {
      return  super.requestIsCacheEquivalent(a, toRequest: b);
    }
    override func startLoading() {
        
        let newRequest  = self.request.mutableCopy() as! NSMutableURLRequest;
        newRequest.timeoutInterval = 60;
        NSURLProtocol.setProperty(true, forKey: "kZPImageCacheProtocolKey", inRequest: newRequest);
        
        connect = NSURLConnection.init(request: newRequest, delegate: self);

    }
    override func stopLoading() {
        connect?.cancel()
        connect = nil;
    }
}
extension  ZPImageCacheProtocol {
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed);
        self.data = NSMutableData.init()
        self.response = response;
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.client?.URLProtocol(self, didLoadData: data);
        self.data?.appendData(data);
    }
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        self.client?.URLProtocol(self, didReceiveAuthenticationChallenge: challenge);
    }
   
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.client?.URLProtocolDidFinishLoading(self)
        let objRes = ZPObjectResponse()
        objRes.data = self.data;
        objRes.response = self.response;
        ZPImageCache.shareImageCache().storeObject(objRes, forKey: (self.response?.URL?.absoluteString)!, toDisk: true)
        
    }
    func connection(connection: NSURLConnection, didCancelAuthenticationChallenge challenge: NSURLAuthenticationChallenge)
    {
        self.client?.URLProtocol(self, didCancelAuthenticationChallenge: challenge);
    }
    func connection(connection: NSURLConnection, willSendRequest request: NSURLRequest, redirectResponse response: NSURLResponse?) -> NSURLRequest?
    {
      
        if (response != nil) {
            _   = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable, userInfo: nil);
              self.client?.URLProtocol(self, wasRedirectedToRequest: request, redirectResponse: response!);
        }
        return request;
    }
    
}