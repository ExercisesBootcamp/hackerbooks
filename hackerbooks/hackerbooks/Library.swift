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
    
    private var books : [Book]
    private var tagArray : [Tag]?
    private var tags : [Tag]? {
        get{
            if let tArray = tagArray{
                
                // Sorting tags and adding Favorites.
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
        tags = tagArray
        subscribeNotificationModel()
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
    
    func tagAtIndex(raw: Int) -> Tag?{
        if let tags = tags {
            return tags[raw]
        }
        return nil
    }
    
    // MARK: - Notifications
    
    func subscribeNotificationModel(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Library.favoriteChanged(_:)), name: "FavoriteChanged", object: nil)
    }
    
    func unsubscribeNotificationModel(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Adding or removing book from favorite tag
    
    func favoriteChanged(notification: NSNotification){
        let book = notification.object as? Book
        
        if let fav = book?.isFavorite{
            if fav{
                tagArray?.insert(Tag(name: "Favorite"), atIndex: 0)
            } else {
                tagArray?.removeAtIndex(0)
            }
        }
    }
    
    deinit {
        unsubscribeNotificationModel()
    }
    
}