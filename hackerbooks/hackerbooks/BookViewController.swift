//
//  BookViewController.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 6/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var pdfImage: UIImageView!
    @IBOutlet weak var authorsField: UITextField!
    @IBOutlet var tagsField: UITextField!
    
    let model : Book
    
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
    @IBAction func markFavorite(sender: AnyObject) {
    
    }
    
    @IBAction func displayPDF(sender: AnyObject) {
    
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
