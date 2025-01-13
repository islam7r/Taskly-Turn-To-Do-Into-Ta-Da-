//
//  AppOpenAdManager.swift
//  Taskly
//
//  Created by Islam Rzayev on 07.01.25.
//

import GoogleMobileAds
import SwiftUI

class AppOpenAdManager: NSObject, GADFullScreenContentDelegate {
    static let shared = AppOpenAdManager()
    private var appOpenAd: GADAppOpenAd?
    private var isAdShowing = false

    
    func loadAd() {
        GADAppOpenAd.load(
            withAdUnitID: "ca-app-pub-4816684168621488/7715414509",
            request: GADRequest(),
            completionHandler: { [weak self] ad, error in
                if let error = error {
                    print("Failed to load app open ad: \(error.localizedDescription)")
                    return
                }
                self?.appOpenAd = ad
                self?.appOpenAd?.fullScreenContentDelegate = self
                print("App Open Ad loaded successfully")
            }
        )
    }

    
    func showAdIfAvailable() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("No valid root view controller found")
            return
        }
        if let appOpenAd = appOpenAd {
            appOpenAd.present(fromRootViewController: rootVC)
            self.appOpenAd = nil
            print("App Open Ad presented successfully")
        } else {
            print("Ad not ready to be presented")
        }
    }

    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return nil
        }
        return window.rootViewController
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad dismissed")
        isAdShowing = false
        loadAd() 
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad will present")
    }

    func adDidFailToPresentFullScreenContent(_ ad: GADFullScreenPresentingAd, withError error: Error) {
        print("App Open Ad failed to present: \(error.localizedDescription)")
        isAdShowing = false
        loadAd()
    }
}
