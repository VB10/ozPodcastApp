//
//  BaseInteractor.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

import Foundation

protocol BaseInteractor {
    var generalService: GeneralService { get }
}

extension BaseInteractor {
    var generalService: GeneralService {
        return GeneralService()
    }
}
