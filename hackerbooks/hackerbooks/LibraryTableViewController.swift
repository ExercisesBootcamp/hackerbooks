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
    var segControl : UISegmentedControl
    
    
    var tagVisible: Bool {
        
        get {
            return segControl.selectedSegmentIndex == 0
        }
        
    }
    
    
    // MARK: - Initialization
    init(model: Library){
        self.model = model
        self.segControl = UISegmentedControl(items: ["Tags", "Title"])
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "HackerBooks"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Custom Cell
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: CustomCell.cellId)
        
        // Using segmented control
        self.segControl.selectedSegmentIndex = 0
        self.segControl.addTarget(self, action: #selector(selectedSegmentChanged), forControlEvents: .ValueChanged)
        
        self.navigationItem.titleView = self.segControl
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Number of Tags
        
        if tagVisible{
            if let countTags = model?.tagsCount{
                return countTags
            }
        } else {
            return 1
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of books in tag
        
        if tagVisible{
            if let tag = model?.tagAtIndex(section){
                return model!.booksInTag(tag.name)
            }
        } else {
            return (model?.booksCount)!
        }
        
        return 0
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cellId = "LibraryCell"
        
        
        let selTag = model?.tagAtIndex(indexPath.section)
        let selBook : Book
        
        if tagVisible {
            selBook = (model?.bookAtIndex(indexPath.row, tag: selTag!))!
        } else {
            selBook = (model?.bookIndex(indexPath.row))!
        }
        
        // Cell
        let cell : CustomCell? = tableView.dequeueReusableCellWithIdentifier(CustomCell.cellId, forIndexPath: indexPath) as? CustomCell
        //var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
//        if cell == nil{
//            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
//        }
        
        // Sync book into cell
        
        let imgUrl = localFile((selBook.title))
        let img = loadLocalImage(imgUrl)
        
        if img == nil {
            let url = selBook.imageURL
            let data = NSData(contentsOfURL: url)
            let img = UIImage(data: data!)
            saveImage(img!, path: imgUrl)
            cell?.bookImage.image = img
            
            print("Saved")
        } else {
            cell?.imageView?.image = img
            
            print ("Local loading")
        }
        
        
        cell?.bookName.text = selBook.title
        cell?.bookAuthors.text = selBook.authors
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tagVisible{
            if let selTag = model?.tagAtIndex(section){
                return selTag.name
            }
        } else {
            return nil
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CustomCell.cellHeight
    }
    
    
    // MARK: - TableView delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selTag = model?.tagAtIndex(indexPath.section)
        let selBook : Book
        
        if tagVisible{
            selBook = (model?.bookAtIndex(indexPath.row, tag: selTag!))!
        } else {
            selBook = (model?.bookIndex(indexPath.row))!
        }
        
        // Warn delegate
        delegate?.libraryTableViewController(self, didSelectBook: selBook)
        
        // Same warning through notification
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey: selBook])
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
    
    // MARK: - Segmented Control Utils
    func selectedSegmentChanged() {
        
        //Scroll the TableView to the first element
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        self.tableView.reloadData()
    }
    
    
}

protocol LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc: LibraryTableViewController, didSelectBook book: Book)
}
