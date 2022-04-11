//
//  CampaignViewController.swift
//  smartag
//
//  Created by Rubén Alonso on 21/1/21.
//

import UIKit
import B4FSDK

class CampaignViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let cellId = "CampaingsCellId"
    var campigns: CampaignList?
    var query = Query(JSON: [:])
    var filter: CampaignFilter?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campaigns"
        NotificationCenter.default.addObserver(self, selector: #selector(getCampaings), name: .smarttag, object: nil)
        let item = UIBarButtonItem(barButtonSystemItem: .compose,
                                   target: self,
                                   action: #selector(openFilter))
        navigationItem.rightBarButtonItem = item

        let logo = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo")))
        navigationItem.leftBarButtonItem = logo
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCampaings()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    @objc func openFilter() {
        let vc = CampaignFilterViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    @objc func getCampaings() {
        query?.take = 10
        query?.skip = 0
        query?.filterCampaignType = filter?.listCampaignType.compactMap({"\($0.idDecrypt!)"})
        query?.filterCompany = filter?.listCompany.compactMap({$0.id})
        query?.filterBadge = filter?.listBadge.compactMap({$0.badgeId})
        B4F.shared.campaigns.getMyCampaigns(query: query) { (result) in
            switch result {
            case .success(let value):
                self.campigns = value
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CampaignViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campigns?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        cell!.textLabel?.text = campigns?.list[indexPath.row].name
        cell!.detailTextLabel?.text = campigns?.list[indexPath.row].shortDescription
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Campaigns"
    }
}

extension CampaignViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = CampaignDetailViewController()
        vc.id = campigns?.list[index].id
        present(vc, animated: true, completion: nil)
    }
}

extension CampaignViewController: CampaignFilterDelegate {
    func didSelect(filter: CampaignFilter?) {
        self.filter = filter
        getCampaings()
    }
}
