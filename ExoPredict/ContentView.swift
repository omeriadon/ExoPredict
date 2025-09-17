//
//  ContentView.swift
//  ExoPredict
//
//  Created by Adon Omeri on 17/9/2025.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var modelWrapper = ModelWrapper()

	@State private var koi_score: Double = 0.0
	@State private var koi_fpflag_nt: Bool = false
	@State private var koi_fpflag_ss: Bool = false
	@State private var koi_fpflag_co: Bool = false
	@State private var koi_fpflag_ec: Bool = false
	@State private var koi_period: Double = 0.0
	@State private var koi_time0bk: Double = 0.0
	@State private var koi_impact: Double = 0.0
	@State private var koi_duration: Double = 0.0
	@State private var koi_depth: Double = 0.0
	@State private var koi_prad: Double = 0.0
	@State private var koi_teq: Double = 0.0
	@State private var koi_insol: Double = 0.0
	@State private var koi_model_snr: Double = 0.0
	@State private var koi_tce_plnt_num: Int = 1
	@State private var koi_steff: Double = 5000
	@State private var koi_slogg: Double = 4.0
	@State private var koi_srad: Double = 0.9
	@State private var koi_kepmag: Double = 10.0

	var body: some View {
		NavigationStack {
			List {
				Section("Flags") {
					Toggle("FP Flag NT", isOn: $koi_fpflag_nt)
					Toggle("FP Flag SS", isOn: $koi_fpflag_ss)
					Toggle("FP Flag CO", isOn: $koi_fpflag_co)
					Toggle("FP Flag EC", isOn: $koi_fpflag_ec)
				}

				Section("Planet properties") {
					Slider(value: $koi_score, in: 0 ... 1, step: 0.001) {
						Text("KOI Score")
					}
					Slider(value: $koi_period, in: 0 ... 60, step: 0.001) {
						Text("Period (days)")
					}
					Slider(value: $koi_time0bk, in: 0 ... 200, step: 0.001) {
						Text("Time0bk")
					}
					Slider(value: $koi_impact, in: 0 ... 1, step: 0.001) {
						Text("Impact")
					}
					Slider(value: $koi_duration, in: 0 ... 5, step: 0.001) {
						Text("Duration")
					}
					Slider(value: $koi_depth, in: 0 ... 15000, step: 1) {
						Text("Depth")
					}
					Slider(value: $koi_prad, in: 0 ... 20, step: 0.01) {
						Text("Planet radius")
					}
					Slider(value: $koi_teq, in: 0 ... 2000, step: 1) {
						Text("Teq")
					}
					Slider(value: $koi_insol, in: 0 ... 15000, step: 1) {
						Text("Insolation")
					}
					Slider(value: $koi_model_snr, in: 0 ... 40, step: 0.01) {
						Text("Model SNR")
					}
					Stepper("TCE Planet Num: \(koi_tce_plnt_num)", value: $koi_tce_plnt_num, in: 1 ... 5)
					Slider(value: $koi_steff, in: 4000 ... 6500, step: 1) {
						Text("Stellar Teff")
					}
					Slider(value: $koi_slogg, in: 3.5 ... 5.0, step: 0.001) {
						Text("Stellar logg")
					}
					Slider(value: $koi_srad, in: 0.5 ... 2.0, step: 0.001) {
						Text("Stellar radius")
					}
					Slider(value: $koi_kepmag, in: 10 ... 16, step: 0.001) {
						Text("Kepler mag")
					}
				}

                Button("Predict KOI Disposition") {
					modelWrapper.predict(
						koi_score: koi_score,
						koi_fpflag_nt: koi_fpflag_nt ? 1.0 : 0.0,
						koi_fpflag_ss: koi_fpflag_ss ? 1.0 : 0.0,
						koi_fpflag_co: koi_fpflag_co ? 1.0 : 0.0,
						koi_fpflag_ec: koi_fpflag_ec ? 1.0 : 0.0,
						koi_period: koi_period,
						koi_time0bk: koi_time0bk,
						koi_impact: koi_impact,
						koi_duration: koi_duration,
						koi_depth: koi_depth,
						koi_prad: koi_prad,
						koi_teq: koi_teq,
						koi_insol: koi_insol,
						koi_model_snr: koi_model_snr,
						koi_tce_plnt_num: Double(koi_tce_plnt_num),
						koi_steff: koi_steff,
						koi_slogg: koi_slogg,
						koi_srad: koi_srad,
						koi_kepmag: koi_kepmag
					)
				}
				.disabled(modelWrapper.isLoading || modelWrapper.loadError != nil)
				.buttonStyle(.borderedProminent)

				if let result = modelWrapper.predictionResult {
					Text("Prediction: \(result)")
						.font(.headline)
				}

				if modelWrapper.isLoading {
					ProgressView("Loading model…")
				}

				if let error = modelWrapper.loadError {
					Text(error)
						.foregroundStyle(.red)
				}
			}
			.listStyle(.sidebar)
			.navigationTitle("ExoPredict")
		}
		.onAppear {
			modelWrapper.loadModel()
		}
	}
}

#Preview {
	ContentView()
}
