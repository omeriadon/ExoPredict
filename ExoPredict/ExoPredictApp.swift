//
//  ExoPredictApp.swift
//  ExoPredict
//
//  Created by Adon Omeri on 17/9/2025.
//

import SwiftUI

@main
struct ExoPredictApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onAppear {
					print("[ExoPredictApp] Window appeared")
				}
		}
	}
}
