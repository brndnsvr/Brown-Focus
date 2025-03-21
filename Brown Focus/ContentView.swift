import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var selectedNoiseType: NoiseType = .brown
    
    var body: some View {
        ZStack {
            // Background that will fill entire window
            Color(NSColor.windowBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            // Main content container that centers in window
            VStack(spacing: 20) {
                Spacer().frame(height: 10)
                
                Text("Brown Focus")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Noise type selector
                Picker("Noise Type", selection: $selectedNoiseType) {
                    ForEach(NoiseType.allCases) { noiseType in
                        Text(noiseType.rawValue).tag(noiseType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedNoiseType) { _, newValue in
                    audioManager.changeNoiseType(to: newValue)
                }
                
                // Spacer to replace the removed description
                Spacer().frame(height: 10)
                
                // Play/Stop button
                Button(action: {
                    audioManager.togglePlayback()
                }) {
                    ZStack {
                        Circle()
                            .fill(selectedNoiseType.color.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: audioManager.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(audioManager.isPlaying ? .red : .green)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Text(audioManager.isPlaying ? "Playing" : "Stopped")
                    .font(.headline)
                
                Spacer()
                
                // Volume control
                HStack {
                    Image(systemName: "speaker.fill")
                        .foregroundColor(.secondary)
                    
                    Slider(
                        value: Binding<Double>(
                            get: { Double(audioManager.volume) },
                            set: { audioManager.setVolume(Float($0)) }
                        ),
                        in: 0...1
                    )
                    .frame(width: 150)
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 40)
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
            }
            .padding()
            .frame(minWidth: 350, minHeight: 400)
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding()
        }
    }
}

// Preview provider for SwiftUI canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
