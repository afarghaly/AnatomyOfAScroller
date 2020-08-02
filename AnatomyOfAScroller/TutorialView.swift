//
//  TutorialView.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import UIKit

class TutorialView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.65)

        let contentView = UIView()
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 4.0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        let tutorialLabel = UILabel()
        tutorialLabel.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 32.0 : 22.0, weight: .medium)
        tutorialLabel.text = "Pan sideways to scroll"
        tutorialLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
        tutorialLabel.textAlignment = .center
        tutorialLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tutorialLabel)

        let animationTrackWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 420.0 : 260.0
        let animationTrackHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 100.0 : 60.0
        let fingerViewDimension: CGFloat = animationTrackHeight

        let animationTrack = UIView()
        animationTrack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animationTrack)

        let fingerView = UIImageView(image: UIImage(named: "Hand"))
        fingerView.contentMode = .scaleAspectFit
        fingerView.translatesAutoresizingMaskIntoConstraints = false
        animationTrack.addSubview(fingerView)

        fingerView.widthAnchor.constraint(equalToConstant: fingerViewDimension).isActive = true
        fingerView.heightAnchor.constraint(equalToConstant: fingerViewDimension).isActive = true
        fingerView.topAnchor.constraint(equalTo: animationTrack.topAnchor).isActive = true
        let fingerPositionConstraint = fingerView.leadingAnchor.constraint(equalTo: animationTrack.leadingAnchor)
        fingerPositionConstraint.isActive = true


        animationTrack.widthAnchor.constraint(equalToConstant: animationTrackWidth).isActive = true
        animationTrack.heightAnchor.constraint(equalToConstant: animationTrackHeight).isActive = true
        animationTrack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        animationTrack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true

        tutorialLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        tutorialLabel.topAnchor.constraint(equalTo: animationTrack.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 30.0 : 14.0).isActive = true
        tutorialLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? -50.0 : -20.0).isActive = true

        // Start finger animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            animationTrack.layoutIfNeeded()
            UIView.animate(withDuration: 1.2, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                fingerPositionConstraint.constant = animationTrackWidth - fingerViewDimension
                animationTrack.layoutIfNeeded()
            }, completion: nil)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
