//
//  book.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation

class Book {
    
    // MARK: - Properties
    let title : String
    let author : [String]
    private var tagArray : [Tag]
    let imageURL : NSURL
    let pdfURL : NSURL
    var isFavorite : Bool {
        didSet{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){
                () -> Void in
                if self.isFavorite{
                    self.tagArray.insert(Tag(name: "Favorite"), atIndex: 0)
                } else {
                    self.tagArray.removeAtIndex(0)
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("FavoriteChanged", object: self)
            }
        }
    }
    
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
    
}

// MARK: - Extensions

extension Book : CustomStringConvertible {
    
    var description: String {
        get{
            return "<\(self.dynamicType): \(title)>"
        }
    }
}