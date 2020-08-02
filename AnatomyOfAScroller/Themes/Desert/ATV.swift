//
//  ATV.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

class ATV: SKNode, Vehicle {
    var body: SKNode
    var currentSpeed: CGFloat = 0.0 {
        didSet {
            vehicleParticleEffectNode?.particleBirthRate = abs(currentSpeed / maxSpeed) * 200
        }
    }
    let maxSpeed: CGFloat = 13.0
    let maxAcceleration: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60.0 : 35.0
    let vehicleParticleEffectNode = SKEmitterNode(fileNamed: "TireDustupParticle")

    var previousBodyX: CGFloat = 0.0

    let vehicleWheels: [VehicleWheel]

    // MARK: - Init

    override init() {
        body = SKSpriteNode(imageNamed: "atv-body")
        vehicleWheels = [VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "atv-wheel"),
                                      wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: 75.0, y: -68.0) : CGPoint(x: 51.6, y: -47.3), wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 35 : 23.0)),
                         VehicleWheel(wheelNode: SKSpriteNode(imageNamed: "atv-wheel"),
                                      wheelPosition: UIDevice.current.userInterfaceIdiom == .pad ? CGPoint(x: -80.0, y: -68.0) : CGPoint(x: -53.2, y: -48.6),
                                      wheelPhysicsBody: SKPhysicsBody(circleOfRadius: UIDevice.current.userInterfaceIdiom == .pad ? 35 : 23.0))]
        super.init()

        vehicleParticleEffectNode!.particleColor = SKColor(red: 0.53, green: 0.18, blue: 0.16, alpha: 1.0)
        vehicleParticleEffectNode!.particleColorBlendFactor = 1.0
        vehicleParticleEffectNode!.particleColorSequence = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Vehicle
    
    func setupPhysics() {
        let bodyPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIDevice.current.userInterfaceIdiom == .pad ? 220.0 : 146.0, height: UIDevice.current.userInterfaceIdiom == .pad ? 50.0 : 33.3))
        bodyPhysicsBody.restitution = 0.0
        body.physicsBody = bodyPhysicsBody
        addChild(body)

        vehicleWheels.forEach { wheel in
            wheel.wheelPhysicsBody.mass = 10.0
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
        
        vehicleParticleEffectNode?.position = CGPoint(x: UIDevice.current.userInterfaceIdiom == .pad ? -70.0 : -50, y: UIDevice.current.userInterfaceIdiom == .pad ? -106.0 : -72)
        body.addChild(vehicleParticleEffectNode!)
    }
}
