//
//  Brown_FocusApp.swift
//  Brown Focus
//
//  Created by Brandon Seaver on 3/21/25.
//

import SwiftUI

@main
struct Brown_FocusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 500)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .defaultSize(width: 400, height: 500)
    }
}

// This extension adds minimum size constraints to the window
extension NSWindow {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.minSize = NSSize(width: 400, height: 500)
    }
}
