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
    
    // State variables
    @State private var statusMessage: String = "Ready"
    @State private var showNavigator: Bool = true
    @State private var navigatorWidth: CGFloat = 200
    @State private var selectedFile: String? = nil
    @State private var openedFiles: [String] = []
    
    let fileList = ["Main.swift", "AppDelegate.swift", "ViewController.swift", "Utilities.swift", "Extensions.swift"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        navigatorWidth = 150 // Reset width when toggling
                        showNavigator.toggle()
                        statusMessage = showNavigator ? "Navigator Opened" : "Navigator Closed"
                    }
                }) {
                    Image(systemName: "sidebar.left")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.5)
                }
                
                Spacer()
                
                Button(action: {
                    statusMessage = "Stop Clicked"
                }) {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.3)
                }
                
                Button(action: {
                    statusMessage = "Run Clicked"
                }) {
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
                    statusMessage = "Show Library Clicked"
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .foregroundColor(.white.opacity(0.6))
                        .scaleEffect(1.3)
                }
                
                Button(action: {
                    statusMessage = "Inspectors Clicked"
                }) {
                    Image(systemName: "sidebar.right")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .scaleEffect(1.6)
                }
            }
            .frame(height: 40)
            .background(Color.gray.opacity(0.2))
            
            // Main Content Area
            HStack(spacing: 0) {
                // Navigator Pane
                if showNavigator {
                    VStack(alignment: .leading) {
                        Text("Navigator Area")
                            .font(.headline)
                            .padding(.top)
                        
                        Divider()
                        
                        // File List
                        ForEach(fileList, id: \.self) { file in
                            Text(file)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(selectedFile == file ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(5)
                                .onTapGesture {
                                    // Add to opened files if not already open
                                    if !openedFiles.contains(file) {
                                        openedFiles.append(file)
                                    }
                                    selectedFile = file
                                    statusMessage = "Selected: \(file)"
                                }
                        }
                        Spacer()
                    }
                    .frame(width: navigatorWidth)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .overlay(
                        // Resize Handle
                        Rectangle()
                            .frame(width: 5)
                            .foregroundColor(Color.gray.opacity(0.3))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newWidth = navigatorWidth + value.translation.width
                                        // Auto-close if width is below threshold
                                        if newWidth < 150 {
                                            withAnimation {
                                                showNavigator = false
                                            }
                                        } else {
                                            navigatorWidth = max(150, min(newWidth, 400))
                                        }
                                    }
                            )
                            .onHover { isHovering in
                                if isHovering {
                                    NSCursor.resizeLeftRight.push()
                                } else {
                                    NSCursor.pop()
                                }
                            },
                        alignment: .trailing
                    )
                    .animation(.easeInOut, value: navigatorWidth) // Apply smooth resizing animation
                }
                
                // Editor Area with custom tab bar
                VStack {
                    // Custom Tab Bar for opened files
                    if openedFiles.isEmpty {
                        Text("No files open")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else {
                        HStack(spacing: 0) {
                            ForEach(openedFiles, id: \.self) { file in
                                VStack {
                                    Button(action: {
                                        selectedFile = file
                                    }) {
                                        Text(file)
                                            .fontWeight(selectedFile == file ? .bold : .regular)
                                            .foregroundColor(selectedFile == file ? .blue : .primary)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(selectedFile == file ? Color.blue.opacity(0.2) : Color.clear)
                                            .cornerRadius(5)
                                            .transition(.opacity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // Close Button for the file
                                    Button(action: {
                                        closeFile(file: file)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                            .scaleEffect(0.7)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .opacity(selectedFile == file ? 1 : 0) // Close button appears on active tab
                                }
                                .padding(.trailing, 5)
                                .frame(maxHeight: .infinity)
                                .background(
                                    selectedFile == file ? Color.blue.opacity(0.1) : Color.clear
                                )
                                .cornerRadius(5)
                            }
                        }
                        .padding(.top, 10)
                        .background(
                            Color.gray.opacity(0.1).cornerRadius(10) // Rounded corners for the tab bar
                        )
                        
                        // Editor View for the selected file
                        if let selectedFile = selectedFile {
                            VStack {
                                Text("Editing: \(selectedFile)")
                                    .font(.headline)
                                    .padding()
                                
                                Divider()
                                
                                TextEditor(text: .constant("// Code for \(selectedFile)"))
                                    .frame(maxHeight: .infinity)
                                    .background(Color.white)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .frame(maxHeight: .infinity)
            
            // Status Bar
            Text(statusMessage)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.03))
        }
    }
    
    // Function to close a file
    func closeFile(file: String) {
        if let index = openedFiles.firstIndex(of: file) {
            openedFiles.remove(at: index)
            if selectedFile == file {
                selectedFile = openedFiles.first // Select the first file if any are left
            }
            statusMessage = "Closed: \(file)"
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
