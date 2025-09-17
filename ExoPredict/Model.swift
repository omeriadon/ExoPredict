//
//  Model.swift
//  ExoPredict
//
//  Created by Adon Omeri on 17/9/2025.
//

import CoreML

class Model {
	let model: ExoPredicter_Model

	init() {
		do {
			model = try ExoPredicter_Model(configuration: MLModelConfiguration())
		} catch {
			fatalError("Failed to load model: \(error)")
		}
	}

	func predict(
		koi_score: Double,
		koi_fpflag_nt: Double,
		koi_fpflag_ss: Double,
		koi_fpflag_co: Double,
		koi_fpflag_ec: Double,
		koi_period: Double,
		koi_time0bk: Double,
		koi_impact: Double,
		koi_duration: Double,
		koi_depth: Double,
		koi_prad: Double,
		koi_teq: Double,
		koi_insol: Double,
		koi_model_snr: Double,
		koi_tce_plnt_num: Double,
		koi_steff: Double,
		koi_slogg: Double,
		koi_srad: Double,
		koi_kepmag: Double
	) -> String? {
		do {
			let input = ExoPredicter_ModelInput(
				koi_score: koi_score,
				koi_fpflag_nt: Int64(koi_fpflag_nt),
				koi_fpflag_ss: Int64(koi_fpflag_ss),
				koi_fpflag_co: Int64(koi_fpflag_co),
				koi_fpflag_ec: Int64(koi_fpflag_ec),
				koi_period: koi_period,
				koi_time0bk: koi_time0bk,
				koi_impact: koi_impact,
				koi_duration: koi_duration,
				koi_depth: koi_depth,
				koi_prad: koi_prad,
				koi_teq: koi_teq,
				koi_insol: koi_insol,
				koi_model_snr: koi_model_snr,
				koi_tce_plnt_num: Int64(koi_tce_plnt_num),
				koi_steff: koi_steff,
				koi_slogg: koi_slogg,
				koi_srad: koi_srad,
				koi_kepmag: koi_kepmag
			)
			let output = try model.prediction(input: input)
			return output.koi_disposition
		} catch {
			print("Prediction failed: \(error)")
			return nil
		}
	}
}
