//
//  ViewModel.swift
//  ARSceneStarter
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import Foundation
import Combine
import AVFAudio
import AVFoundation
import Combine

@MainActor
class ViewModel: ObservableObject {
    // App state variables.
    @Published var showDebug = false
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordings: [URL] = [] // This array will keep track of all recordings
    
    func startRecording() {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                // Permission is granted, start recording
                initiateRecording()
            case .denied:
                // Permission was previously denied, please direct the user to settings.
                print("Microphone permission was previously denied.")
            case .undetermined:
                // Permission has not been requested yet, request it.
                AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] granted in
                    if granted {
                        // The permission has been granted, start recording
                        DispatchQueue.main.async {
                            self.initiateRecording()
                        }
                    } else {
                        // Permission denied, handle it.
                        print("Microphone permission denied.")
                    }
                }
            @unknown default:
                // Handle any new cases that are added in the future
                print("Unknown microphone permission status.")
            }
        }
    
    private func initiateRecording() {
            let recordingSession = AVAudioSession.sharedInstance()
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let audioFilename = documentPath.appendingPathComponent("\(UUID().uuidString).m4a")
                
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder?.record()
                
                // Add the current recording URL to the recordings array
                recordings.append(audioFilename)
                
            } catch {
                // Handle the error, e.g., show an alert to the user
            }
        }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        // Ensure there is a last recording to send
        if let lastRecording = recordings.last {
            uiSignal.send(.recordingFinished(recording: lastRecording))
        }
    }
    
    func playRecording(url: URL) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                // Handle the error, e.g., show an alert to the user
                print("Could not play the recording.")
            }
    }

    func createTextEntity(with text: String) {
            // Send a UI signal to create a text entity
            uiSignal.send(.createTextEntity(text))
        }
    
    // For handling UI signals.
    enum UISignal {
        case reset
        case drop
        case place
        case randomize
        case createTextEntity(String)
        case recordingFinished(recording: URL)

    }
    let uiSignal = PassthroughSubject<UISignal, Never>()
    

    // Initialization method.
    init() {
        
    }
}
