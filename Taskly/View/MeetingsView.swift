import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MeetingsView: View {
    @State private var currentTime: String = ""
    @State private var search: String = ""
    @State private var filteredMeetings: [Meeting] = []
    @State private var sheetShown: Bool = false
    @EnvironmentObject var meetingViewModel: MeetingViewModel
   

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
           
            ZStack {
               
                LinearGradient(
                    colors: [
                        Color(red: 0.14, green: 0.21, blue: 0.26),
                        Color(red: 0.89, green: 0.95, blue: 0.91)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(filteredMeetings) { meeting in
                            NavigationLink(destination: MeetingDetailsView(meeting: meeting)) {
                                meetingCard(meeting: meeting)
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    
                    .scrollIndicators(.hidden)
                    .listStyle(.inset)
                    .searchable(text: $search)
                    .onChange(of: search, {
                        filterMeetings()
                    })
                    .toolbar {
                        Image(systemName: "plus")
                            .onTapGesture {
                                sheetShown = true
                            }
                            .sheet(isPresented: $sheetShown) {
                                AddMeetingView()
                                    .environmentObject(meetingViewModel)
                            }
                    }
                    .onAppear {
                        meetingViewModel.fetchMeetings()
                        filteredMeetings = meetingViewModel.meetings
                    }
                    .onChange(of: meetingViewModel.meetings, {
                        filterMeetings()
                    })
                }
                
            }
            Spacer()
            AdBannerView(adUnitID: "ca-app-pub-4816684168621488/9132437955")
                .frame(height: 50)
        }
        .tint(Color(red: 0.20, green: 0.29, blue: 0.33))
    }
    
    // MARK: - Meeting Card View
    private func meetingCard(meeting: Meeting) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 330, height: 100)
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.24, green: 0.21, blue: 0.26),
                        Color(red: 0.89, green: 0.85, blue: 0.71)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .padding()
            .overlay {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(meeting.title)
                                .font(Font.system(size: 20))
                                .foregroundStyle(Color.white.opacity(0.7))
                           
                            Image(systemName: meeting.selectedIcon == "" ? "sparkles" : meeting.selectedIcon ?? "sparkles")
                                .symbolEffect(.pulse)
                        }
                        
                        Rectangle()
                            .frame(width: 300, height: 0.5)
                            .foregroundStyle(Color.earthySeparator)
                                          
                        
                    }
                    .padding(.horizontal)
                 
                }
            }
    }
    
    // MARK: - Update Current Time
    func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        currentTime = formatter.string(from: Date())
    }
    
    // MARK: - Filter Meetings
    private func filterMeetings() {
        if search.isEmpty {
            filteredMeetings = meetingViewModel.meetings
        } else {
            filteredMeetings = meetingViewModel.meetings.filter { meeting in
                meeting.title.localizedCaseInsensitiveContains(search) ||
                meeting.description.localizedCaseInsensitiveContains(search)
            }
        }
    }
    
}


#Preview {
    MeetingsView()
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
}
