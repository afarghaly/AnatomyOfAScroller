//
//  GameScene.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit
import AnatomyOfAScrollerContentProvider

class GameScene: SKScene {

    // Game layers
    private var foregroundLayer: ScrollingNode!
    private var midgroundLayer: ScrollingNode!
    private var backgroundLayer: ScrollingNode!
    private var distantBackgroundLayer: ScrollingNode!
    private var atmosphericLayer = SKNode()
    private var nonPhysicalScrollingGameLayers = [ScrollingNode]()

    private let themeParticleEffectNode: SKEmitterNode?

    // Theme
    private let theme: Theme
    private let vehicle: Vehicle
    private let contentProvider: ThemeContentProviding

    // Scrolling
    private var gestureStartPoint: CGPoint?
    private var currentAcceleration: CGFloat = 0.0

    private let vehicleAccelerationIndicatorNode = VehicleAccelerationIndicatorNode()

    // MARK: - Init

    init(size: CGSize, theme: Theme) {
        self.theme = theme
        self.contentProvider = theme.contentProvider
        self.vehicle = theme.vehicle
        themeParticleEffectNode = theme.themeParticleEffectNode

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SKScene

    override func sceneDidLoad() {
        super.sceneDidLoad()

        backgroundColor = SKColor.black

        atmosphericLayer = contentProvider.getAtmosphericNode()
        addChild(atmosphericLayer)

        distantBackgroundLayer = ScrollingNode(scrollParallaxFactor: 0.1, nodeSize: size, nodeType: .distantBackground)
        distantBackgroundLayer.delegate = self
        addChild(distantBackgroundLayer)
        backgroundLayer = ScrollingNode(scrollParallaxFactor: 0.2, nodeSize: size, nodeType: .background)
        backgroundLayer.delegate = self
        addChild(backgroundLayer)
        midgroundLayer = ScrollingNode(scrollParallaxFactor: 0.5, nodeSize: size, nodeType: .midground)
        midgroundLayer.delegate = self
        addChild(midgroundLayer)
        foregroundLayer = ScrollingNode(scrollParallaxFactor: 1.0, nodeSize: size, nodeType: ScrollingNodeType.foreground)
        foregroundLayer.delegate = self
        addChild(foregroundLayer)

        nonPhysicalScrollingGameLayers = [midgroundLayer, backgroundLayer, distantBackgroundLayer]

        vehicle.position = CGPoint(x: (size.width / 2.0), y: 200.0)
        addChild(vehicle)
        vehicle.setupPhysics()
        vehicle.vehicleParticleEffectNode?.targetNode = self

        let camera = SKCameraNode()
        camera.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        camera.xScale = theme.showsDebugMode ? 3.0 : 1.0
        camera.yScale = theme.showsDebugMode ? 3.0 : 1.0
        addChild(camera)
        self.camera = camera

        if theme.showsDebugMode {
            let viewportSize = CGSize(width: size.width / camera.xScale, height: size.height / camera.yScale)
            let viewportBorderNode = SKShapeNode(rect: CGRect(x: -viewportSize.width / 2.0, y: -viewportSize.height / 2.0, width: viewportSize.width, height: viewportSize.height))
            viewportBorderNode.strokeColor = SKColor.white
            viewportBorderNode.lineWidth = 2.0
            camera.addChild(viewportBorderNode)
        }

        if let themeParticleEffectNode = themeParticleEffectNode {
            themeParticleEffectNode.targetNode = self
            addChild(themeParticleEffectNode)
        }

        vehicleAccelerationIndicatorNode.alpha = 0.0
        camera.addChild(vehicleAccelerationIndicatorNode)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        gestureStartPoint = pos
        currentAcceleration = 0.0

        vehicleAccelerationIndicatorNode.alpha = 1.0
        vehicleAccelerationIndicatorNode.position = CGPoint(x: pos.x - 50.0, y: pos.y + 100.0)
    }
    
    func touchMoved(toPoint pos : CGPoint) {

        if let gestureStartPoint = gestureStartPoint {
            currentAcceleration = (pos.x - gestureStartPoint.x) / 100.0
            if currentAcceleration < -1.0 { currentAcceleration = -1.0 }
            if currentAcceleration > 1.0 { currentAcceleration = 1.0 }

            vehicleAccelerationIndicatorNode.update(accelerationRate: currentAcceleration)
            vehicleAccelerationIndicatorNode.position = CGPoint(x: pos.x - 50.0, y: pos.y + 100.0)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        gestureStartPoint = nil
        currentAcceleration = 0.0

        vehicleAccelerationIndicatorNode.alpha = 0.0
        vehicleAccelerationIndicatorNode.update(accelerationRate: 0.0)
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.randomElement(), let camera = camera else { return }
        touchDown(atPoint: touch.location(in: camera))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.randomElement(), let camera = camera else { return }
        touchMoved(toPoint: touch.location(in: camera))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.randomElement(), let camera = camera else { return }
        touchUp(atPoint: touch.location(in: camera))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.randomElement(), let camera = camera else { return }
        touchUp(atPoint: touch.location(in: camera))
    }

    // MARK: - Update

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        vehicle.accelerate(rate: currentAcceleration)

        let vehicleRelativePosition = CGPoint(x: self.convert(vehicle.body.position, to: self).x + (size.width / 2.0), y: 0.0)

        camera?.position = CGPoint(x: vehicleRelativePosition.x, y: size.height / 2.0)
        foregroundLayer.scroll(to: -vehicleRelativePosition.x + (size.width / 2.0))

        for layer in nonPhysicalScrollingGameLayers {
            layer.position.x = vehicleRelativePosition.x - (size.width / 2.0)
            layer.scroll(to: -vehicleRelativePosition.x + (size.width / 2.0))
        }
        atmosphericLayer.position.x = vehicleRelativePosition.x - (size.width / 2.0)

        theme.update(particleEffectNode: themeParticleEffectNode, size: size, vehicle: vehicle, vehicleRelativePosition: vehicleRelativePosition)
    }

    // MARK: - GameScene

    private func addDebugLabel(with color: SKColor, at point: CGPoint, to node: SKNode, for index: Int) {
        let labelNode = SKLabelNode(text: "\(index)")
        labelNode.horizontalAlignmentMode = .left
        labelNode.fontName = "Helvetica-Bold"
        labelNode.fontSize = 40.0
        labelNode.fontColor = color
        labelNode.position = point
        node.addChild(labelNode)
    }
}

extension GameScene: ScrollingNodeDelegate {
    func configure(pageNode node: PageNode, for index: Int, nodeType: ScrollingNodeType) {
        switch nodeType {
        case .foreground:
            let foregroundNode: SKNode = contentProvider.getForegroundBlock(for: index)
            node.addChild(foregroundNode)

        case .midground:
            let midgroundNode = contentProvider.getMidgroundBlock(for: index)
            node.addChild(midgroundNode)

        case .background:
            let backgroundNode = contentProvider.getBackgroundBlock(for: index)
            node.addChild(backgroundNode)

        case .distantBackground:
            let distantBackgroundNode = contentProvider.getDistantBackgroundBlock(for: index)
            node.addChild(distantBackgroundNode)
        }
    }
}
