//
//  UltimateProgressBar.swift
//  CircleProgressBar
//
//  Created by Ethan Chu on 2018/2/9.
//  Copyright © 2018年 Ethan Chu. All rights reserved.
//

import UIKit

protocol ProgressBarExtension {
    func SetUpProgressBar(frame: CGRect)
    func SetUpProgressBar(frame: CGRect, radius: CGFloat, lineWidth: CGFloat)
    func Pulse()
    func UpdateProgress(percentage: CGFloat)
}

class UltimateProgressBar: UIView,ProgressBarExtension {
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let pulsingLayer = CAShapeLayer()
    let labelPercentage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    var outlineStrokeColor = UIColor(red: 234 / 255, green: 46 / 255, blue: 111 / 255, alpha: 1)
    var trackStrokeColor = UIColor(red: 56 / 255, green: 25 / 255, blue: 49 / 255, alpha: 1)
    var pulsatingFillColor = UIColor(red: 86 / 255, green: 30 / 255, blue: 63 / 255, alpha: 1)
    
    var radius: CGFloat = 90
    var lineWidth: CGFloat = 20
    
    var isPercentageLabelHiden = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetUpProgressBar(frame: CGRect) {
        let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsingLayer.path = path.cgPath
        pulsingLayer.strokeColor = UIColor.clear.cgColor
        pulsingLayer.lineWidth = lineWidth
        pulsingLayer.lineCap = kCALineCapRound
        pulsingLayer.fillColor = pulsatingFillColor.cgColor
        layer.addSublayer(pulsingLayer)
        
        trackLayer.path = path.cgPath
        trackLayer.strokeColor = trackStrokeColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.black.cgColor
        layer.addSublayer(trackLayer)
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = outlineStrokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        layer.addSublayer(shapeLayer)
        
        shapeLayer.position = .init(x: frame.width / 2, y: frame.height / 2)
        trackLayer.position = .init(x: frame.width / 2, y: frame.height / 2)
        pulsingLayer.position = .init(x: frame.width / 2, y: frame.height / 2)
        
        if !isPercentageLabelHiden {
            labelPercentage.frame = CGRect(x: frame.width / 2 - 40, y: frame.height / 2 - 25, width: 80, height: 50)
            addSubview(labelPercentage)
        }
    }
    
    func SetUpProgressBar(frame: CGRect, radius: CGFloat, lineWidth: CGFloat) {
        self.radius = radius
        self.lineWidth = lineWidth
        SetUpProgressBar(frame: frame)
    }
    
    func Pulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.8
        animation.toValue = 1.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        pulsingLayer.add(animation, forKey: "Pulsing")
    }
    
    func UpdateProgress(percentage: CGFloat) {
        shapeLayer.strokeEnd = percentage
        labelPercentage.text = "\(Int(percentage * 100))%"
    }
    
}
