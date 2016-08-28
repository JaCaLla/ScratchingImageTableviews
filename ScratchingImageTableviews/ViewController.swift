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
    
    let cache = NSCache()
    
    var imageProviders = Set<ImageProvider>()
    
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
        
        if let cell = cell as? ImageTableViewCell {
            cell.landscape = self.landscapes![indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        guard let cell = cell as? ImageTableViewCell else { return }
        
        let landscape:Landscape = landscapes![indexPath.row]
        
        guard cache.objectForKey(landscape.url) != nil  else {
            
            let imageProvider = ImageProvider( landscape: landscapes![indexPath.row],width: cell.imvLandscape.frame.size.width*2 ) {
                image in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    self.cache.setObject(image!, forKey: landscape.url)
                    
                    if(self._isVisible(indexPath, tableView: tableView)){
                        cell.updateImageViewWithImage(image)
                    }
                }
                
                return
            }
            imageProviders.insert(imageProvider)
            return
        }
        
        let image:UIImage = self.cache.objectForKey(landscape.url) as! UIImage
        cell.updateImageViewWithImage(image)
    }
    
    
    
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? ImageTableViewCell else { return }
        for provider in imageProviders.filter({ $0.landscape == cell.landscape }) {
            provider.cancel()
            imageProviders.remove(provider)
        }
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
    
    func _isVisible(indexpath:NSIndexPath, tableView:UITableView) ->Bool{
        if let _ =  tableView.indexPathsForVisibleRows!.filter({$0.row == indexpath.row}).first {
            return true
        }
        return false
    }
}

