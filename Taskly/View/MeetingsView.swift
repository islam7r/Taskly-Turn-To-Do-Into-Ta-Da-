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
                // Background Gradient
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
        }
        .tint(Color(red: 0.20, green: 0.29, blue: 0.33))
    }
    
    // MARK: - Meeting Card View
    private func meetingCard(meeting: Meeting) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 330, height: 200)
            .foregroundStyle(Color.earthyBackground)
            .shadow(color: Color.black.opacity(0.8), radius: 5, x: -5, y: 10)
            .shadow(color: Color.black.opacity(0.8), radius: 5, x: 5, y: -10)
            .padding()
            .overlay {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(meeting.title)
                            .font(Font.system(size: 40))
                            .foregroundStyle(Color.earthyTitle)
                        
                        Rectangle()
                            .frame(width: 300, height: 0.5)
                            .foregroundStyle(Color.earthySeparator)
                        
                        Text(meeting.description)
                            .font(.headline)
                            .foregroundStyle(Color.earthySubtitle)
                        
                        
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
