//
//  VehicleAccelerationIndicatorView.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

class VehicleAccelerationIndicatorNode: SKNode {

    private let barRect: CGRect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 8.0)
    private let borderShapeNode: SKShapeNode = SKShapeNode()
    private let fillShapeNode: SKShapeNode = SKShapeNode()

    // MARK: - Init

    override init() {
        super.init()

        borderShapeNode.strokeColor = SKColor.white
        borderShapeNode.fillColor = SKColor(white: 0.0, alpha: 0.5)
        borderShapeNode.lineWidth = 2.0
        addChild(borderShapeNode)
        borderShapeNode.path = CGPath(roundedRect: barRect, cornerWidth: barRect.height / 2.0, cornerHeight: barRect.height / 2.0, transform: nil)

        fillShapeNode.fillColor = SKColor(white: 1.0, alpha: 1.0)
        fillShapeNode.strokeColor = SKColor.clear
        fillShapeNode.lineWidth = 0.0
        addChild(fillShapeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VehicleAccelerationIndicatorNode

    func update(accelerationRate: CGFloat) {
        let barWidth = 100.0 * abs(accelerationRate)
        let fillX = accelerationRate > 0.0 ? 0.0 : (100.0 - barWidth)

        fillShapeNode.path = CGPath(roundedRect: CGRect(x: fillX, y: 0.0, width: barWidth, height: barRect.height), cornerWidth: barRect.height / 2.0, cornerHeight: barRect.height / 2.0, transform: nil)
    }
}
