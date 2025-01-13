//
//  MainView.swift
//  Taskly
//
//  Created by Islam Rzayev on 10.12.24.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                ContentView()
                    .onAppear(){
                        AppOpenAdManager.shared.loadAd()
                        AppOpenAdManager.shared.showAdIfAvailable()
                    }
            }else{
                LoginView()
            }
        }
        
    }
}

#Preview {
    MainView()
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
}
