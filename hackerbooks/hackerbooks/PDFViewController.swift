//
//  PDFViewController.swift
//  hackerbooks
//
//  Created by Juan Arillo Ruiz on 6/7/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController, UIWebViewDelegate {

    // MARK: - Properties
    var model : Book
    @IBOutlet weak var pdfBrowser: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // MARK: - Initializer
    init(model: Book){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Syncing
    func syncModelWithView(){
        
        // Indicating delegate
        pdfBrowser.delegate = self
        
        // Loading activity view
        activityView.startAnimating()
        
        // Getting PDF
        let pdfURL = localFile(model.authors)
        let pdf = loadLocalPDF(pdfURL)
        
        if pdf == nil{
            let url = model.pdfURL
            let data = NSData(contentsOfURL: url)
            if data == nil {
                pdfBrowser.loadHTMLString("NO DATA LOADED", baseURL: NSURL())
            } else {
                savePDF(data!, path: pdfURL)
                pdfBrowser.loadData(data!, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: url)
            
                print("pdf saved")
            }
        } else {
            pdfBrowser.loadData(pdf!, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL())
            
            print("pdf loaded from local")
        }
        
        
    }
    
    // MARK: - View lif cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Notification subscription
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookDidChange), name: BookDidChangeNotification, object: nil)
        
        syncModelWithView()
    }
    
    func bookDidChange(notification: NSNotification) {
        
        // Bring out userInfo
        let info = notification.userInfo
        
        // Bring out book
        let book = info![BookKey] as? Book
        
        // Update model
        model = book!
        
        // Sync view
        syncModelWithView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from notification
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    
    // MARK: - Memory
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // Stopping Activity View
        activityView.stopAnimating()
        
        // Hidding Activitiy View
        activityView.hidden = true
    }
    

}
