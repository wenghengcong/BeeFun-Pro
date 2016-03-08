//
//  ObjResponseHeader.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/31.
//  Copyright © 2016年 JungleSong. All rights reserved.
//


import UIKit
import ObjectMapper

/*
"Access-Control-Allow-Credentials" = true;
"Access-Control-Allow-Origin" = "*";
"Access-Control-Expose-Headers" = "ETag, Link, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval";
"Cache-Control" = "private, max-age=60, s-maxage=60";
"Content-Encoding" = gzip;
"Content-Security-Policy" = "default-src 'none'";
"Content-Type" = "application/json; charset=utf-8";
Date = "Sun, 31 Jan 2016 09:06:03 GMT";
Etag = "W/\"b2c5f6199e027d93fa523f36a97ad058\"";
Link = "<https://api.github.com/user/starred?direction=desc&sort=created&page=2>; rel=\"next\", <https://api.github.com/user/starred?direction=desc&sort=created&page=17>; rel=\"last\"";
Server = "GitHub.com";
Status = "200 OK";
"Strict-Transport-Security" = "max-age=31536000; includeSubdomains; preload";
"Transfer-Encoding" = Identity;
Vary = "Accept, Authorization, Cookie, X-GitHub-OTP, Accept-Encoding";
"X-Accepted-OAuth-Scopes" = "";
"X-Content-Type-Options" = nosniff;
"X-Frame-Options" = deny;
"X-GitHub-Media-Type" = "github.v3";
"X-GitHub-Request-Id" = "74FBD5F3:1C1EA:104F1885:56ADCE78";
"X-OAuth-Client-Id" = 294e97e63b0e68f456ad;
"X-OAuth-Scopes" = "public_repo, user";
"X-RateLimit-Limit" = 5000;
"X-RateLimit-Remaining" = 4993;
"X-RateLimit-Reset" = 1454234562;
"X-Served-By" = 4c8b2d4732c413f4b9aefe394bd65569;
"X-XSS-Protection" = "1; mode=block";

*/
class ObjResponseHeader: NSObject,Mappable {

    var AccessControlAllowCredentials:String?
    var AccessControlAllowOrigin:String?
    var AccessControlExposeHeaders:String?
    var CacheControl:String?
    var ContentEncoding:String?
    var ContentSecurityPolicy:String?
    var ContentType:String?
    var Date:String?
    var Etag:String?
    var Link:String?
    var Server:String?
    var Status:String?
    var StrictTransportSecurity:String?
    var TransferEncoding:String?
    var Vary:String?
    var XAcceptedOAuthScopes:String?
    var XContentTypeOptions:String?
    var XFrameOptions:String?
    var XGitHubMediaType:String?
    var XGitHubRequestId:String?
    var XOAuthClientId:String?
    var XOAuthScopes:String?
    var XRateLimitLimit:Int?
    var XRateLimitRemaining:Int?
    var XRateLimitReset:Int?
    var XServedBy:String?
    var XXSSProtection:String?

    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        AccessControlAllowCredentials <- map["Access-Control-Allow-Credentials"]
        AccessControlAllowOrigin <- map["Access-Control-Allow-Origin"]
        AccessControlExposeHeaders <- map["Access-Control-Expose-Headers"]
        CacheControl <- map["Cache-Control"]
        ContentEncoding <- map["Content-Encoding"]
        ContentSecurityPolicy <- map["Content-Security-Policy"]
        ContentType <- map["Content-Type"]
        Date <- map["Date"]
        Etag <- map["Etag"]
        Link <- map["Link"]
        Server <- map["Server"]
        Status <- map["Status"]
        StrictTransportSecurity <- map["Strict-Transport-Security"]
        TransferEncoding <- map["Transfer-Encoding"]
        Vary <- map["Vary"]
        XAcceptedOAuthScopes <- map["X-Accepted-OAuth-Scopes"]
        XContentTypeOptions <- map["X-Content-Type-Options"]
        XFrameOptions <- map["X-Frame-Options"]
        XGitHubMediaType <- map["X-GitHub-Media-Type"]
        XGitHubRequestId <- map["X-GitHub-Request-Id"]
        XOAuthClientId <- map["X-OAuth-Client-Id"]
        XOAuthScopes <- map["X-OAuth-Scopes"]
        XRateLimitLimit <- map["X-RateLimit-Limit"]
        XRateLimitRemaining <- map["X-RateLimit-Remaining"]
        XRateLimitReset <- map["X-RateLimit-Reset"]
        XServedBy <- map["X-Served-By"]
        XXSSProtection <- map["X-XSS-Protection"]
    }

}
