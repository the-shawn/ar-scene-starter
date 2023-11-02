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

#Preview {
    ContentView(viewModel: ViewModel())
}
