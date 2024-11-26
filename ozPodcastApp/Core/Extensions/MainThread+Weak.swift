//
//  MainThread+Weak.swift
//  ozPodcastApp
//
//  Created by vb10 on 8.11.2024.
//

import Foundation
protocol MainThreadRunner: AnyObject {
    func runOnMain(_ block: @escaping () -> Void)
    
    /// It will handle view dealloce
    func runOnMainSafety(_ block: @escaping () -> Void)
}

extension MainThreadRunner {
    func runOnMain(_ block: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                block()
            }
            return
        }
        
        block()
    }
    
    func runOnMainSafety(_ block: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                block()
            }
            return
        }
        
        block()
    }
}
