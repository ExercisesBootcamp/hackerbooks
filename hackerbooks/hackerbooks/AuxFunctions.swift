//
//  AuxFunctions.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 12/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Functions used in different places

func getURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func localFile(filename: String) -> String {
    
    let fileURL = getURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}


func saveImage (image: UIImage, path: String ) -> Bool{
    
    let pngImageData = UIImagePNGRepresentation(image)
    let result = pngImageData!.writeToFile(path, atomically: true)
    
    return result
    
}

func loadLocalImage(path: String) -> UIImage? {
    
    let image = UIImage(contentsOfFile: path)
    
    if image == nil {
        
        print("No saved image")
    }else{
        print("Loading saved image...")
    }
    
    return image
    
}

func savePDF (data: NSData, path: String ) -> Bool{
    
    let result = data.writeToFile(path, atomically: true)
    
    return result
    
}

func loadLocalPDF(path: String) -> NSData? {
    
    let pdf = NSData(contentsOfFile:path)
    
    if pdf == nil {
        
        print("There´s no pdf")
    }else{
        print("Loading pdf from local storage")
    }
    
    return pdf
    
}