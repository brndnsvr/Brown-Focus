# Brown Focus

A macOS application for generating ambient noise to improve focus and concentration.

## Features

- Multiple noise types:
  - **Brown Noise**: Deep, rumbling noise that reduces higher frequencies
  - **White Noise**: Equal intensity across all frequencies
  - **Grey Noise**: White noise adjusted to match human hearing perception
  - **Green Noise**: Ocean-like waves with gentle, periodic rhythm
- Simple, intuitive interface
- Volume control
- Real-time noise generation (not pre-recorded samples)

## Requirements

- macOS 12.0 or later
- Xcode 14.0 or later (for development)

## Installation

1. Clone the repository
2. Open `Brown Focus.xcodeproj` in Xcode
3. Build and run the application

## Usage

1. Launch the application
2. Select a noise type from the segmented control
3. Click the play button to start/stop the noise
4. Adjust the volume as needed

## How It Works

The application uses Swift and AVFoundation to generate different types of noise in real-time. Each noise type is mathematically generated with specific characteristics:

- **Brown Noise**: Integrates white noise with a 1/f² power spectrum
- **White Noise**: Random signal with equal intensity across all frequencies
- **Grey Noise**: White noise adjusted to match human hearing perception
- **Green Noise**: Designed to mimic ocean waves with modulation and frequency adjustments

## License

MIT