//
//  HomeViewController.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.08.2024.
//
//

import UIKit

final class HomeViewController: UIViewController, NavigationView {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = HomeView(self)
    }

    // MARK: - Properties

    var presenter: ViewToPresenterHomeProtocol!
}

extension HomeViewController: PresenterToViewHomeProtocol {
    func showMessage(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.show(self, sender: nil)
    }
    
    // TODO: Implement View Output Methods
}
