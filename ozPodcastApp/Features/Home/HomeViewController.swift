//
//  HomeViewController.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.08.2024.
//
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.presenter?.onLikPressed()
        }
    }

    // MARK: - Properties

    var presenter: ViewToPresenterHomeProtocol?
}

extension HomeViewController: PresenterToViewHomeProtocol {
    func showDialogMessage(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.show(self, sender: nil)
    }
}


