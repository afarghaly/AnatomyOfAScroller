//
//  Jeep.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

class Jeep: SKNode, Vehicle {
    var body: SKNode
    var currentSpeed: CGFloat = 0.0 {
        didSet {
            vehicleParticleEffectNode?.particleBirthRate = abs(currentSpeed / maxSpeed) * 120.0
        }
    }
    let maxSpeed: CGFloat = 12.0
    let maxAcceleration: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 150.0 : 80.0
    let vehicleParticleEffectNode = SKEmitterNode(fileNamed: "JeepExhaustSmokeParticle")

    var previousBodyX: CGFloat = 0.0

    var vehicleWheels: [VehicleWheel] = []

    // MARK: - Init

    override init() {
        body = SKSpriteNode(imageNamed: "jeep-body")
        vehicleWheels = [VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "jeep-wheel"),
                                      wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: 98, y: -80) : CGPoint(x: 64, y: -52),
                                      wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 45 : 25)),
                         VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "jeep-wheel"),
                                      wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: -84, y: -80) : CGPoint(x: -54, y: -52),
                                      wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 45 : 25))]
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Vehicle

    func setupPhysics() {
        let bodyPhysicsBody = SKPhysicsBody(rectangleOf: UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 620.0, height: 50.0) : CGSize(width: 146.0, height: 33.3), center: CGPoint(x: UIDevice.current.userInterfaceIdiom == .pad ? 10.0 : 5.0, y: 0.0))
        bodyPhysicsBody.restitution = UIDevice.current.userInterfaceIdiom == .pad ? 1.1 : 0.9
        bodyPhysicsBody.mass = 90.0
        bodyPhysicsBody.friction = 0.0
        body.physicsBody = bodyPhysicsBody
        addChild(body)

        vehicleWheels.forEach { wheel in
            wheel.wheelPhysicsBody.mass = 20.0
            wheel.wheelPhysicsBody.restitution = UIDevice.current.userInterfaceIdiom == .pad ? 1.0 : 0.8
            wheel.wheelPhysicsBody.friction = 1.0
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

        vehicleParticleEffectNode?.position = UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: -143.0, y: -56.0) : CGPoint(x: -90, y: -35)
        body.addChild(vehicleParticleEffectNode!)
    }
}
