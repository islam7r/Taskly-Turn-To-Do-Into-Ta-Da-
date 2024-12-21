//
//  TasklyApp.swift
//  Taskly
//
//  Created by Islam Rzayev on 02.12.24.
//

import SwiftUI
import Firebase

@main
struct TasklyApp: App {
    init() {
        
        // MARK: - UITabBarAppearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.14, green: 0.21, blue: 0.26, alpha: 1.00)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.83, green: 0.95, blue: 0.87, alpha: 1.00)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.52, green: 0.66, blue: 0.56, alpha: 1.00)
        UITabBar.appearance().standardAppearance = appearance
       UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // MARK: - UINavigationBarAppearance
        let appearance2 = UINavigationBarAppearance()
        appearance2.configureWithOpaqueBackground()
        appearance2.backgroundColor = UIColor.clear
        appearance2.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.20, green: 0.29, blue: 0.33, alpha: 1.00)]
        appearance2.titleTextAttributes = [.foregroundColor: UIColor(red: 0.20, green: 0.29, blue: 0.33, alpha: 1.00)]
        
        
        UINavigationBar.appearance().standardAppearance = appearance2
       
        // MARK: - UIToolbarAppearance
        let appearance3 = UIToolbarAppearance()
        appearance3.configureWithOpaqueBackground()
        appearance3.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        appearance3.backgroundImage?.withTintColor( UIColor(red: 0.14, green: 0.21, blue: 0.26, alpha: 1.00))
        
        
        let appearance4 = UITextField()
        appearance4.textColor = UIColor(red: 0.20, green: 0.29, blue: 0.33, alpha: 1.00)

        
        
        FirebaseApp.configure()
        
    }
    @StateObject var viewModel = AuthViewModel()
    @StateObject var dailyTaskViewModel = DailyTaskViewModel()
    @StateObject var meetingViewModel =  MeetingViewModel()
    var body: some Scene {
      
       
       
        
        WindowGroup {
            MainView()
                .environmentObject(meetingViewModel)
                .environmentObject(dailyTaskViewModel)
                .environmentObject(viewModel)
                .preferredColorScheme(.light)
        }
    }
}

