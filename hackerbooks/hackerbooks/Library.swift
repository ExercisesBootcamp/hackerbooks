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
        books = orderBooks(books)!
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
    
    
    // MARK: - Loading JSON
    func decodeJSON() ->[Book]?{
        
        var result : [Book]? = nil
        // Obtener la url del fichero
        // Leemos el fichero JSON a un NSDATA (esto puede salir mal)
        // Lo parseamos
        do{
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let writePath = documents.stringByAppendingString("/books_readable.json")
            
            let firstLaunch = !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
            let fileExist = NSFileManager.defaultManager().fileExistsAtPath(writePath)
            if firstLaunch {
                if let url = NSURL(string: "https://t.co/K9ziV0z3SJ"),
                    data = NSData(contentsOfURL: url),
                    booksArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray{
                    saveData(data)
                    // Todo es fabuloso!!!
                    result = decode(books: booksArray)
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                }
            }
            else if fileExist {
                result = try loadJSONLocally()
            }else{
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstLaunch")
            }
        }catch{
            // Error al parsear el JSON
            fatalError()
        }
        
        return result;
        
    }
    
    func saveData(data: NSData){
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("books_readable.json")
        data.writeToURL(writePath, atomically: false)
    }
    
    func loadJSONLocally() throws -> [Book]?{
        do{
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let writePath = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("books_readable.json")
            if let data = NSData(contentsOfURL: writePath),
                booksArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray{
                // Todo es fabuloso!!!
                return decode(books: booksArray)
            }
        }catch{
            fatalError()
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