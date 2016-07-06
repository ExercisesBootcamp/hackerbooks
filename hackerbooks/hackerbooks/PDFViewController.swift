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
        let url = model.pdfURL
        let data = NSData(contentsOfURL: url)
        pdfBrowser.loadData(data!, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: url)
    }
    
    // MARK: - View lif cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        syncModelWithView()
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
