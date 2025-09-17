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
			ZStack {
				List {}
					.listStyle(.sidebar)
				Form {
					Section("Flags") {
						Toggle("Not Transit-Like False Positive Flag", isOn: $koi_fpflag_nt)
						Toggle("FP Flag SS", isOn: $koi_fpflag_ss)
						Toggle("FP Flag CO", isOn: $koi_fpflag_co)
						Toggle("FP Flag EC", isOn: $koi_fpflag_ec)
					}

					Section("Planet properties") {
						propertySlider(title: "Disposition Score", value: $koi_score, range: 0 ... 1)
						propertySlider(title: "Orbital Period [days]", value: $koi_period, range: 0 ... 60)
						propertySlider(title: "Transit Epoch [BKJD]", value: $koi_time0bk, range: 0 ... 200)
						propertySlider(title: "Impact Parameter", value: $koi_impact, range: 0 ... 1)
						propertySlider(title: "Transit Duration [hrs]", value: $koi_duration, range: 0 ... 5)
						propertySlider(title: "Transit Depth [ppm]", value: $koi_depth, range: 0 ... 15000)
						propertySlider(title: "Planetary Radius [Earth radii]", value: $koi_prad, range: 0 ... 20)
						propertySlider(title: "Equilibrium Temperature [K]", value: $koi_teq, range: 0 ... 2000)
						propertySlider(title: "Insolation Flux [Earth flux]", value: $koi_insol, range: 0 ... 15000)
						propertySlider(title: "Transit Signal-to-Noise", value: $koi_model_snr, range: 0 ... 40)
						Stepper(value: $koi_tce_plnt_num, in: 1 ... 5) {
							Text("TCE Planet Number: \(koi_tce_plnt_num)")
								.contentTransition(.numericText())
								.animation(.default, value: koi_tce_plnt_num)
						}
						propertySlider(title: "Stellar Effective Temperature [K]", value: $koi_steff, range: 4000 ... 6500)
						propertySlider(title: "Stellar Surface Gravity [log10(cm/s**2)]", value: $koi_slogg, range: 3.5 ... 5.0)
						propertySlider(title: "Stellar Radius [Solar radii]", value: $koi_srad, range: 0.5 ... 2.0)
						propertySlider(title: "Kepler-band [mag]", value: $koi_kepmag, range: 10 ... 16)
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
					.buttonStyle(.glassProminent)
					.controlSize(.extraLarge)
					.buttonBorderShape(.capsule)
					.foregroundStyle(.white)

					Text("Prediction: \(modelWrapper.predictionResult ?? "")")
						.transition(.opacity)
						.font(.headline)
						.contentTransition(.numericText())
						.animation(.default, value: modelWrapper.predictionResult)

					if modelWrapper.isLoading {
						ProgressView("Loading model…")
					}

					if let error = modelWrapper.loadError {
						Text(error)
							.foregroundStyle(.red)
					}
				}
				.formStyle(.columns)
				.background(Color.clear)
				.navigationTitle("ExoPredict")
				.frame(minWidth: 335, maxWidth: 650)
				.padding()
				.onAppear {
					modelWrapper.loadModel()
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
			}
		}
	}

	@ViewBuilder
	private func propertySlider(title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
		HStack {
			Text(title)
			Slider(value: value, in: range)
			Text(String(format: "%.2f", value.wrappedValue))
				.contentTransition(.numericText())
				.animation(.default, value: value.wrappedValue)
		}
	}
}

#Preview {
	ContentView()
}
