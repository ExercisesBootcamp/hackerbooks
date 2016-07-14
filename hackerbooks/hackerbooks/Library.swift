//
//  Library.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation

class Library : NSObject {
    
    // MARK: - Properties
    var tagArray : [Tag]?
    var books : [Book]
    
    var tags : [Tag]? {
        get{
            if let tArray = tagArray{
                
                // Sorting tags and adding Favorite tag.
                var orderedTags = tArray.sort {
                    $0.0.name.lowercaseString < $0.1.name.lowercaseString
                }
                let favTag = Tag(name : "Favorite")
                
                if orderedTags.contains(favTag){
                    // Make favorite tag the first one
                    if let position = orderedTags.indexOf(favTag){
                        orderedTags.removeAtIndex(position)
                        orderedTags.insert(favTag, atIndex: 0)
                    }
                }
                
                return orderedTags
            }
            
            return nil
        }
        
        set {
            if let newTags = newValue {
                tagArray = newTags
            }
        }
    }
    
    
    
    // MARK: - Initializers
    
    init(booksArray: [Book], tagArray: [Tag]){
        books = booksArray
        super.init()
        books = orderBooks(books)! // Order by Title, using aux function
        tags = tagArray
    }
    
    // MARK: - Counters
    
    var booksCount: Int{
        get{
            return books.count
        }
    }
    
    var tagsCount: Int{
        get{
            if let tags = tags{
                return tags.count
            }
            return 0
        }
    }
    
    func booksInTag (tag: String) -> Int {
        if let books = booksForTag(tag){
            return books.count
        }
        return 0
    }
    
    func booksForTag(tag: String) -> [Book]?{
        var bookTag = [Book]()
        for book in books{
            if book.tags.contains(Tag(name: tag)){
                bookTag.append(book)
            }
        }
        
        bookTag = bookTag.sort {
            $0.0.title.lowercaseString < $0.1.title.lowercaseString
        }
        
        return bookTag
    }
    
    func bookAtIndex(index: Int, tag: Tag) -> Book?{
        if let tagBooks = self.booksForTag(tag.name){
            return tagBooks[index]
        }
        return nil
    }
    
    func bookIndex(index: Int) -> Book?{
        
        return books[index]
    }
    
    func tagAtIndex(raw: Int) -> Tag?{
        if let tags = tags {
            return tags[raw]
        }
        return nil
    }

    
    // MARK: - Utils
    func orderBooks(books: [Book]) -> [Book]?{
        let orderedBooks = books.sort{
            $0.0.title.lowercaseString < $0.1.title.lowercaseString
        }
        
        return orderedBooks
    }
    
}