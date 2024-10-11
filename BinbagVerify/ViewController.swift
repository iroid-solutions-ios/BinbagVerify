//
//  ViewController.swift
//  BinbagVerify
//
//  Created by iRoid Dev on 20/07/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Variables
    let playerViewController = AVPlayerViewController()
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    func setUpInitialDetails(){
        self.setUpVideoPlayer()
    }
    
    @IBAction func onSkip(_ sender: UIButton) {
        self.player?.pause()
        self.player = nil
        if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "SignUpScreen") as? SignUpScreen {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onContinue(_ sender: UIButton) {
        self.player?.pause()
        self.player = nil
        if let vc = STORYBOARD.auth.instantiateViewController(withIdentifier: "SignUpScreen") as? SignUpScreen {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - Setup video Player
extension ViewController{
    
    func setUpVideoPlayer(){
        
        if let videoURL = Bundle.main.url(forResource: "Intoduction", withExtension: "mp4") {
            
            self.player = AVPlayer(url: videoURL)
            
            let playerFrame = CGRect(
                x: self.videoPlayerView.frame.minX,
                y: self.videoPlayerView.frame.minY,
                width: self.videoPlayerView.frame.width,
                height: self.videoPlayerView.frame.height
            )
            
            
            self.playerViewController.player = self.player
            self.playerViewController.view.frame = playerFrame
            self.playerViewController.view.frame = self.videoPlayerView.bounds
            
            addChild(playerViewController)
            self.videoPlayerView.addSubview(playerViewController.view)
            self.playerViewController.didMove(toParent: self)
            self.view.layoutIfNeeded()
            
            self.player?.play()
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidFinishPlaying(_:)),
                name: .AVPlayerItemDidPlayToEndTime,
                object: self.player?.currentItem
            )
            
        } else {
            print("Video file not found.")
        }
        
    }
    
    @objc func videoDidFinishPlaying(_ notification: Notification) {
        self.continueButton.isHidden = false
    }
    
}
