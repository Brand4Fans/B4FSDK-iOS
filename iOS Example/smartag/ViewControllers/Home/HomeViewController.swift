//
//  HomeViewController.swift
//  smartag
//
//  Created by Rubén Alonso on 21/1/21.
//

import UIKit
import B4FSDK
import Kingfisher
import SkeletonView

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let refreshControl = UIRefreshControl()

    let cellId = "NewsCellId"
    var campigns: CampaignList?
    var news: NewsList?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        let logo = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo")))
        navigationItem.leftBarButtonItem = logo
        setupTableView()
        getNews()
    }

    func setupTableView() {
        refreshControl.addTarget(self, action: #selector(getNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.register(NewCell.nib(), forCellReuseIdentifier: NewCell.reuseId)
        tableView.tableFooterView = UIView()
    }

    @objc func getNews() {
        let query = Query(take: 5, skip: 0)
        B4F.shared.news.getNews(query: query) { (result) in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let value):
                self.news = value
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewCell.reuseId, for: indexPath) as! NewCell
        cell.title?.text = news?.list[indexPath.row].title
        cell.desc?.text = news?.list[indexPath.row].summary
        if let url = URL(string: news?.list[indexPath.row].complements?.avatar?.url ?? "") {
            cell.imageNew?.kf.setImage(with: url)
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = NewDetailViewController()
        vc.id = news?.list[index].id
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewCell.reuseId
    }
}
