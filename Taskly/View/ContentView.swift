//
//  ContentView.swift
//  Taskly
//
//  Created by Islam Rzayev on 02.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine

struct ContentView: View {
    @State private var currentTime: String = ""
    @State private var sheetShown: Bool = false
    @State private var activitySheet: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @EnvironmentObject var taskViewModel: DailyTaskViewModel
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
    
    var body: some View {
        TabView {
            HomeView(currentTime: $currentTime, sheetShown: $sheetShown, timer: timer)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            DailyTaskView(task: DailyTasks(userId: "exampleId", title: "title", description: "example description"))
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                    Text("Daily Tasks")
                }
            
            MeetingsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Meetings")
                }
        }
        .onAppear {
             
             Task {
                 await taskViewModel.fetchTasks()
                 await meetingViewModel.fetchMeetings()
             }
            
         }
        .tint(Color(red: 0.83, green: 0.95, blue: 0.87))
        
    }
}

struct HomeView: View {
    @Binding var currentTime: String
    @Binding var sheetShown: Bool
    let timer: Timer.TimerPublisher
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HeaderView()
                        Spacer()
                        
                        Text("Turn Your To-Do Into Ta-Da!")
                            .font(Font.custom("BungeeInline-Regular", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(12)
                            .background(
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.teal.opacity(0.5)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                        .shadow(color: Color.cyan.opacity(0.7), radius: 10, x: 0, y: 4)

                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(0.85))
                                }
                            )
                            .shadow(color: Color.cyan.opacity(0.5), radius: 10, x: 0, y: 5)
                            .padding()
                        
                        CurrentTimeView(currentTime: $currentTime, timer: timer)
                        RecentActivities()
                        TaskStatistics(sheetShown: $sheetShown)
                        
                    }
                    .onAppear(){
                        AppOpenAdManager.shared.loadAd()
                        AppOpenAdManager.shared.showAdIfAvailable()
                    }
                }
                
                
            }
        }
        .tint(Color(red: 0.20, green: 0.29, blue: 0.33))
       
    }
    
    private var gradientBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.14, green: 0.21, blue: 0.26),
                Color(red: 0.89, green: 0.95, blue: 0.91)
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

struct HeaderView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        HStack {
            Text("Taskly")
                .foregroundStyle(Color(red: 0.14, green: 0.21, blue: 0.26))
                .font(Font.system(size: 45))
                .fontWeight(.light)
                .padding(.horizontal)
            
            Spacer()
            
            HStack {
             
                
                if let user = viewModel.currentUser{
                    NavigationLink(destination: ProfileView()){
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 70, height: 70)
                            .background(Color(red: 0.14, green: 0.21, blue: 0.26))
                            .clipShape(Circle())
                            .padding()
                        }
                    
                    
                }else{
                    NavigationLink(destination: ProfileView()) {
                          Image(systemName: "person.circle")
                              .foregroundStyle(Color(red: 0.14, green: 0.21, blue: 0.26))
                              .font(Font.system(size: 70))
                              .padding(.horizontal)
                      }
                }
            }
        }
    }
}

struct CurrentTimeView: View {
    @Binding var currentTime: String
    let timer: Timer.TimerPublisher
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundStyle(Color(red: 0.20, green: 0.29, blue: 0.33))
            .frame(width: 300, height: 350)
            .padding(.trailing, 100)
            .overlay {
                VStack {
                    Text("Current Time")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.title)
                        .fontWeight(.light)
                    Text(currentTime)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .padding()
                        .border(Color.white, width: 1)
                        .foregroundStyle(Color(red: 0.83, green: 0.95, blue: 0.87))
                        .background(Color(red: 0.20, green: 0.29, blue: 0.33))
                        .cornerRadius(75)
                        .onReceive(timer.autoconnect()) { _ in
                            updateTime()
                        }
                        .onAppear(perform: updateTime)
                }
            }
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .full
        currentTime = formatter.string(from: Date())
    }
}

struct TaskStatistics: View {
    @Binding var sheetShown: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @EnvironmentObject var taskViewModel: DailyTaskViewModel
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundStyle(Color(red: 0.83, green: 0.95, blue: 0.87))
            .frame(width: 390, height: 220, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 20)
            .overlay {
                HStack(spacing: 30) {
                    statisticItem(value:  taskViewModel.tasks.count, label: "Tasks Created")
                    statisticItem(value:  taskViewModel.tasks.filter { $0.isFinished }.count, label: "Tasks Completed")
                    statisticItem(value:  meetingViewModel.meetings.count, label: "Meetings Scheduled")
                }
            }
            .sheet(isPresented: $sheetShown) {
                DailyTaskView(task: DailyTasks(userId: "exampleId", title: "title", description: "example description"))
            }
    }
    private func statisticItem(value: Int, label: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color(red: 0.20, green: 0.29, blue: 0.33))
            Text(label)
                .font(.caption)
                .foregroundColor(Color(red: 0.20, green: 0.29, blue: 0.33).opacity(0.7))
        }
    }
}
struct RecentActivities: View{
    @State private var activitySheet: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @EnvironmentObject var taskViewModel: DailyTaskViewModel
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundStyle(Color.calmSubtitle)
            .frame(width: 390, height: 220, alignment: .leading)
            .padding(.top, 20)
            .padding(.trailing, 20)
            .overlay {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Activity")
                        .font(.headline)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .padding(.bottom, 5)

                    if taskViewModel.tasks.isEmpty {
                        Text("No recent activity available")
                            .foregroundStyle(.gray)
                            .italic()
                    } else {
                        ForEach(taskViewModel.tasks.prefix(3)) { task in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                    Text("Completed: \(task.isFinished ? "Yes" : "No")")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

    }
    
    
}



#Preview {
    ContentView()
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
}
