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
    
    var total: Int?
    var businesses: [Business]!
    var switchStates = [Int:[Int:Bool]]()
    var isLoading = false
    
    var categories: [String]?
    var sortMode: YelpSortMode?
    var deals: Bool?
    var distance: Int?
    
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
        Business.searchWithTerm(term: searchTerm, completion: { (businesses: [Business]?, total: Int?, error: Error?) -> Void in
            if let businesses = businesses {
                self.businesses = businesses
            }
            self.total = total
            self.tableView.reloadData()
            print("total is \(total!)")
        })
    }
    
    private func loadPage(offset: Int?) {
        let searchText = (navigationItem.titleView as? UISearchBar)?.text ?? ""
    
        Business.loadPage(term: searchText, sort: self.sortMode, categories: self.categories, deals: self.deals, radius: self.distance, offset: offset) { (businesses: [Business]?, total: Int?, error: Error?) -> Void in
            
            if let businesses = businesses {
                self.businesses.append(contentsOf: businesses)
            }
            self.total = total
            self.tableView.reloadData()
            self.isLoading = false
        }
            
    }
    
    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject], switchStates: [Int:[Int:Bool]]) {
        
        self.switchStates = switchStates
        
        let searchText = (navigationItem.titleView as? UISearchBar)?.text ?? ""
        
        self.categories = filters["categories"] as? [String]
        self.sortMode = filters["sort"] as? YelpSortMode
        self.deals = filters["deals"] as? Bool
        self.distance = filters["distance"] as? Int
        
        Business.searchWithTerm(term: searchText, sort: self.sortMode, categories: self.categories, deals: self.deals, radius: self.distance) {
            (businesses: [Business]!, total: Int?, error: Error!) -> Void in
            self.businesses = businesses
            self.total = total
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
        let destination = segue.destination
        
        if (destination is UINavigationController) {
            let navigationViewController = destination as! UINavigationController
            let topViewControler = navigationViewController.topViewController
            if (topViewControler is MapViewController) {
                let vc = navigationViewController.topViewController as! MapViewController
                vc.businesses = self.businesses
            } else if (topViewControler is FiltersViewController) {
                let vc = navigationViewController.topViewController as! FiltersViewController
                vc.delegate = self
                vc.switchStates = self.switchStates
            }
        } else if (destination is BusinessDetailViewController) {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let business = businesses[indexPath.row]
            
            let businessDetailViewController = destination as! BusinessDetailViewController
            businessDetailViewController.business = business
        }
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
        
        if ((indexPath.row >= businesses.count - 1) && indexPath.row < total!  && !isLoading) {
            isLoading = true
            loadPage(offset: 20)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)//, selector: #selector(doSearch(searchTerm:)), object: nil)
        self.perform(#selector(doSearch(searchTerm:)), with: searchText, afterDelay: 0.4)
        // doSearch(searchTerm: searchText)
    }
}

