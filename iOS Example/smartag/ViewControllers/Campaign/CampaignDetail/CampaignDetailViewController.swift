//
//  CampaignDetailViewController.swift
//  smartag
//
//  Created by Rubén Alonso on 21/1/21.
//

import UIKit
import B4FSDK
import SkeletonView

class CampaignDetailViewController: UIViewController {

    @IBOutlet weak var tableViewBadges: UITableView!
    @IBOutlet weak var tableViewBadgesConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelshortDescription: UILabel!
    @IBOutlet weak var labellongDescription: UILabel!
    @IBOutlet weak var labelstartDate: UILabel!
    @IBOutlet weak var labelendDate: UILabel!
    @IBOutlet weak var labeltypeId: UILabel!
    @IBOutlet weak var labeltypeName: UILabel!

    @IBOutlet weak var buttonSubscribe: UIButton!

    var id: String?
    var cellId = "BadgesCellId"
    var badgesList = [CampaignDetailBadge]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getCampaign()
    }

    func setupTableView() {
        tableViewBadges.dataSource = self
        tableViewBadges.tableFooterView = UIView()
    }

    func reloadTableView() {
        tableViewBadgesConstraint?.constant = CGFloat.greatestFiniteMagnitude
        tableViewBadges.reloadData()
        tableViewBadges.setNeedsLayout()
        tableViewBadges.layoutIfNeeded()
        let tableHeight = tableViewBadges.contentSize.height
        tableViewBadgesConstraint?.constant = tableHeight
    }

    func getCampaign() {
        guard let id = id else {
            return
        }
        view.showSkeleton()
        B4F.shared.campaigns.getCampaignBy(id: id) { (response) in
            switch response {
            case .success(let item):
                self.updateView(item: item)
                self.view.hideSkeleton()
            case .failure(let error):
                print(error)
            }
        }
    }

    func updateView(item: CampaignDetail) {
        print(item)
        labelName.text = item.name
        labelshortDescription.text = item.shortDescription
        labellongDescription.text = item.longDescription
        labeltypeId.text = (item.typeId == .coupon) ? "Coupon" : "Raffle"
        labeltypeName.text = item.typeName
//        buttonSubscribe.isHidden = (item.typeId == .coupon)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        if let startDate = item.startDate {
            labelstartDate.text = dateFormatter.string(from: startDate)
        }
        if let endDate = item.endDate {
            labelendDate.text = dateFormatter.string(from: endDate)
        }

        badgesList = item.badgesList
        reloadTableView()
    }
    
    @IBAction func subscribeToCampaign(_ sender: Any) {
        B4F.shared.delegate = self
        B4F.shared.startNFC(alertMessage: "Subscribe to campaing")

    }
}

extension CampaignDetailViewController: B4FDelegate {
    func nfcFailWith(error: Error) {
        print(error)
    }

    func nfcDetectTags(tag: String) {
        guard let id = id else {
            return
        }
        B4F.shared.campaigns.linkAndSubscribeToCampaignWith(id: id, smartTagCode: tag) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CampaignDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badgesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        cell!.textLabel?.numberOfLines = 0
        cell!.detailTextLabel?.numberOfLines = 0
        cell!.textLabel?.text = badgesList[indexPath.row].badgeName
        cell!.detailTextLabel?.text = badgesList[indexPath.row].badgeDescription
        return cell!
    }
}
