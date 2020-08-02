//
//  ScrollingNode.swift
//  AnatomyOfAScroller
//
//  Created by Ahmed on 8/2/20.
//

import SpriteKit

enum ScrollingNodeType {
    case foreground
    case midground
    case background
    case distantBackground

    var isPhysicalNode: Bool { return self == .foreground }
}

protocol ScrollingNodeDelegate: class {
    func configure(pageNode node: PageNode, for index: Int, nodeType: ScrollingNodeType)
}

class ScrollingNode: SKNode {

    // Type
    private var nodeType: ScrollingNodeType

    // Geometry
    private var nodeSize: CGSize

    // Parallax
    var scrollParallaxFactor: CGFloat
    var currentScrollPosition: CGFloat = 0.0
    private let scrollingNodesContainer = SKNode()

    // Tiling
    private var visiblePages = Set<PageNode>()
    private var recycledPages = Set<PageNode>()

    // Delegate
    weak var delegate: ScrollingNodeDelegate? {
        didSet {
            tilePages()
        }
    }

    // MARK: - Init

    init(scrollParallaxFactor: CGFloat, nodeSize: CGSize, nodeType: ScrollingNodeType) {
        self.scrollParallaxFactor = scrollParallaxFactor
        self.nodeSize = nodeSize
        self.nodeType = nodeType
        
        super.init()

        addChild(scrollingNodesContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ScrollingNode

    func scroll(to position: CGFloat) {
        currentScrollPosition = position * scrollParallaxFactor
        if !nodeType.isPhysicalNode {
            scrollingNodesContainer.position = CGPoint(x: currentScrollPosition, y: 0.0)
        }
        tilePages()
    }

    private func dequeueRecycledPage() -> PageNode? {
        guard let dequeuedPage = recycledPages.randomElement() else { return nil }
        dequeuedPage.removeAllChildren()
        return recycledPages.remove(dequeuedPage)
    }

    func tilePages() {
        // First needed page index can be calculated by using the currentXOffset property and dividing it by the scene's width, then flooring the result
        let firstNeededPageIndex: Int = Int(floor(-currentScrollPosition / nodeSize.width))

        // Last needed pageIndex can be calculated by taking the right-most "bounds" value, dividing it by the scene's width, then flooring the result
        let lastNeededPageIndex: Int = Int(floor((-currentScrollPosition + nodeSize.width - 1) / nodeSize.width))

        // Recycle no-longer needed pages
        for page in visiblePages {
            if page.pageIndex < firstNeededPageIndex || page.pageIndex > lastNeededPageIndex {
                page.removeAllChildren()
                recycledPages.insert(page)
                page.removeFromParent()
            }
        }
        visiblePages.subtract(recycledPages)

        // Add missing pages
        for i in firstNeededPageIndex...lastNeededPageIndex {
            if !isDisplayingPage(for: i) {
                let pageView = dequeueRecycledPage() ?? PageNode()
                pageView.pageIndex = i
                delegate?.configure(pageNode: pageView, for: i, nodeType: nodeType)
                pageView.position = CGPoint(x: CGFloat(i) * nodeSize.width, y: 0.0)
                scrollingNodesContainer.addChild(pageView)
                visiblePages.insert(pageView)
            }
        }
    }

    private func isDisplayingPage(for index: Int) -> Bool {
        var isDisplaying = false
        for page in visiblePages {
            if page.pageIndex == index {
                isDisplaying = true
                break
            }
        }
        return isDisplaying
    }
}
