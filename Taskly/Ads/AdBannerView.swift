//
//  AdBannerView.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.01.25.
//

import SwiftUI
import GoogleMobileAds


struct AdBannerView: UIViewControllerRepresentable {
    
    let adUnitID: String

        func makeUIViewController(context: Context) -> UIViewController {
            let viewController = UIViewController()
            let bannerView = GADBannerView(adSize: GADAdSizeBanner)
            bannerView.adUnitID = adUnitID
            bannerView.rootViewController = viewController
            bannerView.load(GADRequest())
            viewController.view.addSubview(bannerView)

            // Set the layout
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
            ])
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    AdBannerView(adUnitID: "ca-app-pub-4816684168621488/9132437955")
}
