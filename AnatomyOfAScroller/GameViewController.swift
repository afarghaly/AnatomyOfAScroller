//
//  GameViewController.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    private var currentTheme: Theme!
    private let themeButton = UIButton(type: .custom)
    private let themeLabelString = "Theme: "

    // MARK: - UIViewController

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as! SKView? else { return }

        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        view.ignoresSiblingOrder = false

        let tutorialView = TutorialView(frame: view.bounds)
        view.addSubview(tutorialView)
        UIView.animate(withDuration: 1.0, delay: 4.0, options: [], animations: {
            tutorialView.alpha = 0.0
        }) { _ in
            tutorialView.removeFromSuperview()
        }

        themeButton.frame = CGRect(x: 10.0, y: 10.0, width: UIDevice.current.userInterfaceIdiom == .pad ? 160.0 : 110.0, height: UIDevice.current.userInterfaceIdiom == .pad ? 50.0 : 40.0)
        themeButton.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 8.0 : 6.0
        themeButton.layer.masksToBounds = true
        themeButton.titleLabel?.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 17.0 : 13.0, weight: .medium)
        themeButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        themeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(themeButton)

        loadTheme(theme: Theme.alps(view.bounds.size))
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - GameViewController

    private func loadTheme(theme: Theme) {
        guard let view = view as? SKView else { return }

        let scene: GameScene = GameScene(size: view.bounds.size, theme: theme)

        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        view.showsPhysics = theme.showsDebugMode

        currentTheme = theme
        updateThemeButton(with: theme)
    }

    private func updateThemeButton(with theme: Theme) {
        let themeName = theme.themeName
        let themeButtonTitle = themeLabelString + themeName
        let attributedTitleString = NSMutableAttributedString(string: themeButtonTitle)
        let rangeOfThemeLabel = themeButtonTitle.range(of: themeLabelString)
        attributedTitleString.addAttributes([.foregroundColor: UIColor(white: 1.0, alpha: 0.4)], range: NSRange(rangeOfThemeLabel!, in: themeButtonTitle))
        let rangeOfThemeName = themeButtonTitle.range(of: themeName)
        attributedTitleString.addAttributes([.foregroundColor: UIColor.white], range: NSRange(rangeOfThemeName!, in: themeButtonTitle))
        themeButton.setAttributedTitle(attributedTitleString, for: .normal)
    }

    // MARK: - Button

    @objc private func themeButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select a Theme:", message: nil, preferredStyle: .actionSheet)

        for theme in Theme.allCases(with: view.bounds.size) {
            if theme != currentTheme {
                let action = UIAlertAction(title: theme.themeName, style: .default) { [weak self] action in
                    self?.loadTheme(theme: theme)
                }
                alertController.addAction(action)
            }
        }

        if UIDevice.current.userInterfaceIdiom == .phone {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
        }

        present(alertController, animated: true, completion: {
            alertController.view.setNeedsLayout()
        })
    }
}
