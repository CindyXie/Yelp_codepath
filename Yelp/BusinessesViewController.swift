//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var businesses: [Business] = [] {
        didSet {
            updateFiltedBusinesses()
        }
    }
    var filteredBusinesses: [Business] = []
    let searchBar = UISearchBar()
    var isDataLoading = false

    let pageSize = 20
    var currentPage = -1
    
    @IBOutlet weak var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.estimatedRowHeight = 120
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        loadNextPage()


/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/

            }
    
    func loadNextPage() {
        if isDataLoading {
            return
        }
        
        currentPage += 1
        isDataLoading = true
        Business.searchWithTerm("Thai", offset: currentPage * pageSize, limit: pageSize) { businesses, error in
            self.businesses += businesses
            self.tabelView.reloadData()
            self.isDataLoading = false
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updateFiltedBusinesses()
        tabelView.reloadData()
    }

    
    func updateFiltedBusinesses() {
        let searchText = searchBar.text ?? ""
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredBusinesses = businesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredBusinesses = businesses.filter({business in
                // If dataItem matches the searchText, return true to include it
                if let name = business.name {
                    return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                }
                return false
            })
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredBusinesses.count
        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tabelView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row];
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
            loadNextPage()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view cont  roller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
