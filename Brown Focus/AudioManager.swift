//
//  AudioManager.swift
//  Brown Focus
//
//  Created by Brandon Seaver on 3/21/25.
//


import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentNoiseType: NoiseType = .brown
    @Published var volume: Float = 0.8 // Default volume at 80%
    
    init() {
        generateNoise(type: currentNoiseType)
    }
    
    func generateNoise(type: NoiseType) {
        currentNoiseType = type
        
        // Generate the noise
        let sampleRate = 44100
        let duration = 5.0 // 5 second loop - increase for less repetition
        let samples = Int(duration * Double(sampleRate))
        
        var noiseBuffer = [Float](repeating: 0.0, count: samples)
        
        switch type {
        case .brown:
            generateBrownNoise(buffer: &noiseBuffer, samples: samples)
        case .white:
            generateWhiteNoise(buffer: &noiseBuffer, samples: samples)
        case .grey:
            generateGreyNoise(buffer: &noiseBuffer, samples: samples)
        case .green:
            generateGreenNoise(buffer: &noiseBuffer, samples: samples)
        }
        
        // Convert to audio buffer
        let format = AVAudioFormat(standardFormatWithSampleRate: Double(sampleRate), channels: 1)!
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples))!
        buffer.frameLength = buffer.frameCapacity
        
        // Copy samples to buffer
        let channelData = buffer.floatChannelData![0]
        for i in 0..<samples {
            channelData[i] = noiseBuffer[i]
        }
        
        // Create audio file
        let noiseFileName = "\(type.rawValue.lowercased())Noise.caf"
        let filePath = getDocumentsDirectory().appendingPathComponent(noiseFileName)
        
        let audioFile = try? AVAudioFile(forWriting: filePath, settings: format.settings)
        try? audioFile?.write(from: buffer)
        
        // Create audio player
        do {
            // Stop current player if playing
            if isPlaying {
                audioPlayer?.stop()
                isPlaying = false
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = volume // Set the volume
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to create audio player: \(error)")
        }
    }
    
    // TWEAKABLE PARAMETERS FOR BROWN NOISE:
    // - lastValueFactor: Controls how much previous value influences next value (0.01-0.05)
    //   Higher values = smoother, more bass-heavy sound
    // - integrationFactor: Controls frequency rolloff (1.01-1.04)
    //   Higher values = steeper rolloff, more bass focus
    // - amplification: Overall volume multiplier (1.0-5.0)
    //   Higher values = louder output but risk of clipping
    private func generateBrownNoise(buffer: inout [Float], samples: Int) {
        var lastValue: Float = 0.0
        let lastValueFactor: Float = 0.04    // TWEAK THIS: 0.01-0.05
        let integrationFactor: Float = 1.03   // TWEAK THIS: 1.01-1.04
        let amplification: Float = 2.75        // TWEAK THIS: 1.0-5.0
        
        for i in 0..<samples {
            let whiteNoise = Float.random(in: -1...1)
            // Brown noise formula - integrating white noise
            lastValue = (lastValue + (lastValueFactor * whiteNoise)) / integrationFactor
            buffer[i] = lastValue * amplification
        }
    }
    
    // TWEAKABLE PARAMETERS FOR WHITE NOISE:
    // - amplitude: Controls the maximum volume of the noise (0.1-1.0)
    //   Higher values = louder, more harsh sound
    private func generateWhiteNoise(buffer: inout [Float], samples: Int) {
        let amplitude: Float = 0.6    // TWEAK THIS: 0.1-1.0
        
        for i in 0..<samples {
            buffer[i] = Float.random(in: -amplitude...amplitude)
        }
    }
    
    // TWEAKABLE PARAMETERS FOR GREY NOISE:
    // - lowFreqFactor: Multiplier for low frequencies (0.5-1.0)
    //   Higher values = more bass
    // - midFreqFactor: Multiplier for mid frequencies (0.8-1.5)
    //   Higher values = more speech range frequencies
    // - highFreqFactor: Multiplier for high frequencies (0.5-1.0)
    //   Higher values = more treble/hiss
    private func generateGreyNoise(buffer: inout [Float], samples: Int) {
        // Generate white noise first
        generateWhiteNoise(buffer: &buffer, samples: samples)
        
        let lowFreqFactor: Float = 0.8     // TWEAK THIS: 0.5-1.0
        let midFreqFactor: Float = 1.2     // TWEAK THIS: 0.8-1.5
        let highFreqFactor: Float = 1.0    // TWEAK THIS: 0.5-1.0
        
        // Apply perceptual filter to match human hearing sensitivity
        for i in 0..<samples {
            if i % 4 == 0 { // Simple way to simulate lower frequency bands
                buffer[i] *= lowFreqFactor
            } else if i % 3 == 0 { // Mid frequencies
                buffer[i] *= midFreqFactor
            } else if i % 2 == 0 { // Higher frequencies
                buffer[i] *= highFreqFactor
            }
        }
    }
    
    // TWEAKABLE PARAMETERS FOR GREEN NOISE (OCEAN WAVES):
    // - baseFactor: Controls the base level of white noise (0.1-0.5)
    //   Higher values = more background noise/hiss
    // - lowFreqFactor: Multiplier for low frequencies (1.0-2.5)
    //   Higher values = more bass/rumble like ocean waves
    // - midFreqFactor: Multiplier for mid frequencies (0.8-1.5)
    //   Higher values = more "wash" sound
    // - modulationSpeed: Controls the speed of volume fluctuations (500-10000)
    //   Lower values = slower/longer wave cycles
    // - modulationDepth: Controls how much the volume fluctuates (0.1-0.5)
    //   Higher values = more dramatic wave-like effect
    private func generateGreenNoise(buffer: inout [Float], samples: Int) {
        // Parameters for ocean-wave-like sound
        let baseFactor: Float = 0.3         // TWEAK THIS: 0.1-0.5
        let lowFreqFactor: Float = 2.0      // TWEAK THIS: 1.0-2.5
        let midFreqFactor: Float = 1.5      // TWEAK THIS: 0.8-1.5
        let modulationSpeed: Int = 2000     // TWEAK THIS: 500-10000 (lower = slower waves)
        let modulationDepth: Float = 0.1    // TWEAK THIS: 0.1-0.5 (higher = stronger waves)
        
        // Generate base white noise
        for i in 0..<samples {
            buffer[i] = Float.random(in: -baseFactor...baseFactor)
        }
        
        // Apply frequency filtering for ocean-like sound
        for i in 0..<samples {
            if i % 2 == 0 { // Low frequencies (more for ocean rumble)
                buffer[i] *= lowFreqFactor
            } else if i % 3 == 0 { // Mid frequencies (for wave wash sound)
                buffer[i] *= midFreqFactor
            }
            
            // Add slow modulation to create wave-like effect
            let modulationValue = sin(Float(i) / Float(modulationSpeed) * 2 * Float.pi)
            buffer[i] *= 1.0 + modulationValue * modulationDepth
        }
        
        // Apply smoothing to make it less harsh
        var smoothedBuffer = buffer
        let smoothingFactor: Int = 10
        for i in smoothingFactor..<samples {
            var sum: Float = 0
            for j in 0..<smoothingFactor {
                sum += buffer[i-j]
            }
            smoothedBuffer[i] = sum / Float(smoothingFactor)
        }
        
        buffer = smoothedBuffer
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func togglePlayback() {
        if isPlaying {
            audioPlayer?.stop()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func changeNoiseType(to type: NoiseType) {
        if type != currentNoiseType {
            generateNoise(type: type)
        }
    }
    
    func setVolume(_ newVolume: Float) {
        volume = newVolume
        audioPlayer?.volume = newVolume
    }
}
