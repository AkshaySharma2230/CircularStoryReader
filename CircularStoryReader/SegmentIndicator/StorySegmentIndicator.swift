//
//  StorySegmentIndicator.swift
//  CircularStoryReader
//
//  Created by Akshay Kumar on 31/05/23.
//

import UIKit

typealias Degrees = Double
typealias Radians = CGFloat

struct StorySegmentIndicatorSettings {
    var segmentsCount: Int = 0
    var segmentWidth: CGFloat = 2
    var spaceBetweenSegments: Degrees = 10
    var segmentColor: UIColor = UIColor.red
    var defaultSegmentColor: UIColor = UIColor(red: 219.0/255, green: 187.0/255, blue: 148.0/255, alpha: 1)
    var segmentBorderType: CAShapeLayerLineCap = .round
    var animationDuration: Double = 0.5
    var isStaticSegmentsVisible = true
    var startPointPadding: CGFloat = 0
}

class StorySegmentIndicator: UIView {
    
    private var segments: [CAShapeLayer] = []
    private var staticSegments: [CAShapeLayer] = []
    private var value: Radians = 0.0
    private var activeSegment: Int = 0
    var settings: StorySegmentIndicatorSettings = StorySegmentIndicatorSettings() {
        didSet {
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func toRadians(_ value: Degrees) -> Radians {
        return CGFloat(value) * .pi / CGFloat(180)
    }
    
    private func setup() {
        drawStaticSegments(stories: [])
        drawDynamicSegments()
    }
    
    private func drawDynamicSegments() {
        segments = []
        let emptySpace = Double(settings.segmentsCount) * settings.spaceBetweenSegments
        let emptySpaceInRadians = toRadians(emptySpace)
        let summedSpaceForSegments = 2 * Radians.pi - emptySpaceInRadians
        let spaceCorrelation = toRadians(Degrees((settings.segmentWidth)))
        let segmentSpace = summedSpaceForSegments / Radians(settings.segmentsCount) - spaceCorrelation
        let halfSpace = toRadians(settings.spaceBetweenSegments) / 2 + spaceCorrelation / 2
        let startPointPaddingInRadians = toRadians(Degrees(settings.startPointPadding))
        
        for segmentIndex in 0..<settings.segmentsCount {
            let index = CGFloat(segmentIndex)
            let startPoint = startPointPaddingInRadians + segmentSpace * index + halfSpace + 2 * halfSpace * index
            let endPoint = startPoint + segmentSpace
            let segmentShape = getSegment(startAngle: startPoint,
                                          endInAngle: endPoint,
                                          color: settings.segmentColor,
                                          strokeEnd: 0)
            segments.append(segmentShape)
            self.layer.addSublayer(segmentShape)
        }
    }
    
    
    func drawStaticSegments(stories: [StoryArray]?) {
        staticSegments = []
        guard settings.isStaticSegmentsVisible else {
            return
        }
        let spaceCorrelation = toRadians(Degrees((settings.segmentWidth)))
        let emptySpace = Double(settings.segmentsCount) * settings.spaceBetweenSegments
        let emptySpaceInRadians = toRadians(emptySpace)
        let summedSpaceForSegments = 2 * Radians.pi - emptySpaceInRadians
        let segmentSpace = summedSpaceForSegments / Radians(settings.segmentsCount) - spaceCorrelation
        let halfSpace = toRadians(settings.spaceBetweenSegments) / 2 + spaceCorrelation / 2
        let startPointPaddingInRadians = toRadians(Degrees(settings.startPointPadding))
        
        for segmentIndex in 0..<stories!.count  {
            let index = CGFloat(segmentIndex)
            let startPoint = startPointPaddingInRadians + segmentSpace * index + halfSpace + 2 * halfSpace * index
            let endPoint = startPoint + segmentSpace
            
            let defaultColor: UIColor
            if stories?[segmentIndex].seenType == 1 {
                defaultColor = UIColor(red: 219.0/255, green: 187.0/255, blue: 148.0/255, alpha: 1)
            } else {
                defaultColor = UIColor(red: 255.0/255, green: 71.0/255, blue: 32.0/255, alpha: 1)
            }
            
            let segmentShape = getSegment(startAngle: startPoint,
                                          endInAngle: endPoint,
                                          color: defaultColor,
                                          strokeEnd: 1)
            staticSegments.append(segmentShape)
            self.layer.addSublayer(segmentShape)
        }
    }
    
//    private func drawStaticSegments() {
//        staticSegments = []
//        guard settings.isStaticSegmentsVisible else {
//            return
//        }
//        let spaceCorrelation = toRadians(Degrees((settings.segmentWidth)))
//        let emptySpace = Double(settings.segmentsCount) * settings.spaceBetweenSegments
//        let emptySpaceInRadians = toRadians(emptySpace)
//        let summedSpaceForSegments = 2 * Radians.pi - emptySpaceInRadians
//        let segmentSpace = summedSpaceForSegments / Radians(settings.segmentsCount) - spaceCorrelation
//        let halfSpace = toRadians(settings.spaceBetweenSegments) / 2 + spaceCorrelation / 2
//        let startPointPaddingInRadians = toRadians(Degrees(settings.startPointPadding))
//
//        for segmentIndex in 0..<settings.segmentsCount {
//            let index = CGFloat(segmentIndex)
//            let startPoint = startPointPaddingInRadians + segmentSpace * index + halfSpace + 2 * halfSpace * index
//            let endPoint = startPoint + segmentSpace
//            let segmentShape = getSegment(startAngle: startPoint,
//                                          endInAngle: endPoint,
//                                          color: settings.defaultSegmentColor,
//                                          strokeEnd: 1)
//            staticSegments.append(segmentShape)
//            self.layer.addSublayer(segmentShape)
//        }
//    }
    
    private func getSegment(startAngle: Radians,
                            endInAngle: Radians,
                            color: UIColor,
                            strokeEnd: CGFloat) -> CAShapeLayer {
        let centre = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let beizerPath = UIBezierPath(arcCenter: centre,
                                      radius: bounds.height / 2 - settings.segmentWidth / 2,
                                      startAngle: startAngle,
                                      endAngle: endInAngle,
                                      clockwise: true)
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = beizerPath.cgPath
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.strokeEnd = strokeEnd
        segmentLayer.lineWidth = settings.segmentWidth
        segmentLayer.lineCap = settings.segmentBorderType
        segmentLayer.strokeColor = color.cgColor
        segmentLayer.strokeStart = 0.0
        return segmentLayer
    }
    
    private func updateProgressInLayer(progressLayer: CAShapeLayer,
                                       percent: CGFloat,
                                       segmentIndex: Int) {
        CATransaction.begin()
        self.activeSegment = segmentIndex
        let oldValue = value
        let newValue = percent
        value = newValue
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = oldValue
        animation.toValue = newValue
        animation.duration = settings.animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        progressLayer.add(animation, forKey: "line")
        CATransaction.commit()
    }
    
    private func drawPassedSegments(activeSegment: Int) {
        guard activeSegment > 0 else {
            return
        }
        for index in 0..<activeSegment {
            let layer = segments[index]
            layer.strokeEnd = 1.0
        }
    }
    
    private func drawSegmentToFull(index: Int, completion: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
           completion()
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.0
        animation.duration = settings.animationDuration / 2
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        segments[index].add(animation, forKey: "line")
        CATransaction.commit()
    }
    
    func updateProgress(percent: Degrees) {
        var validatedPercent = percent / 100
        if percent > 100 {
            validatedPercent = 1
        }
        let singlePart = 1 / Degrees(settings.segmentsCount)
        let activeSegment = Int(floor(validatedPercent / singlePart))
        drawPassedSegments(activeSegment: activeSegment)
        let newValueOnActiveSegment = (validatedPercent - singlePart * Degrees(activeSegment)) * Degrees(settings.segmentsCount)
        guard activeSegment < settings.segmentsCount else {
            updateProgressInLayer(progressLayer: segments[activeSegment - 1],
                                  percent: Radians(validatedPercent),
                                  segmentIndex: activeSegment - 1)
            return
        }
        if self.activeSegment != activeSegment {
            drawSegmentToFull(index: self.activeSegment, completion: {
                self.value = 0.0
                self.updateProgressInLayer(progressLayer: self.segments[activeSegment],
                                           percent: Radians(newValueOnActiveSegment),
                                           segmentIndex: activeSegment)
            })
        } else {
            updateProgressInLayer(progressLayer: segments[activeSegment],
                                  percent: Radians(newValueOnActiveSegment),
                                  segmentIndex: activeSegment)
        }
        
    }
    
}
