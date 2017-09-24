//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, FiltersViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var switchStates = [Int:[Int:Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 115
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let uiSearchBar = UISearchBar()
        uiSearchBar.placeholder = "Search Yelp!!!"
        uiSearchBar.delegate = self
        navigationItem.titleView = uiSearchBar
        
        doSearch(searchTerm: "")
    }
    
    @objc private func doSearch(searchTerm: String) {
        Business.searchWithTerm(term: searchTerm, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                self.businesses = businesses
            }
            self.tableView.reloadData()
        })
    }
    
    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject], switchStates: [Int:[Int:Bool]]) {
        
        self.switchStates = switchStates
        
        let searchText = (navigationItem.titleView as? UISearchBar)?.text ?? ""
        
        let categories = filters["categories"] as? [String]
        let sortMode = filters["sort"] as? YelpSortMode
        let deals = filters["deals"] as? Bool
        let distance = filters["distance"] as? Int
        
        Business.searchWithTerm(term: searchText, sort: sortMode, categories: categories, deals: deals, radius: distance) {
            (businesses: [Business]!, error: Error!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationViewController = segue.destination as! UINavigationController
        let vc = navigationViewController.topViewController as! FiltersViewController
        vc.delegate = self
        vc.switchStates = self.switchStates
     }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        let business = businesses[indexPath.row]
        cell.business = business
        return cell
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)//, selector: #selector(doSearch(searchTerm:)), object: nil)
        self.perform(#selector(doSearch(searchTerm:)), with: searchText, afterDelay: 0.4)
        // doSearch(searchTerm: searchText)
    }
}

