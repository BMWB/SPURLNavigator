//
//  SPURLNavigatorController.swift
//  SwiftSDK
//
//  Created by WTJ on 2020/7/15.
//  Copyright © 2020 Wtj. All rights reserved.
//  仅用作 OC 调用 Swift 不调用此协议
//  https://github.com/devxoul/URLNavigator

import UIKit
import URLNavigator
import URLMatcher

@objc open class SPURLConvertible: NSObject {
    var urlValue: URL?
    var urlStringValue: String?
    
    /// Returns URL query parameters. For convenience, this property will never return `nil` even if
    /// there's no query string in the URL. This property doesn't take care of the duplicated keys.
    /// For checking duplicated keys, use `queryItems` instead.
    ///
    /// - seealso: `queryItems`
    var queryParameters: [String: String] = [:]
    
    /// Returns `queryItems` property of `URLComponents` instance.
    ///
    /// - seealso: `queryParameters`
    var queryItems: [URLQueryItem]?
    
}

@objcMembers
@objc open class SPNavigator: NSObject {
    
    public var navigator : NavigatorType?
    
    @objc public static let sharedInstance = SPNavigator()
   
    private override init() {
        
        let navigator = Navigator()
        self.navigator = navigator
        
    }
    
    // MARK: Registering URLs
    
    /// Registers a view controller factory to the URL pattern.
    
    @objc open func sp_register(pattern: URLPattern, factory:@escaping  (_ convertible: SPURLConvertible, _ values: [String: Any], _ context: Any?) -> UIViewController?) {
        
        self.navigator?.register(pattern, { (url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? in
            let convertible = SPURLConvertible()
            convertible.urlValue = url.urlValue
            convertible.queryItems = url.queryItems
            convertible.queryParameters = url.queryParameters
            
            return factory(convertible, values, context);
        })
    }
    
    @objc open func sp_viewController(for url: URLPattern, context: Any? = nil) -> UIViewController? {
        return self.navigator?.viewController(for: url, context: context)
    }
    
    @objc open func sp_handler(for url: URLPattern, context: Any? = nil) -> URLOpenHandler? {
        return self.navigator?.handler(for: url, context: context)
    }
    
    @discardableResult
    @objc open func sp_open(_ url: URLPattern, context: Any? = nil) -> Bool {
        return self.navigator?.open(url, context: context) ?? false
    }
    
    @discardableResult
    @objc open func sp_push(pattern: URLPattern,context: Any? = nil, animated: Bool = true) -> UIViewController? {
        
        self.navigator?.push(pattern, context: context, from: UINavigationControllerType.self as? UINavigationControllerType, animated: animated)
    }
    
    @discardableResult
    @objc public func sp_present(_ url: URLPattern, context: Any? = nil, wrap: UINavigationController.Type? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        
        self.navigator?.present(url, context: context, wrap: wrap, from: UIViewControllerType.self as? UIViewControllerType, animated: animated, completion: completion)
    }
    
}

