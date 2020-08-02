//
//  Vehicle.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

protocol Vehicle: SKNode {
    var body: SKNode { get }
    var currentSpeed: CGFloat { get set }
    var maxSpeed: CGFloat { get }
    var vehicleWheels: [VehicleWheel] { get }
    var previousBodyX: CGFloat { get set }
    var maxAcceleration: CGFloat { get }
    var vehicleParticleEffectNode: SKEmitterNode? { get }

    func setupPhysics()
    func accelerate(rate: CGFloat)
}

extension Vehicle {
    func accelerate(rate: CGFloat) {
        vehicleWheels.forEach { vehicleWheel in
            vehicleWheel.wheelPhysicsBody.applyTorque(-rate * maxAcceleration)
        }

        let currentBodyX = body.position.x
        currentSpeed = currentBodyX - previousBodyX
        previousBodyX = currentBodyX
    }
}
