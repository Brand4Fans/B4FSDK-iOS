//
//  CampaignViewController.swift
//  iOS Example
//
//  Created by Rubén Alonso on 18/3/21.
//

import UIKit
import B4FSDK

protocol CampaignFilterDelegate {
    func didSelect(filter: CampaignFilter?)
}

class CampaignFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var filters: CampaignFilter?
    var selectedFilters = CampaignFilter(JSON: [:])

    var delegate: CampaignFilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(barButtonSystemItem: .done,
                                   target: self,
                                   action: #selector(closeView))
        navigationItem.rightBarButtonItem = item
        setupTableView()
        getFilters()
    }

    func getFilters() {
        B4F.shared.campaigns.getFiltersCampaign { (result) in
            switch result {
            case .success(let filter):
                self.filters = filter
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc func closeView() {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                switch indexPath.section {
                case 0:
                    if let filter = filters?.listCampaignType[indexPath.row] {
                        selectedFilters?.listCampaignType.append(filter)
                    }
                case 1:
                    if let filter = filters?.listBadge[indexPath.row] {
                        selectedFilters?.listBadge.append(filter)
                    }
                case 2:
                    if let filter = filters?.listCompany[indexPath.row] {
                        selectedFilters?.listCompany.append(filter)
                    }
                default:
                    break
                }
            }
        }
        dismiss(animated: true) {
            self.delegate?.didSelect(filter: self.selectedFilters)
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCellId")
        tableView.tableFooterView = UIView()
    }

}

extension CampaignFilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return filters?.listCampaignType.count ?? 0
        case 1:
            return filters?.listBadge.count ?? 0
        case 2:
            return filters?.listCompany.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCellId", for: indexPath)
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            let filter = filters?.listCampaignType[indexPath.row]
            cell.textLabel?.text = filter?.name
        case 1:
            let filter = filters?.listBadge[indexPath.row]
            cell.textLabel?.text = filter?.badgeName
        case 2:
            let filter = filters?.listCompany[indexPath.row]
            cell.textLabel?.text = filter?.name
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "listCampaignType"
        case 1:
            return "listBadge"
        case 2:
            return "listCompany"
        default:
            return "unknown"
        }
    }
}

extension CampaignFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = (cell?.isSelected ?? false) ? .checkmark : .none
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = (cell?.isSelected ?? false) ? .checkmark : .none
    }
}
