//
//  AlertViewController.swift
//  iOS Example
//
//  Created by Rubén Alonso on 15/3/21.
//

import UIKit
import B4FSDK

class AlertViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let cellId = "AlertsCellId"
    var alerts: AlertList?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        let item = UIBarButtonItem(barButtonSystemItem: .action,
                                   target: self,
                                   action: #selector(readAll))
        navigationItem.rightBarButtonItem = item
        let logo = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo")))
        navigationItem.leftBarButtonItem = logo
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlerts()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    @objc func getAlerts() {
        B4F.shared.alerts.getAlerts(query: Query(take: 100, skip: 0)) { (result) in
            switch result {
            case .success(let value):
                self.alerts = value
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getNotifications() {
        B4F.shared.alerts.getNotReadAlertsCount { (result) in
            switch result {
            case .success(let value):
                guard let value = value.totalNotRead, value > 0 else {
                    self.navigationController?.tabBarItem.badgeValue = nil
                    return
                }
                self.navigationController?.tabBarItem.badgeValue = "\(value)"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc func readAll() {
        B4F.shared.alerts.setAllAlertsRead { (result) in
            switch result {
            case .success():
                self.getAlerts()
                self.getNotifications()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension AlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        cell!.detailTextLabel?.numberOfLines = 0
        cell!.textLabel?.text = alerts?.list[indexPath.row].name
        cell!.detailTextLabel?.text = alerts?.list[indexPath.row].body
        cell?.textLabel?.font = (alerts?.list[indexPath.row].read ?? false) ? UIFont.systemFont(ofSize: 17) : UIFont.boldSystemFont(ofSize: 17)
        return cell!
    }
}

extension AlertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        guard let alert = alerts?.list[index],
              !(alert.read ?? false),
              let id = alert.id else {
            return
        }
        B4F.shared.alerts.setAlertReadBy(id: id) { (result) in
            switch result {
            case .success():
                self.getAlerts()
                self.getNotifications()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
