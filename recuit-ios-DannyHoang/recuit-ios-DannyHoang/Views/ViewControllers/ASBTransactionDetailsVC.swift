//
//  ASBTransactionDetailsVC.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import UIKit

class ASBTransactionDetailsVC: UIViewController {
  
  var viewModel = ASBTransactionDetailsViewModel()
  
  //MARK: - Public IBOulets
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var gstLabel: UILabel!
  @IBOutlet weak var bgView: UIView!
  
  //MARK: - Public Life Cycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    bgView.layer.masksToBounds = true
    bgView.layer.cornerRadius = 10
    viewModel.transaction.bindNotify(key: ObjectIdentifier(self).hashValue) {[weak self] transaction in
      guard let strongSelf = self, let _transaction = transaction else { return }
      strongSelf.populateUI(_transaction)
    }
  }
  
  //MARK: - Public Functions
  func populateUI(_ transaction: ASBTransaction){
    idLabel.text = transaction.id
    summaryLabel.text = transaction.summary
    dateLabel.text = transaction.getDateString()
    if let debit = transaction.debit, debit != 0 {
      amountLabel.textColor = .red
    } else if let credit = transaction.credit, credit != 0 {
      amountLabel.textColor = .green
    }
    amountLabel.text = transaction.getAmountString()
    
    if let _ = transaction.gst {
      gstLabel.text = "gst: " + transaction.getGSTString()
    } else {
      gstLabel.isHidden = true
    }
  }
}
