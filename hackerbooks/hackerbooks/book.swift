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
    var isFavorite : Bool
    
    
    // MARK: - Initializers
    init(title: String, author: [String], tags: [Tag], imageURL: NSURL, pdfURL: NSURL, isFavorite: Bool){
        
        self.title = title
        self.author = author
        self.tagArray = tags
        self.imageURL = imageURL
        self.pdfURL = pdfURL
        self.isFavorite = isFavorite
    }
    
}
