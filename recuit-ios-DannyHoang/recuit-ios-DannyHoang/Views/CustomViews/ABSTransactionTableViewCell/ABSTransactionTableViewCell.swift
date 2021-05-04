//
//  ABSTransactionTableViewCell.swift
//  recuit-ios-DannyHoang
//
//  Created by Truong Dinh Hoang on 5/05/21.
//

import UIKit

class ABSTransactionTableViewCell: UITableViewCell {
  
  //MARK: - Public IBoulets
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var gstLabel: UILabel!
  
  //MARK: - Public Life Cycle Functions
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    bgView.layer.masksToBounds = true
    bgView.layer.cornerRadius = 5.0
  }
  
  //MARK: - Public Functions
  func populateUI(_ transaction: ASBTransaction) {
    
    dateLabel.text = transaction.getDateString()
    summaryLabel.text = transaction.summary
    idLabel.text = "ID: " + (transaction.id ?? "")
    amountLabel.text = transaction.getAmountString()
    
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
