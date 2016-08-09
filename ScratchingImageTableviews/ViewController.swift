//
//  ViewController.swift
//  ScratchingImageTableviews
//
//  Created by JAVIER CALATRAVA LLAVERIA on 07/08/16.
//  Copyright © 2016 JAVIER CALATRAVA LLAVERIA. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var apiClient: CUFixerApiClient!
    var landscapes:[Landscape]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self._setup()
        
        apiClient.fetchLandscapes { [unowned self] result   in

            switch result {
            case .Success(let landscapes):
                dispatch_async(dispatch_get_main_queue()) {
                    self.landscapes = landscapes
                    self._refresh()
                }
                break
            default:
                break
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*
 http://celeri.es/scratching_image_tableviews/IMG_2156.JPG
     http://celeri.es/scratching_image_tableviews/landscapes
 */
    
    // MARK : UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _landscapes = landscapes{
            return _landscapes.count
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReusableCellId", forIndexPath: indexPath)
        
        if let cell = cell as? ImageTableViewCell,
        let  _landscape:Landscape = self.landscapes![indexPath.row],
           let _url = NSURL(string: _landscape.url!),
            let _data = NSData(contentsOfURL: _url){
        
        
            cell.imvLandscape.image = UIImage(data: _data)
        }
        
        return cell
    }
    

    
    // MAR : UITableViewDelegate
    
    
    // MARK : Private / Internal
    func _setup(){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 320
        
        apiClient = CUFixerApiClient.sharedApiClient
        apiClient.loggingEnabled = true
    }
    
    func _refresh(){
        self.tableView.reloadData()
    }
}

