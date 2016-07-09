//
//  Tag.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation

class Tag : Hashable, Comparable {
    
    // MARK: - Properties
    var _name: String? = nil
    var name : String {
        set {
            self._name = newValue
        }
        get {
            if let name = _name{
                return name.lowercaseString.capitalizedString
            }
            
            return ""
        }
    }
    
    var hashValue: Int{
        
        get {
            return name.hashValue
        }
        
    }
    
    // MARK: - Initializers
    
    init(name: String){
        self.name = name
    }
    
    // MARK: - Proxies
    
    var proxyForSorting : String{
        get {
            return "A\(name)"
        }
    }
}

// MARK: - Equatable & Comparable

func == (lhs: Tag, rhs: Tag) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func <(lhs: Tag, rhs: Tag) -> Bool {
    return (lhs.proxyForSorting < rhs.proxyForSorting)
}

// MARK: - Extensions

extension Tag : CustomStringConvertible {
    
    var description : String{
        get {
            return "<\(self.dynamicType): \(name)>"
        }
    }
}