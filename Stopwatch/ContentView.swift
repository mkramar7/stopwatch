//
//  ContentView.swift
//  Stopwatch
//
//  Created by Marko Kramar on 02/10/2020.
//

import SwiftUI

struct HistoryItem: Identifiable {
    let id = UUID()
    var value: String
}

struct ContentView: View {
    @State private var stopWatchTime = 0
    @State private var timerStarted = false
    @State private var history = [HistoryItem]()
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    
    var body: some View {
        // Title
        VStack {
            Text("Stop Watch")
                .font(.system(size: 40))
                .padding(.bottom, 10)
                .padding(.top, 100)
            
            // Timer part
            VStack {
                Text("\(self.getMinutesAndSeconds())")
                    .font(.system(size: 60))
                    .onReceive(timer) { _ in
                        self.stopWatchTime += 1
                    }
                
                HStack {
                    Button("Reset") {
                        self.resetStopWatch()
                    }.disabled(!timerStarted)
                    Spacer()
                    Button("Play/Pause") {
                        self.playOrPauseTimer()
                    }
                    Spacer()
                    Button("Stop") {
                        self.stopTimer()
                    }
                }
                .padding(.top, 20)
            }
            .padding(30)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color(.black), lineWidth: 2)
            )
            
            // History part
            VStack {
                HStack {
                    Spacer()
                    Text("history")
                        .padding(.leading, 20)
                    Spacer()
                    Button("Clear") {
                        self.history.removeAll()
                    }
                }
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(history, id: \.id) {
                            Text($0.value)
                                .font(.headline)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .padding(10)
                .padding(.leading, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color(.black), lineWidth: 2)
                )
                .frame(height: 200)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(.top, 20)
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    
    func getMinutesAndSeconds() -> String {
        let minutes = self.stopWatchTime / 60
        let seconds = self.stopWatchTime % 60
        
        var strMinutes = "\(minutes)"
        var strSeconds = "\(seconds)"
        
        if minutes < 10 {
            strMinutes = "0" + strMinutes
        }
        
        if seconds < 10 {
            strSeconds = "0" + strSeconds
        }
        
        return "\(strMinutes):\(strSeconds)"
    }
    
    func stopTimer() {
        self.timer.connect().cancel()
        self.stopWatchTime = 0
        self.timerStarted = false
    }
    
    func playOrPauseTimer() {
        if !self.timerStarted {
            self.timer = Timer.publish(every: 1, on: .main, in: .common)
            self.timer.connect()
            self.timerStarted = true
        } else {
            self.timer.connect().cancel()
            self.timerStarted = false
        }
    }
    
    func resetStopWatch() {
        self.history.append(HistoryItem(value: self.getMinutesAndSeconds()))
        self.stopWatchTime = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
