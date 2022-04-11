//
//  SmartagViewController.swift
//  smartag
//
//  Created by Rubén Alonso on 1/2/21.
//

import UIKit
import B4FSDK

class SmartagViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let cellId = "SmartagCellId"
    var smartags: SmartTagList?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(getSmarttags), name: .smarttag, object: nil)
        let item = UIBarButtonItem(barButtonSystemItem: .add,
                                   target: self,
                                   action: #selector(changeEdit))
        navigationItem.rightBarButtonItem = item
        let logo = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo")))
        navigationItem.leftBarButtonItem = logo
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSmarttags()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }

    @objc func getSmarttags() {
        B4F.shared.smarttags.getSmartTags(query: nil) { (result) in
            switch result {
            case .success(let value):
                self.smartags = value
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc func changeEdit() {
        B4F.shared.delegate = self
        B4F.shared.startNFC(alertMessage: "Lee el tag")
    }
}

extension SmartagViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smartags?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = smartags?.list[indexPath.row].badgeName
        return cell
    }
}

extension SmartagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let smartagId = smartags?.list[indexPath.row].smarttagCode else {
            return
        }
        B4F.shared.smarttags.disassociateSmartTag(code: smartagId) { (result) in
            switch result {
            case .success():
                self.smartags?.list.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SmartagViewController: B4FDelegate {
    func nfcFailWith(error: Error) {
        print(error)
    }

    func nfcDetectTags(tag: String) {
        B4F.shared.smarttags.associateSmartTag(code: tag) { (result) in
            switch result {
            case .success():
                self.showSuccessVinculation()
            case .failure(let error):
                print(error)
            }
        }
    }

    func showSuccessVinculation() {
        let alert = UIAlertController(title: "NFC", message: "Success associated tags", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        NotificationCenter.default.post(name: .smarttag, object: nil)
    }
}
