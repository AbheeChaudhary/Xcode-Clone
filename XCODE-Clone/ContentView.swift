//
//  ContentView.swift
//  XCODE-Clone
//
//  Created by Abhee Chaudhary on 13/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    // state variables start
    
    @State private var statusMessage: String = "Ready"
    
    
    
    // State variables end

    var body: some View {
        VStack(spacing : 0){
            HStack{
                Text("Run")
                    .padding()
                Spacer()
                Text("Tool Bar")
                    .font(.headline)
                    .padding()
                Spacer()
                Text("Settings")
                    .padding()
                
                
            }
            .frame(height: 40)
            .background(Color.gray)
        }
    }

    
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
