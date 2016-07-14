//
//  book.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation

class Book : Hashable, Comparable{
    
    // MARK: - Properties
    var title : String
    let author : [String]
    var tagArray : [Tag]
    let imageURL : NSURL
    let pdfURL : NSURL
    var isFavorite : Bool = false
    
    var tags: [Tag]{
        get{
            return tagArray
        }
    }
    
    var authors : String{
        get {
            return author.joinWithSeparator(", ")
        }
    }
    
    // TODO: Quitar si no funciona
    var hashValue: Int{
        
        get {
            return title.hashValue
        }
        
    }
    
    // MARK: - Initializers
    init(title: String, author: [String], tags: [Tag], imageURL: NSURL, pdfURL: NSURL, isFavorite: Bool){
        
        self.title = title
        self.author = author
        self.tagArray = tags
        self.imageURL = imageURL
        self.pdfURL = pdfURL
        self.isFavorite = isFavorite
    }
    
    convenience init(book c: Book){
        
        self.init(title: c.title, author: c.author, tags: c.tags, imageURL: c.imageURL, pdfURL: c.pdfURL, isFavorite: c.isFavorite)
    }
    
    // MARK: - Proxies
    
    var proxyForSorting : String{
        get {
            return "A\(title)"
        }
    }
    
}

// MARK: - Equatable & Comparable

func == (lhs: Book, rhs: Book) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func <(lhs: Book, rhs: Book) -> Bool {
    return (lhs.proxyForSorting < rhs.proxyForSorting)
}

// MARK: - Extensions

extension Book : CustomStringConvertible {
    
    var description: String {
        get{
            return "<\(self.dynamicType): \(title)>"
        }
    }
}