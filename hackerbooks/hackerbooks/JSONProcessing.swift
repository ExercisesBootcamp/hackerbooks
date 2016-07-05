//
//  JSONProcessing.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Keys

enum JSONKeys: String{
    case authors = "authors"
    case imageURL = "image_url"
    case pdfURL = "pdf_url"
    case tags = "tags"
    case title = "title"
}

// MARK: - Aliases

typealias JSONObject = AnyObject
typealias JSONDictionary = [String:JSONObject]
typealias JSONArray = [JSONDictionary]


// MARK: - Decoding

func decode(book json: JSONDictionary) throws -> Book {
    
    guard let authString = json[JSONKeys.authors.rawValue] as? String else {
        throw JSONProcessingError.wrongJSONFormat
    }
    
    guard let imgURLString = json[JSONKeys.imageURL.rawValue] as? String, imageURL = NSURL(string: imgURLString) else {
        throw JSONProcessingError.wrongURLFormatForJSONResource
    }
    
    guard let pdfURLString = json[JSONKeys.pdfURL.rawValue] as? String, pdfURL = NSURL(string: pdfURLString) else {
        throw JSONProcessingError.wrongURLFormatForJSONResource
    }
    
    guard let tagStrings = json[JSONKeys.tags.rawValue] as? String else {
        throw JSONProcessingError.wrongJSONFormat
    }
    
    guard let title = json[JSONKeys.title.rawValue] as? String else {
        throw JSONProcessingError.wrongJSONFormat
    }
    
    // Preparing authors
    
    let authors = authString.componentsSeparatedByString(",")
    var trimAuthors = [String]()
    for author in authors {
        trimAuthors.append(author.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    
    // Preparing tags
    
    let tagStringsArray = tagStrings.componentsSeparatedByString(",")
    var tags = [Tag]()
    for tag in tagStringsArray{
        let getTag = Tag(name: tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        tags.append(getTag)
    }
    
    return Book(title: title, author: trimAuthors, tags: tags, imageURL: imageURL, pdfURL: pdfURL, isFavorite: false)
}

func decode(books json: JSONArray) -> [Book]{
    
    var results = [Book]()
    
    do{
        for dict in json{
            let s = try decode(book: dict)
            
            results.append(s)
        }
    } catch {
        fatalError("Something is going bad")
    }
    
    return results
}















