//
//  FYJavascriptHelper.swift
//  PartnerApp
//
//  Created by Yan on 2018/9/11.
//  Copyright © 2018年 Yan. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit

@objc protocol SwiftJavaScriptDelegate: JSExport {
    func payment()
    
    func finishActivity()
}

class FYJavaScriptHelper: NSObject, SwiftJavaScriptDelegate {
    
    var complete: ((String, [Any])->Void)!
    
    func payment() {
        complete("payment", JSContext.currentArguments())
    }
    
    func finishActivity() {
        complete("finishActivity", JSContext.currentArguments())
    }
}

extension UIWebView {
    func callback(_ name: String, complete:@escaping (String, [Any])->Void) {
        if let jsContext = self.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            let callBack : @convention(block) () -> () = {
                complete(name, JSContext.currentArguments())
            }
            jsContext.setObject(unsafeBitCast(callBack, to: AnyObject.self), forKeyedSubscript: name as NSCopying & NSObjectProtocol)
            let helper = FYJavaScriptHelper()
            helper.complete = complete
            jsContext.setObject(helper, forKeyedSubscript: "WebViewJavascriptBridge" as NSCopying & NSObjectProtocol)
        }
    }
}

extension WKWebView {
    func callback(_ name: String, complete:@escaping (String, [Any])->Void) {
        if let jsContext = self.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            let callBack : @convention(block) () -> () = {
                complete(name, JSContext.currentArguments())
            }
            jsContext.setObject(unsafeBitCast(callBack, to: AnyObject.self), forKeyedSubscript: name as NSCopying & NSObjectProtocol)
            let helper = FYJavaScriptHelper()
            helper.complete = complete
            jsContext.setObject(helper, forKeyedSubscript: "WebViewJavascriptBridge" as NSCopying & NSObjectProtocol)
        }
    }
}
