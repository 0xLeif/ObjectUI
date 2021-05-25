//
//  Object.swift
//  ObjectUI
//
//  Created by Leif on 5/24/21.
//

import Foundation
import SwiftFu
import SwiftUI
import Combine

@dynamicMemberLookup
public class Object: FuableClass, ObservableObject {
    public enum ObjectVariable: String, Hashable {
        case value
        case child
        case array
        case json
    }
    /// Variables of the object
    @Published public var variables: [AnyHashable: Any] = [:]
    /// @dynamicMemberLookup
    public subscript(dynamicMember member: String) -> Object {
        variable(named: member)
    }
    
    // MARK: public init
    
    public init() { }
    public convenience init(_ closure: (Object) -> Void) {
        self.init()
        
        closure(self)
    }
    public init(_ value: Any? = nil, _ closure: ((Object) -> Void)? = nil) {
        defer {
            if let closure = closure {
                configure(closure)
            }
        }
        
        guard let value = value else {
            return
        }
        let unwrappedValue = unwrap(value)
        if let _ = unwrappedValue as? NSNull {
            return
        }
        if let object = unwrappedValue as? Object {
            consume(object)
        } else if let array = unwrappedValue as? [Any] {
            consume(Object(array: array))
        } else if let dictionary = unwrappedValue as? [AnyHashable: Any] {
            consume(Object(dictionary: dictionary))
        } else if let data = unwrappedValue as? Data {
            consume(Object(data: data))
        } else {
            consume(Object().set(value: unwrappedValue))
        }
    }
    
    // MARK: private init
    
    private init(array: [Any]) {
        set(variable: ObjectVariable.array, value: array.map {
            Object($0)
        })
    }
    private init(dictionary: [AnyHashable: Any]) {
        variables = dictionary
    }
    private init(data: Data) {
        defer {
            set(variable: ObjectVariable.json, value: String(data: data, encoding: .utf8))
            set(value: data)
        }
        if let json = try? JSONSerialization.jsonObject(with: data,
                                                        options: .allowFragments) as? [Any] {
            set(variable: ObjectVariable.array, value: json)
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data,
                                                           options: .allowFragments) as? [AnyHashable: Any] else {
            return
        }
        consume(Object(json))
    }
}

// MARK: public variables


public extension Object {
    var array: [Object] {
        if let array = variables[ObjectVariable.array] as? [Data] {
            return array.map { Object(data: $0) }
        } else if let array = variables[ObjectVariable.array] as? [Any] {
            return array.map { value in
                guard let json = value as? [AnyHashable: Any] else {
                    return Object(value)
                }
                return Object(dictionary: json)
            }
        }
        return []
    }
    
    var child: Object {
        (variables[ObjectVariable.child] as? Object) ?? Object()
    }
    
    var value: Any {
        variables[ObjectVariable.value] ?? Object()
    }
}

// MARK: public functions


public extension Object {
    /// Retrieve a Value from the current object
    @discardableResult
    func variable(named: AnyHashable) -> Object {
        guard let value = variables[named] else {
            return Object()
        }
        if let array = value as? [Any] {
            return Object(array: array)
        }
        guard let object = value as? Object else {
            return Object(unwrap(value))
        }
        return object
    }
    /// Set a named Value to the current object
    @discardableResult
    func set(variable named: AnyHashable = ObjectVariable.value, value: Any?) -> Self {
        guard let value = value,
              (unwrap(value) as? NSNull) == nil else {
            return self
        }
        
        variables[named] = value
        
        return self
    }
    /// Set a named Value to the current object
    @discardableResult
    func set<T>(variable named: T, value: Any?) -> Self where T: RawRepresentable, T.RawValue == String {
        guard let value = value,
              (unwrap(value) as? NSNull) == nil else {
            return self
        }
        
        variables[named.rawValue] = value
        
        return self
    }
    /// Modify a Value with a name to the current object
    @discardableResult
    func modify<T>(variable named: AnyHashable = ObjectVariable.value, modifier: (T?) -> T?) -> Self {
        guard let variable = variables[named],
              let value = variable as? T else {
            variables[named] = modifier(nil)
            
            return self
        }
        variables[named] = modifier(value)
        
        return self
    }
    /// Update a Value with a name to the current object
    @discardableResult
    func update<T>(variable named: AnyHashable = ObjectVariable.value, modifier: (T) -> T) -> Self {
        guard let variable = variables[named],
              let value = variable as? T else {
            return self
        }
        variables[named] = modifier(value)
        
        return self
    }
    /// Set the ChildObject with a name of `_object` to the current object
    @discardableResult
    func set(childObject object: Object) -> Self {
        variables[ObjectVariable.child] = object
        
        return self
    }
    /// Set the Array with a name of `_array` to the current object
    @discardableResult
    func set(array: [Any]) -> Self {
        variables[ObjectVariable.array] = array
        
        return self
    }
    
    @discardableResult
    func configure(_ closure: (Object) -> Void) -> Object {
        closure(self)
        
        return self
    }
    
    @discardableResult
    func consume(_ object: Object) -> Object {
        object.variables.forEach { (key, value) in
            self.set(variable: key, value: value)
        }
        
        return self
    }
    
    func value<T>(as type: T.Type? = nil) -> T? {
        value as? T
    }
    
    func value<T>(decodedAs type: T.Type) -> T? where T: Decodable {
        guard let data = value(as: Data.self) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

private extension Object {
    /// Unwraps the <Optional> Any type
    func unwrap(_ value: Any) -> Any {
        let mValue = Mirror(reflecting: value)
        let isValueOptional = mValue.displayStyle != .optional
        let isValueEmpty = mValue.children.isEmpty
        if isValueOptional { return value }
        if isValueEmpty { return NSNull() }
        guard let (_, unwrappedValue) = mValue.children.first else { return NSNull() }
        return unwrappedValue
    }
}
