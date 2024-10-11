//
//  CustomSliderView.swift
//  InstaStoryDemo
//
//  Created by macOS on 21/11/23.
//

import Foundation
import UIKit

class CustomSliderView: UIView {

    private let rectangleView: UIView = {
        let view = UIView()
        // Customize the rectangle view here
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        // Customize the label here
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        addSubview(rectangleView)
        addSubview(label)

        NSLayoutConstraint.activate([
            // Rectangle View Constraints
            rectangleView.widthAnchor.constraint(equalToConstant: 50),
            rectangleView.heightAnchor.constraint(equalToConstant: 30),
            rectangleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rectangleView.topAnchor.constraint(equalTo: topAnchor),

            // Label Constraints (centered inside the rectangle view)
            label.centerXAnchor.constraint(equalTo: rectangleView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: rectangleView.centerYAnchor),
        ])
    }

    // Public method to update the label text
    func updateLabelText(_ text: String) {
        label.text = text
    }
}


