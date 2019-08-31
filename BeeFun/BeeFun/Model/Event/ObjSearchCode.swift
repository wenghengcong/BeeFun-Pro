//
//  ObjSearchCode.swift
//  BeeFun
//
//  Created by WengHengcong on 11/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "git_url": "https://api.github.com/repositories/91869205/git/blobs/ebcf232789ff70f5e78a401cba3646216a1e20c3",
    "html_url": "https://github.com/cohena100/Shimi/blob/63aff29a6e822588f3a8cb6f080c8021405dd508/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift",
    "name": "UISegmentedControlExtensionsTests.swift",
    "path": "Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift",
    "repository": {
        ......,
        "owner": {
        },
    },
    "score": 4.027219,
    "sha": "ebcf232789ff70f5e78a401cba3646216a1e20c3",
    "url": "https://api.github.com/repositories/91869205/contents/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift?ref=63aff29a6e822588f3a8cb6f080c8021405dd508"
},
*/

// MARK: - 更为完整的属性
/*
 git_url->的结果，其中content是搜索到的代码，base64加密后的显示
 {
 sha: "ebcf232789ff70f5e78a401cba3646216a1e20c3",
 size: 885,
 url: "https://api.github.com/repos/cohena100/Shimi/git/blobs/ebcf232789ff70f5e78a401cba3646216a1e20c3",
 content: "Ly8KLy8gIFVJU2VnbWVudGVkQ29udHJvbEV4dGVuc2lvbnNUZXN0cy5zd2lm dAovLyAgU3dpZnRlclN3aWZ0Ci8vCi8vICBDcmVhdGVkIGJ5IFN0ZXZlbiBv biAyLzE1LzE3LgovLyAgQ29weXJpZ2h0IMKpIDIwMTcgb21hcmFsYmVpay4g QWxsIHJpZ2h0cyByZXNlcnZlZC4KLy8KCiNpZiBvcyhpT1MpIHx8IG9zKHR2 T1MpCgppbXBvcnQgWENUZXN0CkB0ZXN0YWJsZSBpbXBvcnQgU3dpZnRlclN3 aWZ0CgpjbGFzcyBVSVNlZ21lbnRlZENvbnRyb2xFeHRlbnNpb25zVGVzdHM6 IFhDVGVzdENhc2UgewoKICAgIGZ1bmMgdGVzdFNlZ21lbnRUaXRsZXMoKSB7 CiAgICAgICAgbGV0IHNlZ21lbnRDb250cm9sID0gVUlTZWdtZW50ZWRDb250 cm9sKCkKICAgICAgICBYQ1RBc3NlcnQoc2VnbWVudENvbnRyb2wuc2VnbWVu dFRpdGxlcy5pc0VtcHR5KQogICAgICAgIGxldCB0aXRsZXMgPSBbIlRpdGxl MSIsICJUaXRsZTIiXQogICAgICAgIHNlZ21lbnRDb250cm9sLnNlZ21lbnRU aXRsZXMgPSB0aXRsZXMKICAgICAgICBYQ1RBc3NlcnRFcXVhbChzZWdtZW50 Q29udHJvbC5zZWdtZW50VGl0bGVzLCB0aXRsZXMpCiAgICB9CiAgICAKICAg IGZ1bmMgdGVzdFNlZ21lbnRJbWFnZXMoKSB7CiAgICAgICAgbGV0IHNlZ21l bnRDb250cm9sID0gVUlTZWdtZW50ZWRDb250cm9sKCkKICAgICAgICBYQ1RB c3NlcnQoc2VnbWVudENvbnRyb2wuc2VnbWVudEltYWdlcy5pc0VtcHR5KQog ICAgICAgIGxldCBpbWFnZXMgPSBbVUlJbWFnZSgpLCBVSUltYWdlKCldCiAg ICAgICAgc2VnbWVudENvbnRyb2wuc2VnbWVudEltYWdlcyA9IGltYWdlcwog ICAgICAgIFhDVEFzc2VydEVxdWFsKHNlZ21lbnRDb250cm9sLnNlZ21lbnRJ bWFnZXMsIGltYWdlcykKICAgIH0KfQojZW5kaWYK ",
 encoding: "base64"
 }
 */

/*
 url-> 更为完整的代码片段的属性
 
 name: "UISegmentedControlExtensionsTests.swift",
 path: "Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift",
 sha: "ebcf232789ff70f5e78a401cba3646216a1e20c3",
 size: 885,
 url: "https://api.github.com/repos/cohena100/Shimi/contents/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift?ref=63aff29a6e822588f3a8cb6f080c8021405dd508",
 html_url: "https://github.com/cohena100/Shimi/blob/63aff29a6e822588f3a8cb6f080c8021405dd508/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift",
 git_url: "https://api.github.com/repos/cohena100/Shimi/git/blobs/ebcf232789ff70f5e78a401cba3646216a1e20c3",
 download_url: "https://raw.githubusercontent.com/cohena100/Shimi/63aff29a6e822588f3a8cb6f080c8021405dd508/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift",
 type: "file",
 content: " ",
 encoding: "base64",
 _links: {
 self: "https://api.github.com/repos/cohena100/Shimi/contents/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift?ref=63aff29a6e822588f3a8cb6f080c8021405dd508",
 git: "https://api.github.com/repos/cohena100/Shimi/git/blobs/ebcf232789ff70f5e78a401cba3646216a1e20c3",
 html: "https://github.com/cohena100/Shimi/blob/63aff29a6e822588f3a8cb6f080c8021405dd508/Carthage/Checkouts/SwifterSwift/Tests/SwifterSwiftTests/UIKitExtensionsTests/UISegmentedControlExtensionsTests.swift"
 }
 }
 */
class ObjSearchCode: NSObject, Mappable {

    /// 获取后得到该代码的部分属性
    var git_url: String?
    
    /// 可以显示代码的网址，跳转打开的页面
    var html_url: String?
    var name: String?
    var path: String?
    
    var repository: ObjRepos?
    var score: Double?
    var sha: String?
    /// 获取后得到该代码的全部属性
    var url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        git_url <- map["git_url"]
        html_url <- map["html_url"]
        name <- map["name"]
        path <- map["path"]
        repository <- map["repository"]
        score <- map["score"]
        sha <- map["sha"]
        url <- map["url"]
    }
}
