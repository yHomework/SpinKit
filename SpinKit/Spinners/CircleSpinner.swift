//
//  FancyClassicSpinner.swift
//  SpinKit
//
//  Created by Fernando Moya de Rivas on 17/01/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

/**
 Spinner composed by bouncing dots placed in a circle path.
 */
public class CircleSpinner: Spinner {

    var circleLayers = [CAShapeLayer]()
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        
        (0..<16).forEach { _ in
            let circleLayer = CAShapeLayer()
            circleLayers.append(circleLayer)
            layer.addSublayer(circleLayer)
        }

    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        circleLayers.forEach { $0.fillColor = isTranslucent ? primaryColor.cgColor : UIColor.white.cgColor }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.width / 2,
                             y: bounds.height / 2)
        let circleSize = CGSize(width: 0.7 * contentSize.width / CGFloat(circleLayers.count / 3),
                                height: 0.7 * contentSize.height / CGFloat(circleLayers.count / 3))
        let radius = (contentSize.width - circleSize.width) / 2
        circleLayers.enumerated().forEach { tupple in
            let layer = tupple.element
            let index = Double(tupple.offset)
            layer.path = UIBezierPath(ovalIn: CGRect(origin: .zero,
                                                  size: circleSize)).cgPath
            layer.bounds = layer.path!.boundingBox
            layer.position = CGPoint(x: center.x + radius * CGFloat(cos(index * Double.pi / 8)),
                                     y: center.y + radius * CGFloat(sin(index * Double.pi / 8)))
        }
        
    }
    
    override public func startLoading() {
        super.startLoading()
        
        let circleSize = circleLayers.first!.bounds.size
        let transform = NSValue(caTransform3D: CATransform3DConcat(CATransform3DScale(CATransform3DIdentity, 0, 0, 1),
                                                                   CATransform3DTranslate(CATransform3DIdentity,
                                                                                          circleSize.width / 2,
                                                                                          circleSize.width / 2, 0)))
        
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        scaleAnim.fromValue = transform
        scaleAnim.toValue = CATransform3DIdentity
        scaleAnim.repeatCount = .infinity
        scaleAnim.autoreverses = true
        scaleAnim.fillMode = .backwards
        scaleAnim.timingFunction = .init(name: .easeOut)
        scaleAnim.duration = 0.7
        
        circleLayers.enumerated().forEach {
            scaleAnim.beginTime = CACurrentMediaTime() + 2 * Double($0.offset) * scaleAnim.duration / Double(circleLayers.count)
            $0.element.add(scaleAnim, forKey: nil)
        }
    }

}
