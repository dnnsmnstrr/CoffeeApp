//
//  TipsAndTricksTableViewController.swift
//  TheCoffeeApp
//
//  Created by Tiago Pereira on 17/04/2018.
//  Copyright © 2018 Apple Developer Academy. All rights reserved.
//

import UIKit

fileprivate let textTipIdentifier = "textTipIdentifier"
fileprivate let imageTipIdentifier = "imageTipIdentifier"

class TipsAndTricksTableViewController: UITableViewController {

    var tips: [Tip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tips = APIManager.shared.getAllTips()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(TipsAndTricksTableViewController.refreshData), name: NSNotification.Name(rawValue: "refreshTips"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func refreshData(){
        //
        DispatchQueue.main.async {
            self.tips = APIManager.shared.getAllTips()
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.tips.count-1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tip = self.tips[indexPath.row]
        
        let cell: UITableViewCell
        
        switch tip.type {
        case .text:
            cell = tableView.dequeueReusableCell(withIdentifier: textTipIdentifier, for: indexPath)
        case .image:
            cell = tableView.dequeueReusableCell(withIdentifier: imageTipIdentifier, for: indexPath)
        }
        
        if let textTipCell = cell as? TextTipTableViewCell {
            textTipCell.subjectLabel.text = tip.subject
            textTipCell.headlineLabel.text = tip.headline
            
            textTipCell.tipTextLabel.text = tip.description
        } else if let imageTipCell = cell as? ImageTipTableViewCell {
            imageTipCell.subjectLabel.text = tip.subject
            imageTipCell.headlineLabel.text = tip.headline
            
            if let imageName = tip.imageURL {
                imageTipCell.tipImageView.image = UIImage(named: imageName)
            }
        }
        
        return cell
    }
    
}
