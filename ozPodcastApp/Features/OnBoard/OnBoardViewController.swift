//
//  OnBoardViewController.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//  
//

import UIKit

final class OnBoardViewController: UIViewController, NavigationView {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterOnBoardProtocol!
    
}

extension OnBoardViewController: PresenterToViewOnBoardProtocol{
    // TODO: Implement View Output Methods
}