//
//  HomeDetailViewController.swift
//  PodcastApp
//
//  Created by vb10 on 7.02.2024.
//
//

import Toast
import UIKit

final class HomeDetailViewController: UIViewController, NavigationView {
    var presenter: ViewToPresenterHomeDetailProtocol!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.close()
    }

    lazy var homeDetailView: HomeDetailView = {
        let view = HomeDetailView(self)
        view.delegate = presenter
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeDetailView
    }
}

extension HomeDetailViewController: PresenterToViewHomeDetailProtocol {
    func updateUI(podcast: PodcastResponse) {
        homeDetailView.updateUI(podcast: podcast)
    }

    func showMessageLibraryAdded(result: Bool) {
        if result {
            view.makeToast("Added to library")
        } else {
            view.makeToast("Removed from library")
        }
    }

    func updateTimeView(time: Double) {
        homeDetailView.updateMusicTimeField(value: time)
    }

    func updateProgressView(percent: Float) {
        homeDetailView.updateMusicPlayProgress(value: percent)
    }
}

