//
//  DashboardViewController.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 1.01.2024.
//

import UIKit

final class HomeViewController: UIViewController, NavigationView {
    private var presenter: HomePresenterProtocol!

    lazy var homeView: HomeView = {
        let view = HomeView(self)
        view.backgroundColor = .primary
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        presenter.viewDidLoad()
    }

    func updatePresenter(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        homeView.setPresenter(presenter)
    }
}
