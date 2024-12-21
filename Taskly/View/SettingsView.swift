//
//  SettingsView.swift
//  Taskly
//
//  Created by Islam Rzayev on 03.12.24.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedView = LoginView()
    
    var body: some View {
        VStack{
            Text("Hello")
        }
        
    }
}

#Preview {
    SettingsView()
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
}
