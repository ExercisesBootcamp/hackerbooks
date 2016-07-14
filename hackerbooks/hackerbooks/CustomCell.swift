//
//  CustomCell.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 14/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    static let cellId: String = "CustomCell"
    static let cellHeight: CGFloat = 50
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
}
