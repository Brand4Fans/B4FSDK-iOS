//
//  NewDetailViewController.swift
//  smartag
//
//  Created by Rubén Alonso on 21/1/21.
//

import UIKit
import WebKit
import B4FSDK

class NewDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var id: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getNew()
    }

    func getNew() {
        guard let id = id else {
            return
        }
        B4F.shared.news.getNewBy(id: id) { (result) in
            switch result {
            case .success(let new):
                self.update(new: new)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func update(new: NewsDetail) {
        imageView.kf.setImage(with: URL(string: new.complements?.avatar?.url ?? ""))
        labelTitle.text = new.title
        let html = """
                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
                <style>
                    img {
                        width: 100%;
                        height: auto;
                    }
                    iframe {
                        width: 100%;
                        height: auto;
                    }
                </style>
                </head>
                <body>
                    \(new.html ?? "")
                </body>
                </html>
                """
        webView.loadHTMLString(html, baseURL: nil)
    }
}
