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
            HStack(spacing:0){
                Button(action: {
                    statusMessage = "Stop Clicked"
                }){
                    Image(systemName: "stop.fill")
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.8)
                        
                }
                
                Button(action: {
                    statusMessage = "Run Clicked"
                }){
                    Image(systemName: "play.fill")
                        
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.8)
                        
                }
                
                
                Spacer()
                Text("Xcode Clone")
                    .font(.headline)
                    
                Spacer()
                Button(action: {
                    statusMessage = "Settings clicked!"
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.blue)
                        .padding()
                        .scaleEffect(1.8)
                }
                
                
            }
            .frame(height: 40)
            .background(Color.gray.opacity(0.2))
            
            Text(statusMessage)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.03))
            
        }
    }

    
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
