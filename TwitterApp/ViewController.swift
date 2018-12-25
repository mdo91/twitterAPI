//
//  ViewController.swift
//  TwitterApp
//
//  Created by ASP on 12/15/18.
//  Copyright © 2018 ASP. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import OhhAuth

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, SearchForSpecificData {
    
    
    
    let url = "https://api.twitter.com/1.1/tweets/search/30day/mdo.json"
    var twittes = [TwitterData]()
   // var filterTwittes = [TwitterData]()
    
    @IBOutlet weak var TableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Twittes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "newCellId")
        print("--------------------------")
      //  let header =  getAuthSig(url: url)
    //    print("using the function: \(headers)")
        print("-------------            ")
       // print("\(headers["authorization"]!)")
       
     //   getResponse()
        configRowBox()
       
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getTwitterData(url: String,headers: [String:String] ,Params: [String: String]){


        Alamofire.request(url, method: .post, parameters: Params,encoding:JSONEncoding.default,headers: headers).responseJSON { (response) in
            if (response.result.isSuccess){
                print("Success! got the twitter data")
                let twitterJSON: JSON = JSON(response.result.value!)
              
                print("\(twitterJSON)")
                self.updateTwittes(json: twitterJSON)
            }else{
                print("Error \(String(describing: response.result.error)) ")
            }
        }
    }
    // UITable View protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFiltering()){
            return twittes.count
        }else{ return 0}
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isFiltering() && (twittes.count > 0)){
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCellId", for: indexPath) as! TableViewCell
              cell.name.text = twittes[indexPath.row].Name
             cell.usrname.text = "@"+twittes[indexPath.row].userName
            cell.longText.text = twittes[indexPath.row].text
            // cell.nn.text = twittes[indexPath.row].text
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newCellId", for: indexPath) as! TableViewCell
             cell.name.text = twittes[indexPath.row].Name
             cell.usrname.text = "@"+twittes[indexPath.row].userName
             cell.longText.text = twittes[indexPath.row].text
            // cell.longText.text = twittes[indexPath.row].text
            return cell
        }
    }
    
    func updateTwittes(json:JSON){
        if let jsonArray = json.dictionary{
            print("parsing!")
            if let array = jsonArray["results"]{
               // print("------------------------------------*statues: \(array)")
                for i in 0...array.count-1{
                    var twite = TwitterData()
                  twite.text = array[i]["text"].stringValue
                  twite.Name = array[i]["user"]["name"].stringValue
                  twite.userName = array[i]["user"]["screen_name"].stringValue
                  twittes.append(twite)
                //    print("\(array[i]["text"].stringValue)")
                }
                TableView.reloadData()
            }else{
                print("not available please check the node name again")
            }
        }
    }
    func configRowBox (){
        TableView.rowHeight = UITableViewAutomaticDimension
        TableView.estimatedRowHeight = 175.0
    }
    
    // MARK: - private instance Methods
    func SearchBrIsEmpty()->Bool{
    return searchController.searchBar.text?.isEmpty ?? true
    }
    func SearchInSocialMedia(_ searchText: String) {
        if searchController.isActive{
            twittes.removeAll()
            let params = ["query":"\(searchText) lang:en","maxResults":"10"]
            
            let headers = ["authorization":"bearer AAAAAAAAAAAAAAAAAAAAAHaD9AAAAAAAQXHQAq8sSdKSdzD59%2Fcm2Eg0jnU%3DN82wIF9GgupK66Z6B42d13GPDFJeJEF881bxd5Gt09eqjWr9rW","content-type":"application/json"]
            getTwitterData(url: url,headers: headers ,Params: params)
        }
    }
   
    func isFiltering()->Bool{
        return !SearchBrIsEmpty() && searchController.isActive
    }




}
extension ViewController:  UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //TODO
        SearchInSocialMedia(searchController.searchBar.text!)
    }
    
    
    
}
protocol SearchForSpecificData {
    func SearchInSocialMedia(_ searchText:String)
}

