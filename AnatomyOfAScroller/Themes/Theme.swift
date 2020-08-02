//
//  Theme.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit
import AnatomyOfAScrollerContentProvider

enum Theme: Equatable {

    case debug(CGSize?)
    case forest(CGSize)
    case desert(CGSize)
    case alps(CGSize)

    var themeName: String {
        switch self {
        case .debug: return "Debug"
        case .forest: return "Forest"
        case .desert: return "Desert"
        case .alps: return "Alps"
        }
    }

    var contentProvider: ThemeContentProviding {
        switch self {
        case .debug(let size): return DebugContentProvider(size: size!)
        case .forest(let size): return ForestContentProvider(size: size)
        case .desert(let size): return DesertContentProvider(size: size)
        case .alps(let size): return AlpsContentProvider(size: size)
        }
    }

    var vehicle: Vehicle {
        switch self {
        case .debug: return DebugVehicle()
        case .forest: return Jeep()
        case .desert: return ATV()
        case .alps: return SUV()
        }
    }

    var showsDebugMode: Bool {
        switch self {
        case .debug: return true
        default: return false
        }
    }

    var themeParticleEffectNode: SKEmitterNode? {
        switch self {
        case .alps: return SKEmitterNode(fileNamed: "AlpsSnowParticle")
        default: return nil
        }
    }

    func update(particleEffectNode: SKEmitterNode?, size: CGSize, vehicle: Vehicle, vehicleRelativePosition: CGPoint) {
        guard self == .alps(size), let particleEffectNode = particleEffectNode else { return }

        particleEffectNode.position = CGPoint(x: vehicleRelativePosition.x + ((size.width / 1.5) * (vehicle.currentSpeed / vehicle.maxSpeed)), y: size.height / 1.2)
        particleEffectNode.particlePositionRange = CGVector(dx: size.width + ((size.width * 1.5) * abs(vehicle.currentSpeed / vehicle.maxSpeed)), dy: size.height / 2.0)
        particleEffectNode.particleBirthRate = 100 + (200 * abs(vehicle.currentSpeed / vehicle.maxSpeed))
    }

    static func getRandomDefaultTheme(with size: CGSize) -> Theme {
        return [Theme.forest(size), Theme.desert(size), Theme.alps(size)].randomElement()!
    }

    // Enums with associated values do not easily conform to CaseIterable
    static func allCases(with size: CGSize) -> [Theme] {
        return[Theme.alps(size), Theme.desert(size), Theme.forest(size), Theme.debug(size)]
    }
}
