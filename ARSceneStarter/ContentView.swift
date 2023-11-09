//
//  ContentView.swift
//  ARSceneStarter
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    @State private var showingTextInput = false
    @State private var inputText = ""
    
    var body: some View {
        ZStack {
            // AR View.
            ARViewContainer(viewModel: viewModel)
            
            VStack {
                Spacer()
                
                HStack {
                    resetButton()

                    Spacer()

                    dropButton()

                    Spacer()

                    placeButton()

                    Spacer()

                    randomizeButton()

                    Spacer()

                    debugButton()
                }
                .padding()
            }
            
            Button(action: {
                            self.showingTextInput = true
                        }) {
                            Text("Add Text")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        // This is the sheet that presents the text input view
                        .sheet(isPresented: $showingTextInput) {
                            // Pass the binding to the text field
                            TextInputView(inputText: $inputText, isPresented: $showingTextInput, viewModel: viewModel)
                        }
        }
    }
    
    // Reset button.
    func resetButton() -> some View {
        Button {
            viewModel.uiSignal.send(.reset)
        } label: {
            Label("Reset", systemImage: "gobackward")
                .font(.system(.title))
                .foregroundColor(.white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }

    // Drop button.
    func dropButton() -> some View {
        Button {
            viewModel.uiSignal.send(.drop)
        } label: {
            Text("Drop")
                .foregroundColor(.white)
        }
    }

    // Randomize button.
    func placeButton() -> some View {
        Button {
            viewModel.uiSignal.send(.place)
        } label: {
            Text("Place")
                .foregroundColor(.white)
        }
    }
    
    // Randomize button.
    func randomizeButton() -> some View {
        Button {
            viewModel.uiSignal.send(.randomize)
        } label: {
            Text("Randomize")
                .foregroundColor(.white)
        }
    }
    
    // Debug button.
    func debugButton() -> some View {
        Button {
            viewModel.showDebug.toggle()
        } label: {
            Text(viewModel.showDebug ? "Debug On" : "Debug Off")
                .foregroundColor(.white)
        }
    }
}

struct TextInputView: View {
    @Binding var inputText: String
    @Binding var isPresented: Bool
    var viewModel: ViewModel // Directly passing the ViewModel

    var body: some View {
        VStack {
            TextField("Enter text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add") {
                // Call the function to create the text entity with the input text
                viewModel.createTextEntity(with: inputText)
                self.isPresented = false // Dismiss the sheet
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
