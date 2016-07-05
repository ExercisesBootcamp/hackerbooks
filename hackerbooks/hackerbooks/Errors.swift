//
//  Errors.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 5/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import Foundation

enum JSONProcessingError: ErrorType {
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
}