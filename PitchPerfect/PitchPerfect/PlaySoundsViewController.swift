//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Jain, Pranay (GE Healthcare) on 4/3/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        
        playAudioWithVariableRate(0.5)

    }

    @IBAction func playFastSound(sender: UIButton) {
        
        playAudioWithVariableRate(1.5)
        
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        
        playAudioWithVariablePitch (1000)
        
        }
    
    @IBAction func playDarthVaderSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var reverbPlayer = AVAudioPlayerNode()
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.LargeChamber)
        reverb.wetDryMix = 50
        
        audioEngine.attachNode(reverbPlayer)
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(reverbPlayer, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        reverbPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        reverbPlayer.play()
        
    }
    
    
    @IBAction func playEchoSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var echoPlayer = AVAudioPlayerNode()
        var echo = AVAudioUnitDelay()
        echo.delayTime = 0.6
        
        audioEngine.attachNode(echoPlayer)
        audioEngine.attachNode(echo)
        
        audioEngine.connect(echoPlayer, to: echo, format: nil)
        audioEngine.connect(echo, to: audioEngine.outputNode, format: nil)
        
        echoPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        echoPlayer.play()
    }
    
    
    func playAudioWithVariableRate (rate: Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    
    func playAudioWithVariablePitch (pitch: Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        
        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        pitchPlayer.play()
    }

    
    @IBAction func stopAllSound(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
