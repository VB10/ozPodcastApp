//
//  HomeViewController.swift
//  ozPodcastApp
//
//  Created by vb10 on 7.08.2024.
//  
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterHomeProtocol?
    
}

extension HomeViewController: PresenterToViewHomeProtocol{
    // TODO: Implement View Output Methods
}
