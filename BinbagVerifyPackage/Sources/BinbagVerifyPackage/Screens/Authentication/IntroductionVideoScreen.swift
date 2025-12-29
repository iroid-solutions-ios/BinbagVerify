//
//  IntroductionVideoScreen.swift
//  BinbagVerifyPackage
//
//  Introduction video screen for BinbagVerify SDK
//

import UIKit
import AVKit

public class IntroductionVideoScreen: UIViewController {

    // MARK: - UI Elements
    private let videoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.23, green: 0.71, blue: 0.29, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Variables
    private let playerViewController = AVPlayerViewController()
    private var player: AVPlayer?

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupVideoPlayer()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(videoContainerView)
        view.addSubview(skipButton)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            // Video container - full screen
            videoContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Skip button - top right
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 80),
            skipButton.heightAnchor.constraint(equalToConstant: 40),

            // Continue button - bottom center
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        skipButton.addTarget(self, action: #selector(onSkip), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
    }

    private func setupVideoPlayer() {
        // Try to find video in package bundle
        if let videoURL = Bundle.module.url(forResource: "Intoduction", withExtension: "mp4") {
            setupPlayer(with: videoURL)
        } else {
            print("Video file not found in package bundle")
            // If video not found, show continue button immediately
            continueButton.isHidden = false
        }
    }

    private func setupPlayer(with url: URL) {
        player = AVPlayer(url: url)

        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.videoGravity = .resizeAspectFill

        addChild(playerViewController)
        videoContainerView.addSubview(playerViewController.view)
        playerViewController.view.frame = videoContainerView.bounds
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerViewController.didMove(toParent: self)

        player?.play()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }

    // MARK: - Actions
    @objc private func onSkip() {
        player?.pause()
        player = nil
        navigateToSignUp()
    }

    @objc private func onContinue() {
        player?.pause()
        player = nil
        navigateToSignUp()
    }

    @objc private func videoDidFinishPlaying(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.continueButton.isHidden = false
        }
    }

    private func navigateToSignUp() {
        let signUpVC = SignUpScreen()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
