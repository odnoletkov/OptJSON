//
//  OptJSON.swift
//  OptJSON
//
//  Created by max on 26.06.14.
//
//

import Foundation

public protocol JSONValue {
    subscript(key key: String) -> JSONValue? { get }
    subscript(index index: Int) -> JSONValue? { get }
}

extension NSNull : JSONValue {
    public subscript(key key: String) -> JSONValue? { return nil }
    public subscript(index index: Int) -> JSONValue? { return nil }
}

extension NSNumber : JSONValue {
    public subscript(key key: String) -> JSONValue? { return nil }
    public subscript(index index: Int) -> JSONValue? { return nil }
}

extension NSString : JSONValue {
    public subscript(key key: String) -> JSONValue? { return nil }
    public subscript(index index: Int) -> JSONValue? { return nil }
}

extension NSArray : JSONValue {
    public subscript(key key: String) -> JSONValue? { return nil }
    public subscript(index index: Int) -> JSONValue? { return index < count && index >= 0 ? JSON(self[index]) : nil }
}

extension NSDictionary : JSONValue {
    public subscript(key key: String) -> JSONValue? { return JSON(self[key]) }
    public subscript(index index: Int) -> JSONValue? { return nil }
}

public func JSON(object: AnyObject?) -> JSONValue? {
    if let some: AnyObject = object {
        switch some {
        case let null as NSNull:        return null
        case let number as NSNumber:    return number
        case let string as NSString:    return string
        case let array as NSArray:      return array
        case let dict as NSDictionary:  return dict
        default:                        return nil
        }
    } else {
        return nil
    }
}