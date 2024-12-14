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
    @State private var showNavigator: Bool = true
    // making it resizeable
    @State private var navigatorWidth : CGFloat = 200 // default value
    @State private var selectedFile = ""
    
    
    
    // State variables end

    var body: some View {
        VStack(spacing : 0){
            HStack(spacing:0){
                Button(action: {
                    showNavigator.toggle()
                    statusMessage = showNavigator ? "Navigator Opened" : "Navigator Closed"
                }){
                    Image(systemName: "sidebar.left")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.5)
                        
                }
                
                Button(action: {
                    statusMessage = "Stop Clicked"
                }){
                    Image(systemName: "stop.fill")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.3)
                        
                }
                
                Button(action: {
                    statusMessage = "Run Clicked"
                }){
                    Image(systemName: "play.fill")
                        
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.3)
                        
                }
                
                
                Spacer()
                Text("Xcode Clone")
                    .font(.headline)
                    
                Spacer()
                Button(action: {
                    statusMessage = "Show Libary clicked"
                }){
                    Image(systemName: "plus")
                        .padding()
                        .foregroundColor(.white.opacity(0.6))
                        .scaleEffect(1.3)
                }
                Button(action: {
                    statusMessage = "Inspectors clicked"
                }) {
                    Image(systemName: "sidebar.right")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.6)
                }
                
                
            }
            .frame(height: 40)
            .background(Color.gray.opacity(0.2))
            // creating the main workspace and the sidepanes
            HStack(spacing:0){
                if showNavigator{
                    VStack(alignment: .leading){
                        Text("Navigator Area")
                            .font(.headline)
                            .padding(.top)
                        Divider()
                        ForEach(1..<6){ index in
                            Text("File \(index).swift")
                                .padding(.vertical,5)
                                .padding(.horizontal)
                                .background(selectedFile == "File \(index).swift" ? Color.blue : Color.clear)
                                .onTapGesture {
                                    selectedFile = "File \(index).swift"
                                    statusMessage = "Selected \(selectedFile)"
                                }
                            
                        }
                        Spacer()
                    }
                    .frame(width : navigatorWidth)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .overlay(
                        Rectangle()
                            .frame(width : 5)
                            .foregroundColor(Color.gray.opacity(0.3))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        navigatorWidth =  max(100,navigatorWidth + value.translation.width)
                                        
                                    }
                                
                            ),
                        alignment: .trailing
                    )
                }
                
                VStack{
                    Text("Editor Area")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                .frame(maxWidth : .infinity)
                .background(Color.white)
                
            }
            .frame(maxHeight : .infinity)
            
            
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
