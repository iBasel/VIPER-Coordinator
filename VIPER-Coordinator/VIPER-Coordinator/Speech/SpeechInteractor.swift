//
//  SpeechInteractor.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/26/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import Speech
import AVFoundation
import CoreData
import UIKit

class SpeechInteractor: Interactor {
	
	var editText: (([Segment]) -> Void)?
	var itemName: String?
	
	var audioEngine: AVAudioEngine?
	let speechRecognizer = SFSpeechRecognizer()
	let request = SFSpeechAudioBufferRecognitionRequest()
	var recognitionTask: SFSpeechRecognitionTask?
	var mostRecentlyProcessedSegmentDuration: TimeInterval = 0

	var speechRecognitionData: [Segment] = []
	
	init(audioEngine: AVAudioEngine = AVAudioEngine()) {
		self.audioEngine = audioEngine
	}
	
	var updateTranscription: ((String) -> Void)?
	
	func requestAndStartRecording(SpeechRecognizer: SFSpeechRecognizer.Type = SFSpeechRecognizer.self, updateTranscription: @escaping ((String) -> Void)) {
		SpeechRecognizer.requestAuthorization { (authStatus) in
			switch authStatus {
			case .authorized:
				do {
					try self.startRecording()
					self.updateTranscription = updateTranscription
				} catch let error {
					print("There was a problem starting recording: \(error.localizedDescription)")
				}
			case .denied:
				print("Speech recognition authorization denied")
			case .restricted:
				print("Not available on this device")
			case .notDetermined:
				print("Not determined")
			}
		}
	}
	

	func startRecording() throws {
		mostRecentlyProcessedSegmentDuration = 0
		
		guard let node = audioEngine?.inputNode else { return }
		let recordingFormat = node.outputFormat(forBus: 0)
		
		node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
			self.request.append(buffer)
		}
		
		audioEngine?.prepare()
		try audioEngine?.start()
		recognitionTask = speechRecognizer?.recognitionTask(with: request) { (result, _) in
			if let transcription = result?.bestTranscription {
				self.updateUIWithTranscription(transcription)
			}
		}
	}
	
	func stopRecording() {
		audioEngine?.inputNode.reset()
		audioEngine?.inputNode.removeTap(onBus: 0)
		audioEngine?.stop()
		request.endAudio()
		recognitionTask?.cancel()
	}
	
	func isRecording() -> Bool {
		return audioEngine?.isRunning ?? false
	}
	
	fileprivate func updateUIWithTranscription(_ transcription: SFTranscription) {
		
		updateTranscription?(transcription.formattedString)
		
		var segments: [Segment] = []
		
		transcription.segments.forEach({ (segment) in
			let delegate = UIApplication.shared.delegate as! AppDelegate
			let context = delegate.persistentContainer.viewContext
			if let segmentEntity = NSEntityDescription.entity(forEntityName: "Segment", in: context) {
				if let managedSegment = NSManagedObject(entity: segmentEntity, insertInto: context) as? Segment {
					managedSegment.text = segment.substring
					segments.append(managedSegment)
				}
			}
		})
		speechRecognitionData = segments
		
		if let lastSegment = transcription.segments.last, lastSegment.duration > mostRecentlyProcessedSegmentDuration {
			mostRecentlyProcessedSegmentDuration = lastSegment.duration
		}
	}
	
	func showEditorView() {
		editText?(speechRecognitionData)
	}
}
