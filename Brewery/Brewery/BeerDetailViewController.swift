//
//  BeerDetailViewController.swift
//  Brewery
//
//  Created by mijisuh on 2024/03/02.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    
    var beer: Beer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    private func configureView() {
        self.title = beer?.name ?? "이름 없는 맥주"
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
        
        self.tableView.tableHeaderView = headerView
    }

}

// UITableView DataSource, Delegate
extension BeerDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: // Food Pairing
            return beer?.foodPairing?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "Description"
        case 2:
            return "Brewers Tips"
        case 3:
            let isFoodPairingIsEmpty = beer?.foodPairing?.isEmpty ?? true
            return isFoodPairingIsEmpty ? nil : "Food Pairing"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
        case 1:
            cell.textLabel?.text = beer?.description ?? "설명 없는 맥주"
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "팁 없는 맥주"
        case 3:
            cell.textLabel?.text = beer?.foodPairing?[indexPath.row] ?? ""
        default:
            break
        }
        
        return cell
    }
    
}
