//
//  LibraryTableViewController.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 6/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

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
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        let selTag = model?.tagAtIndex(indexPath.section)
        let selBook = model?.bookAtIndex(indexPath.row, tag: selTag!)
        
        // Cell
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // Sync book into cell
        
        let url = selBook?.imageURL
        let data = NSData(contentsOfURL: url!)
        
        cell?.imageView?.image = UIImage(data: data!)
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
        
        // Warn delegae
        delegate?.libraryTableViewController(self, didSelectBook: selBook!)
        
        
    }

}

protocol LibraryTableViewControllerDelegate {
    func libraryTableViewController(vc: LibraryTableViewController, didSelectBook book: Book)
}
