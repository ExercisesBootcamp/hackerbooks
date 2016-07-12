//
//  BookViewController.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 6/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

let isNotFavorite = "Remove from favorite"
let isFav = "Add to favorite"
let favoriteKey = "Key"

class BookViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var pdfImage: UIImageView!
    @IBOutlet weak var authorsField: UITextField!
    @IBOutlet var tagsField: UITextField!
    
    var model : Book
    
    // MARK: - Initialization
    
    init(model: Book){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    func syncModelWithView(){
        
        // PDF Image
        let url = model.imageURL
        let data = NSData(contentsOfURL: url)
        pdfImage.image = UIImage(data: data!)
        
        // Book Title
        title = model.title
        
        // Book Authors
        authorsField.text = model.authors
        
        // Tags
        let tagStringsArray = model.tags
        var tags: String = ""
        for tag in tagStringsArray{
            tags += "| " + tag.name + " |"
            tagsField.text = tags
        }
        
    }
    
    
    // Because it worth it. To prevent nil
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    // MARK: - Favourites functions
    
    
    @IBAction func markFav(sender: AnyObject) {
        
        if model.isFavorite == true {
            model.isFavorite = false
            
            let nc = NSNotificationCenter.defaultCenter()
            let notif = NSNotification(name: isNotFavorite, object: self, userInfo: [favoriteKey:model])
            nc.postNotification(notif)
            
        }else{
            model.isFavorite = true
            
            let nc = NSNotificationCenter.defaultCenter()
            let notif = NSNotification(name: isFav, object: self, userInfo: [favoriteKey:model])
            nc.postNotification(notif)
        }
        
        print(model.isFavorite)
    }
    
    @IBAction func displayPDF(sender: AnyObject) {
        
        // Create a PDF VC
        let pdfVC = PDFViewController(model: model)
        
        // Make a push
        navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        syncModelWithView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

}

extension BookViewController : LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc: LibraryTableViewController, didSelectBook book: Book) {
        
        // Updating model
        model = book
        
        // Sync
        syncModelWithView()
        
    }
    
}
