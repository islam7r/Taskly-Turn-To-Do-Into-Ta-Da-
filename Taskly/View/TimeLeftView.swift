//
//  TimeLeftView.swift
//  Taskly
//
//  Created by Islam Rzayev on 03.01.25.
//

import SwiftUI

struct TimeLeftView: View {
    let deadline: Date
    let time: Date
    @State private var timeLeft: String = ""
    @State private var daysLeft: String = ""
    @State private var hoursLeft: String = ""
    @State private var minutesLeft: String = ""
    @State private var progress: Double = 0.7
    
    @State private var totalMinutes: Int = 0
    @State private var drawingStroke = false
    

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {


        ZStack {

            if daysLeft == "0" && hoursLeft == "0" && minutesLeft == "0"{
                VStack {
                    Text("Deadline Passed")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.black, Color.black.opacity(0.5)],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .frame(width: 270, height: 50)
                                .foregroundColor(Color.white.opacity(0.3))
                        )
                    
                        .font(Font.custom("Jersey20-Regular", size: 40))
                        .padding()
                    Image(systemName: "xmark.octagon.fill")
                        .foregroundStyle(.red)
                        .font(Font.system(size: 30))
                        .symbolEffect(.pulse)
                    Divider()
                    Text("Feel free to delete this meeting and set up a new one.")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(Font.footnote)
                }
            }else{
                VStack {
                    
                    HStack {
                        Text("Time Left")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.black, Color.black.opacity(0.5)],
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                )
                            )
                            
                            .font(Font.custom("Jersey20-Regular", size: 40))
                        
                        Image(systemName: "hourglass")
                            .symbolRenderingMode(.multicolor)
                            .symbolEffect(.pulse)
                            .font(Font.system(size: 30))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .circular)
                            .frame(width: 200, height: 50)
                            .foregroundColor(Color.white.opacity(0.3))
                    )
                    HStack(spacing: 20){
                        
                        VStack{
                            Text(("\(daysLeft)"))
                                .font(Font.custom("HelveticaNeue-Light", size: 22))
                            Text("Days")
                                .font(Font.custom("BungeeInline-Regular", size: 20))
                                .foregroundStyle(Color.vibrantBackground)
                        }
                        Rectangle()
                            .frame(width: 1, height: 30, alignment: .center)
                        VStack{
                            Text("\(hoursLeft)")
                                .font(Font.custom("HelveticaNeue-Light", size: 22))
                            Text("Hr")
                                .font(Font.custom("BungeeInline-Regular", size: 20))
                                .foregroundStyle(Color.vibrantBackground)
                        }
                        Rectangle()
                            .frame(width: 1, height: 30, alignment: .center)
                        VStack{
                            Text(minutesLeft)
                                .font(Font.custom("HelveticaNeue-Light", size: 22))
                            Text("Min")
                                .font(Font.custom("BungeeInline-Regular", size: 20))
                                .foregroundStyle(Color.vibrantBackground)
                        }
                        
                    }
                    .fixedSize()
                    Divider()
                    Text("Not happy with this meeting? You can delete it and make a new one.")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(Font.footnote)
                }
            }
            

            
        }
        .padding()
        .onAppear(perform: calculateTimeLeft)
        .onReceive(timer) { _ in
            calculateTimeLeft()
        }
    }
    
    private func calculateTimeLeft() {
        let now = Date.now
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: deadline)
        let timeDifference = calendar.dateComponents([.day, .hour, .minute], from: now, to: time )
        let days = components.day ?? 0
        let hours = timeDifference.hour ?? 0
        let minutes = timeDifference.minute ?? 0
        
        totalMinutes = days * 24 * 60 + hours * 60 + minutes
        
       
        if days != 0{
            daysLeft = "\(abs(days))"
            hoursLeft = "\(abs(hours))"
            minutesLeft = "\(abs(minutes))"
        }else if minutes <= 0 && hours <= 0{
            daysLeft = "0"
            hoursLeft = "0"
            minutesLeft = "0"
        }else{
            daysLeft = "\(days)"
            hoursLeft = "\(hours)"
            minutesLeft = "\(minutes)"
        }

    }

}
    #Preview {
        TimeLeftView(deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                     time: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        
    }

