//
//  ViewController.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 2/05/21.
//

import UIKit

class ASBTransactionListVC: UIViewController {

  @IBOutlet weak var transactionTableView: UITableView!
  
  var viewModel: ASBTransactionListViewModel = ASBTransactionListViewModel()
  let searchController = UISearchController(searchResultsController: nil)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter by summary"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    let tableViewSearchProductCellNib = UINib(nibName: "ABSTransactionTableViewCell", bundle: nil)
    self.transactionTableView.register(tableViewSearchProductCellNib, forCellReuseIdentifier: "ABSTransactionTableViewCell")
    
    viewModel.transactionList.bind(key: ObjectIdentifier(self).hashValue) {[weak self] transactionList in
      guard let strongSelf = self else { return }
      strongSelf.performInMainThread {
        strongSelf.didReceiveTransactionList()
      }
    }
    
    viewModel.fetchTransactionList()
  }
  
  private func didReceiveTransactionList() {
    transactionTableView.reloadData()
  }


}

extension ASBTransactionListVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}

extension ASBTransactionListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let dataSource = viewModel.transactionList.value else {
      return  0
    }
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ABSTransactionTableViewCell", for: indexPath) as! ABSTransactionTableViewCell
    guard let dataSource = viewModel.transactionList.value else { return cell }
    
    let transaction = dataSource[indexPath.row]
    cell.populateUI(transaction)
    return cell
  }
  
}

extension ASBTransactionListVC: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let dataSource = viewModel.transactionList.value else { return }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let transactionDetailsVC = storyboard.instantiateViewController(withIdentifier: "ASBTransactionDetailsVC") as? ASBTransactionDetailsVC else {
      return
    }
    transactionDetailsVC.viewModel.transaction.value = dataSource[indexPath.row]
    navigationController?.pushViewController(transactionDetailsVC, animated: true)
  }
}
