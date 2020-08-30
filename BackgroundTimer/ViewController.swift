//
//  ViewController.swift
//  BackgroundTimer
//
//  Created by aora on 15-1-4.
//  Copyright (c) 2015年 Erik. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , AVAudioPlayerDelegate {

    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblInterval: UILabel!
    @IBOutlet weak var btnTimer: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var swPlaySound: UISwitch!
    
    
    var counter : Int = 0
    
    var counterTimer : Timer?
    var refreshTimer : Timer?
    
    var startDate : NSDate!
    var df : DateFormatter!
    
    var session : AVAudioSession!
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        df = DateFormatter();
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        session = AVAudioSession.sharedInstance();
        do {
            try session.setActive(true)
            try session.setCategory(.playback)
            let musicFile = Bundle.main.url(forResource: "918", withExtension: "mp3");
            audioPlayer = try AVAudioPlayer(contentsOf: musicFile!, fileTypeHint: nil)
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = -1;
        } catch {
            print("Failed to set audio session category.")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        refreshTimer?.invalidate();
        refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("refresh")), userInfo: nil, repeats: true)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        refreshTimer?.invalidate();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTimerClick(sender: UIButton) {
        let btn = sender;
        switch(btn.tag){
        case 0:
            startDate = NSDate()
            counter = 0;
            lblStartDate?.text = "开始时间:\(df.string(from: startDate as Date))"
            counterTimer?.invalidate();
            
            counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("countSecount")), userInfo: nil, repeats: true);
  
            
            btn.setTitle("Stop", for: .normal)
            
            btn.tag = 1;
            if swPlaySound.isOn {
                audioPlayer.play()
            }
            
        default:
            btn.tag = 0;
            //btn.titleLabel?.text = "Start"
            btn.setTitle("Start", for: .normal)
            counterTimer?.invalidate();
            
             audioPlayer.stop()
        }
    }
    
    func countSecount(){
        print("countSecount")
        counter += 1;
        lblCounter.text = "计数数值:\(counter)"
        let currentDate = NSDate()
        lblCurrentTime.text = "当前时间:\(df.string(from: currentDate as Date))"
        lblInterval.text = "流逝时间:\(Int(currentDate.timeIntervalSince(startDate as Date)))秒"
    }
    
    func refresh(){
        let currentDate = NSDate()
        lblCurrentTime.text = "当前时间:\(df.string(from: currentDate as Date))"
        if(btnTimer.tag == 1){
            lblInterval.text = "流逝时间:\(Int(currentDate.timeIntervalSince(startDate as Date)))秒"
        }
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        lblStatus.text = "audioPlayerBeginInterruption"
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        lblStatus.text = "audioPlayerDidFinishPlaying"
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!) {
        lblStatus.text = "audioPlayerEndInterruption"
    }

}

