//
//  ExampleProfileView.swift
//  Taskly
//
//  Created by Islam Rzayev on 15.12.24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ExampleProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @EnvironmentObject var taskViewModel: DailyTaskViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [
                    Color(red: 0.14, green: 0.21, blue: 0.26),
                    Color(red: 0.89, green: 0.95, blue: 0.91)
                ], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // User Info Card
                    userInfoCard()

                    // User Statistics
                    statisticsCard()

                    // Recent Activity
                    recentActivityCard()

                    Spacer()

                    // Logout Button
                    logoutButton()
                }
                .padding()
            }
        }
    }
}

extension ExampleProfileView {
    // MARK: - User Info Card
    @ViewBuilder
    private func userInfoCard() -> some View {
        if let user = viewModel.currentUser {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 380, height: 100)
                .foregroundStyle(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: -5, y: 5)
                .overlay {
                    HStack {
                        // User Initials Circle
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 90, height: 90)
                            .background(Color.gray)
                            .clipShape(Circle())
                            .padding()

                        // User Info
                        VStack(alignment: .leading, spacing: 5) {
                            Text(user.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
        }
    }

    // MARK: - Statistics Card
    @ViewBuilder
    private func statisticsCard() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 380, height: 150)
            .foregroundStyle(Color.black.opacity(0.2))
            .shadow(color: Color.black.opacity(0.8), radius: 10, x: -10, y: 5)
            .overlay {
                HStack(spacing: 30) {
                    statisticItem(value:  taskViewModel.tasks.count, label: "Tasks Created")
                    statisticItem(value:  taskViewModel.tasks.filter { $0.isFinished }.count, label: "Tasks Completed")
                    statisticItem(value:  meetingViewModel.meetings.count, label: "Meetings Scheduled")
                }
            }
    }

    private func statisticItem(value: Int, label: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }

    // MARK: - Recent Activity Card
    @ViewBuilder
    private func recentActivityCard() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 380, height: 250)
            .foregroundStyle(Color.black.opacity(0.2))
            .shadow(color: Color.black.opacity(0.8), radius: 10, x: -10, y: 5)
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

    // MARK: - Logout Button
    @ViewBuilder
    private func logoutButton() -> some View {
        Button(action: {
            viewModel.signOut()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 40)
                .foregroundStyle(Color.black)
                .shadow(color: Color.black.opacity(0.8), radius: 10, x: -10, y: 5)
                .overlay {
                    Text("Logout")
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                }
        }
    }
}

#Preview {
    ExampleProfileView()
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
}
