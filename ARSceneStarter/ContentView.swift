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
