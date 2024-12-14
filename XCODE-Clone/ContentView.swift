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
    
    @State private var statusMessage: String = "Ready"
    @State private var showNavigator: Bool = true
    @State private var navigatorWidth: CGFloat = 200
    @State private var selectedFile: String? = nil
    @State private var openedFiles: [String] = []
    @State private var consoleHeight: CGFloat = 200
    @State private var consoleMessages: [String] = ["Build Successful", "No errors found", "Ready for debugging"]
    @State private var showConsole: Bool = false
    
    let fileList = ["Main.swift", "AppDelegate.swift", "ViewController.swift", "Utilities.swift", "Extensions.swift"]
    
    @Environment(\.colorScheme) var colorScheme
    
    private func loadSavedState() {
        if let savedNavigatorWidth = UserDefaults.standard.value(forKey: "navigatorWidth") as? CGFloat {
            navigatorWidth = savedNavigatorWidth
        }
        if let savedShowNavigator = UserDefaults.standard.value(forKey: "showNavigator") as? Bool {
            showNavigator = savedShowNavigator
        }
        if let savedConsoleHeight = UserDefaults.standard.value(forKey: "consoleHeight") as? CGFloat {
            consoleHeight = savedConsoleHeight
        }
    }
    
    private func saveState() {
        UserDefaults.standard.set(navigatorWidth, forKey: "navigatorWidth")
        UserDefaults.standard.set(showNavigator, forKey: "showNavigator")
        UserDefaults.standard.set(consoleHeight, forKey: "consoleHeight")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        navigatorWidth = 150
                        showNavigator.toggle()
                        statusMessage = showNavigator ? "Navigator Opened" : "Navigator Closed"
                        saveState()
                    }
                }) {
                    Image(systemName: "sidebar.left")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                        .scaleEffect(1.5)
                }
                
                Spacer()
                
                Button(action: {
                    statusMessage = "Stop Clicked"
                }) {
                    Image(systemName: "stop.fill")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                        .scaleEffect(1.3)
                }
                
                Button(action: {
                    statusMessage = "Run Clicked"
                }) {
                    Image(systemName: "play.fill")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
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
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .scaleEffect(1.3)
                }
                
                Button(action: {
                    statusMessage = "Inspectors Clicked"
                }) {
                    Image(systemName: "sidebar.right")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                        .scaleEffect(1.6)
                }
            }
            .frame(height: 40)
            .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
            
            HStack(spacing: 0) {
                if showNavigator {
                    VStack(alignment: .leading) {
                        Text("Navigator Area")
                            .font(.headline)
                            .padding(.top)
                        
                        Divider()
                        
                        ForEach(fileList, id: \.self) { file in
                            Text(file)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(selectedFile == file ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(5)
                                .onTapGesture {
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
                        Rectangle()
                            .frame(width: 5)
                            .foregroundColor(Color.gray.opacity(0.3))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newWidth = navigatorWidth + value.translation.width
                                        navigatorWidth = max(150, min(newWidth, 400))
                                        saveState()
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
                    .animation(.easeInOut, value: navigatorWidth)
                }
                
                VStack {
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
                                            .background(selectedFile == file ? Color.blue.opacity(0.2) : Color.gray)
                                            .cornerRadius(5)
                                            .transition(.opacity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {
                                        closeFile(file: file)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                            .scaleEffect(0.7)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .opacity(selectedFile == file ? 1 : 0)
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
                            Color.gray.opacity(0.1).cornerRadius(10)
                        )
                        
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
            
            if showConsole {
                VStack {
                    HStack {
                        Text("Console")
                            .font(.headline)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            clearConsole()
                        }) {
                            Text("Clear")
                                .padding(.horizontal)
                                .foregroundColor(.blue)
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(consoleMessages, id: \.self) { message in
                                Text(message)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .frame(maxHeight: consoleHeight)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3), value: showConsole)
                
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newHeight = consoleHeight - value.translation.height
                                consoleHeight = max(150, min(newHeight, 400))
                                saveState()
                            }
                    )
                    .onHover { isHovering in
                        if isHovering {
                            NSCursor.resizeUpDown.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
            }
            
            Text(statusMessage)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.03))
            
            Button(action: {
                withAnimation {
                    showConsole.toggle()
                }
            }) {
                Text(showConsole ? "Hide Console" : "Show Console")
                    .padding()
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            loadSavedState()
        }
    }
    
    func closeFile(file: String) {
        if let index = openedFiles.firstIndex(of: file) {
            openedFiles.remove(at: index)
            if selectedFile == file {
                selectedFile = openedFiles.first
            }
            statusMessage = "Closed: \(file)"
        }
    }
    
    func clearConsole() {
        consoleMessages.removeAll()
        statusMessage = "Console Cleared"
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
