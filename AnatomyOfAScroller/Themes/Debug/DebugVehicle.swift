//
//  DebugVehicle.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

class DebugVehicle: SKNode, Vehicle {
    var body: SKNode
    var currentSpeed: CGFloat = 0.0
    let maxSpeed: CGFloat = 10.0
    let maxAcceleration: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 16.0
    var vehicleParticleEffectNode: SKEmitterNode?

    var previousBodyX: CGFloat = 0.0

    let vehicleWheels: [VehicleWheel]

    // MARK: - Init

    override init() {
        body = SKSpriteNode(imageNamed: "debug-body")
        vehicleWheels = [VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "debug-wheel"), wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: 100.0, y: -3.0) : CGPoint(x: 70.0, y: -2.0), wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 37.5 : 25.0)),
                         VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "debug-wheel"), wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: -100.0, y: -3.0) : CGPoint(x: -70, y: -2.0), wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 37.5 : 25.0))]
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DebugVehicle

    func setupPhysics() {
        body.position = CGPoint(x: 0.0, y: UIDevice.current.userInterfaceIdiom == .pad ? -4 : -2)

        let bodyPhysicsBody = SKPhysicsBody(rectangleOf: UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 200.0, height: 6.0) : CGSize(width: 133.0, height: 4.0))
        bodyPhysicsBody.restitution = 0.0
        bodyPhysicsBody.mass = 2.0
        body.physicsBody = bodyPhysicsBody
        addChild(body)

        vehicleWheels.forEach { wheel in
            wheel.wheelPhysicsBody.mass = 3.0
            wheel.wheelPhysicsBody.restitution = 0.0
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
    }
}
