//
//  SearchManager.swift
//  DemoMapKitView
//
//  Created by xianbin lin on 2017/3/17.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class SearchMananer:NSObject {
    var resultSearchController:UISearchController? = nil
    var locationSearchTable:LocationSearchTable!
    weak var vcDelegate:ViewControllerDelegate?
    
    
    override init() {
        super.init()
          self.locationSearchTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = self
        resultSearchController?.searchBar.delegate = self
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "address"
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
    }
}

extension SearchMananer : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        vcDelegate?.searchMapItems(address: searchBarText, completer: {items in
            self.locationSearchTable.matchingItems = items
            self.locationSearchTable.tableView.reloadData()
        })
    }
}

extension SearchMananer:UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            vcDelegate?.enterNextState(state: StateCase.start.getSelf())
        }
    }
    
}




