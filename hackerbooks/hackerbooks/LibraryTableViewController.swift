//
//  LibraryTableViewController.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 6/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

let BookDidChangeNotification = "Selected book did change"
let BookKey = "key"

class LibraryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let model : Library?
    var delegate : LibraryTableViewControllerDelegate?

    // MARK: - Initialization
    init(model: Library){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(toFavorite), name: isFav, object: nil)
        center.addObserver(self, selector: #selector(outOfFavorite), name: isNotFavorite, object: nil)
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Number of Tags
        if let countTags = model?.tagsCount{
            return countTags
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of books in tag
        if let tag = model?.tagAtIndex(section){
            return model!.booksInTag(tag.name)
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "LibraryCell"
        

        let selTag = model?.tagAtIndex(indexPath.section)
        let selBook = model?.bookAtIndex(indexPath.row, tag: selTag!)
        
        // Cell
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // Sync book into cell
        
        let imgUrl = localFile((selBook?.title)!)
        let img = loadLocalImage(imgUrl)
        
        if img == nil {
            let url = selBook?.imageURL
            let data = NSData(contentsOfURL: url!)
            let img = UIImage(data: data!)
            saveImage(img!, path: imgUrl)
            cell?.imageView?.image = img
            
            print("Saved")
        } else {
            cell?.imageView?.image = img
            
            print ("Local loading")
        }
        
        
        
        
        cell?.textLabel?.text = selBook?.title
        cell?.detailTextLabel?.text = selBook?.authors
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let selTag = model?.tagAtIndex(section){
            return selTag.name
        }
        
        return nil
    }
    
    // MARK: - TableView delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selTag = model?.tagAtIndex(indexPath.section)
        let selBook = model?.bookAtIndex(indexPath.row, tag: selTag!)
        
        // Warn delegate
        delegate?.libraryTableViewController(self, didSelectBook: selBook!)
        
        // Same warning through notification
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey: selBook!])
        nc.postNotification(notif)
        
        
    }
    
    // MARK: - Notification Utils
    
    func toFavorite(notification: NSNotification){
        
        let info = notification.userInfo!
        let book = info[favoriteKey] as? Book
        
        if ((model?.tags?.contains(Tag(name: "Favorite"))) == nil){
            book?.tagArray.append(Tag(name:"Favorite"))
            
        }else{
            model?.tagArray?.append(Tag(name: "Favorite"))
            book?.tagArray.append(Tag(name:"Favorite"))
        }
        
        self.tableView.reloadData()
        
    }
    
    func outOfFavorite(notification: NSNotification){
        
        let info = notification.userInfo!
        let book = info[favoriteKey] as? Book
        
        if ((book?.tagArray.contains(Tag(name: "Favorite"))) != nil){
            book?.tagArray.removeLast()
            model?.tagArray?.removeLast()
        }
        
        
        self.tableView.reloadData()
    }
    

}

protocol LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc: LibraryTableViewController, didSelectBook book: Book)
}
