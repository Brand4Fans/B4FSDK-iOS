//
//  CouponsViewController.swift
//  iOS Example
//
//  Created by Rubén Alonso on 12/3/21.
//

import UIKit
import B4FSDK
import SwiftDate

class CouponsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var coupons = CouponList(JSON: [:])
    var couponsUnavailable = CouponList(JSON: [:])
    var redeemed: [CouponListItem]?
    var expired: [CouponListItem]?
    var active: [CouponListItem]?
    var won: [CouponListItem]?

    var selectedCoupon: CouponListItem?


    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coupons"
        NotificationCenter.default.addObserver(self, selector: #selector(getCoupons), name: .smarttag, object: nil)
        let item = UIBarButtonItem(title: "Redeem",
                                   style: .plain,
                                   target: self,
                                   action: #selector(redeemCoupon))
        navigationItem.rightBarButtonItem = item
        navigationItem.rightBarButtonItem?.isEnabled = false
        let logo = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo")))
        navigationItem.leftBarButtonItem = logo
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCoupons()
    }

    func setupTableView() {
        refreshControl.addTarget(self, action: #selector(getCoupons), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CouponsCell.nib(), forCellReuseIdentifier: CouponsCell.reuseId)
        tableView.tableFooterView = UIView()
    }

    @objc func getCoupons() {
        B4F.shared.coupons.getCoupons(query: nil) { (result) in
            switch result {
            case .success(let value):
                self.coupons = value
                B4F.shared.coupons.getUnavailableCoupons(query: nil) { (result) in
                    self.refreshControl.endRefreshing()
                    switch result {
                    case .success(let value):
                        self.couponsUnavailable = value
                        self.divideCoupons()
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                self.divideCoupons()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }

    @objc func redeemCoupon() {
        guard let id = selectedCoupon?.id else {
            return
        }
        B4F.shared.coupons.redeemCouponWith(id: id) { (result) in
            switch result {
            case .success():
                print("Redeemed")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func divideCoupons() {
        redeemed = coupons?.list.filter({$0.state == .redeemed})
        redeemed?.append(contentsOf: couponsUnavailable?.list.filter({$0.state == .redeemed}) ?? [CouponListItem]())
        expired = coupons?.list.filter({$0.state == .expired})
        expired?.append(contentsOf: couponsUnavailable?.list.filter({$0.state == .expired}) ?? [CouponListItem]())
        active = coupons?.list.filter({$0.state == .active})
        active?.append(contentsOf: couponsUnavailable?.list.filter({$0.state == .active}) ?? [CouponListItem]())
        won = coupons?.list.filter({$0.state == .won})
        won?.append(contentsOf: couponsUnavailable?.list.filter({$0.state == .won}) ?? [CouponListItem]())
    }
}

extension CouponsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return redeemed?.count ?? 0
        case 1:
            return expired?.count ?? 0
        case 2:
            return active?.count ?? 0
        case 3:
            return won?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponsCell.reuseId, for: indexPath) as! CouponsCell
        var coupon: CouponListItem?
        switch indexPath.section {
        case 0:
            coupon = redeemed?[indexPath.row]
        case 1:
            coupon = expired?[indexPath.row]
        case 2:
            coupon = active?[indexPath.row]
        case 3:
            coupon = won?[indexPath.row]
        default:
            break
        }
        cell.labelTitle?.text = coupon?.campaignName
        cell.labelDesc?.text = coupon?.campaignShortDescription
        cell.labelDate.text = coupon?.campaignStartDate?.toFormat("dd MMM yyyy")
        if let url = URL(string: coupon?.complements?.avatar?.url ?? "") {
            cell.imgView?.kf.setImage(with: url)
        }
        if let color = UIColor(hex: "#\(coupon?.company?.colorHexaCode ?? "ff0000")00") {
            cell.containerView.backgroundColor = color
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "redeemed"
        case 1:
            return "expired"
        case 2:
            return "active"
        case 3:
            return "won"
        default:
            return "unknown"
        }
    }
}

extension CouponsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedCoupon = redeemed?[indexPath.row]
        case 1:
            selectedCoupon = expired?[indexPath.row]
        case 2:
            selectedCoupon = active?[indexPath.row]
        case 3:
            selectedCoupon = won?[indexPath.row]
        default:
            selectedCoupon = nil
        }
        navigationItem.rightBarButtonItem?.isEnabled = true//(selectedCoupon?.state == .active)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}
