//
//  ContentView.swift
//  LiveCallClient
//
//  Created by LongNT on 29/11/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var callEvent = CallEvent()
    
    @State private var url: String = "https://tucthi11234.testing.3.livecall.jp"
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("LiveCallClientApp")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }.padding(.bottom, 10)
                
            TextField("", text: $url)
                .disableAutocorrection(true)
                .padding(5)
                .border(.gray)
            
            Button("Make a call") {
                showingSheet.toggle()
            }
            .buttonStyle(.bordered)
            .padding(3)
            .fontWeight(.medium)
            .sheet(isPresented: $showingSheet) {
                WebUIView(url: $url.wrappedValue, open: $showingSheet)
            }
            
            HStack {
                Text("Received event END_CALL:")
                Text(String(callEvent.countReceivedEvent))
            }
            
        }
        .padding()
        .environmentObject(callEvent)
    }
}

class CallEvent: ObservableObject {
    @Published var countReceivedEvent = 0
}

#Preview {
    ContentView()
}
