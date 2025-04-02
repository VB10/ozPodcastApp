//
//  MainThread+Weakify.swift
//  PodcastApp
//
//  Created by vb10 on 8.02.2024.
//

// https://medium.com/nerd-for-tech/simplifying-dispatch-main-async-ab9313b87293
import Foundation

protocol MainThreadRunnerType: AnyObject {
    /// Ana iş parçacığında belirtilen bloğu çalıştırır. Eğer zaten ana iş parçacığında ise bloğu doğrudan çalıştırır, değilse asenkron olarak ana iş parçacığına ekler.
    func runOnMain(_ block: @escaping () -> Void)

    /// Ana iş parçacığında belirtilen bloğu çalıştırır. Eğer zaten ana iş parçacığında ise bloğu doğrudan çalıştırır, değilse asenkron olarak ana iş parçacığına ekler.
    /// `self` referansını zayıf bir şekilde yakalar, böylece potansiyel retain döngülerini önler.
    func runOnMainSafety(_ block: @escaping () -> Void)
}

extension MainThreadRunnerType {
    func runOnMain(_ block: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async(execute: block)
            return
        }
        block()
    }

    func runOnMainSafety(_ block: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let _ = self else { return }
                block()
            }
            return
        }
        block()
    }
}
