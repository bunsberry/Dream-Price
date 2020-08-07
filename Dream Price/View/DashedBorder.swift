//
//  DashedBorder.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 22.07.2020.
//

import UIKit

extension UIView {
    func addDashedBorder(color: CGColor, lineWidth: CGFloat, patternLength: Float, cornerRadius: CGFloat) {
        let color = color

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        self.layer.borderColor = UIColor.secondaryLabel.cgColor

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 3
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        let ptLength = NSNumber(value: patternLength)
        let spLength = NSNumber(value: patternLength / 2)
        shapeLayer.lineDashPattern = [ptLength, spLength]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}
