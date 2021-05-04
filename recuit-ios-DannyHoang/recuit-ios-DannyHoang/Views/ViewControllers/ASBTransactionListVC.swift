//
//  ViewController.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 2/05/21.
//

import UIKit

class ASBTransactionListVC: UIViewController {

  //MARK: - Public Const
  let searchController = UISearchController(searchResultsController: nil)
  
  //MARK: - Public IBOutlets
  @IBOutlet weak var transactionTableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  
  //MARK: - Public variables
  var viewModel: ASBTransactionListViewModel = ASBTransactionListViewModel()
  
  
  //MARK: - Private variables
  var isLoading: Bool = false
  
  //MARK: - Life Cycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter by summary"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    let tableViewTransactionCellNib = UINib(nibName: "ABSTransactionTableViewCell", bundle: nil)
    self.transactionTableView.register(tableViewTransactionCellNib, forCellReuseIdentifier: "ABSTransactionTableViewCell")
    
    let tableViewMessageCellNib = UINib(nibName: "ASBMessageTableViewCell", bundle: nil)
    self.transactionTableView.register(tableViewMessageCellNib, forCellReuseIdentifier: "ASBMessageTableViewCell")
    
    viewModel.transactionList.bind(key: ObjectIdentifier(self).hashValue) {[weak self] transactionList in
      guard let strongSelf = self else { return }
      defer {
        strongSelf.performInMainThread {
          strongSelf.toggleLoading(false)
        }
      }
      strongSelf.performInMainThread {
        strongSelf.didReceiveTransactionList()
      }
    }
    
    viewModel.fetchTransactionErrorMessage.bind(key: ObjectIdentifier(self).hashValue) {[weak self] errorMessage in
      guard let strongSelf = self else { return }
      strongSelf.performInMainThread {
        strongSelf.didReceiveTransactionList()
      }
    }
    toggleLoading(true)
    viewModel.fetchTransactionList()
  }
  
  //MARK: - Private Functions
  private func didReceiveTransactionList() {
    transactionTableView.reloadData()
  }
  
  private func toggleLoading(_ show: Bool){
    isLoading = show
    if show {
      loadingView.isHidden = false
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.loadingView.alpha = 1
      }
    } else {
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.loadingView.alpha = 1
      } completion: { [weak self] completed in
        guard let strongSelf = self else { return }
        if completed {
          strongSelf.loadingView.isHidden = true
        }
      }

    }

  }

}

//MARK: - UISearchResultsUpdating Implementations
extension ASBTransactionListVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}

//MARK: - UITableViewDataSource Implementations
extension ASBTransactionListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let dataSource = viewModel.transactionList.value else {
      
      return isLoading ? 0 : 1
      
    }
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dataSource = viewModel.transactionList.value else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ASBMessageTableViewCell", for: indexPath) as? ASBMessageTableViewCell else { return UITableViewCell() }
      var message = "Opps you dont have any transaction!"
      if let errorStr = viewModel.fetchTransactionErrorMessage.value {
        message = errorStr
      }
      cell.populateUI(message, "RETRY")
      cell.actionHandler = {[weak self] in
        guard let strongSelf = self else { return }
        strongSelf.viewModel.fetchTransactionList()
        strongSelf.performInMainThread {
          strongSelf.toggleLoading(true)
        }
      }
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ABSTransactionTableViewCell", for: indexPath) as? ABSTransactionTableViewCell else { return UITableViewCell() }
    let transaction = dataSource[indexPath.row]
    cell.populateUI(transaction)
    return cell
  }
  
}

//MARK: - UITableViewDelegate Implementations
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
