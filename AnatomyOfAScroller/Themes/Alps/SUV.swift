//
//  SUV.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

class SUV : SKNode, Vehicle {
    var body: SKNode
    var currentSpeed: CGFloat = 0.0 {
        didSet {
            vehicleParticleEffectNode?.particleBirthRate = abs((currentSpeed * 0.8) / maxSpeed) * 200
        }
    }
    let maxSpeed: CGFloat = 12.0
    let maxAcceleration: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 100.0 : 60.0
    let vehicleParticleEffectNode = SKEmitterNode(fileNamed: "TireDustupParticle")

    var previousBodyX: CGFloat = 0.0

    let vehicleWheels: [VehicleWheel]

    // MARK: - Init

    override init() {
        body = SKSpriteNode(imageNamed: "suv-body")
        vehicleWheels = [VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "suv-wheel"),
                                      wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: 83.0, y: -46.0) : CGPoint(x: 55.0, y: -30.0),
                                      wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 30.0 : 20.0)),
                         VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "suv-wheel"),
                                      wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: -66.0, y: -46.0) : CGPoint(x: -44.6, y: -30.0),
                                      wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 30.0 : 20.0))]
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been impleneted")
    }

    // MARK: - SUV

    func setupPhysics() {
        let bodyPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIDevice.current.userInterfaceIdiom == .pad ? 256 : 160, height: 30))
        bodyPhysicsBody.restitution = 0.0
        body.physicsBody = bodyPhysicsBody
        addChild(body)

        vehicleWheels.forEach { wheel in
            wheel.wheelPhysicsBody.mass = 20.0
            wheel.wheelPhysicsBody.friction = 1.0
            wheel.wheelPhysicsBody.restitution = 0.0
            wheel.wheelPhysicsBody.angularDamping = 10.0

            wheel.wheelNode.position = wheel.wheelPosition
            wheel.wheelNode.physicsBody = wheel.wheelPhysicsBody

            addChild(wheel.wheelNode)

            if let scene = scene {
                let wheelRelativePosition = self.convert(wheel.wheelPosition, to: scene)
                let wheelJoint = SKPhysicsJointPin.joint(withBodyA: bodyPhysicsBody, bodyB: wheel.wheelPhysicsBody, anchor: wheelRelativePosition)
                scene.physicsWorld.add(wheelJoint)
            }
        }

        vehicleParticleEffectNode?.position = CGPoint(x: UIDevice.current.userInterfaceIdiom == .pad ? -64.0 : -39.0, y: UIDevice.current.userInterfaceIdiom == .pad ? -76.0 : -50.0)
        body.addChild(vehicleParticleEffectNode!)
    }
}
