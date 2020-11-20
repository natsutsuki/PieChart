//
//  LYCirclePieView.swift
//  LYAdmin
//
//  Created by c.c on 2020/11/10.
//  Copyright © 2020 c.c. All rights reserved.
//

import UIKit

/// 饼状图
@IBDesignable
class LYCirclePieView: UIView {
    
    let centerRadius:CGFloat = 46
    let pieRadius:CGFloat = 77
    
    var pieVisual:LYPieVisual!
    
    var angles: Array<LYAnglePercent> {
        pieVisual.angles
    }
    
    var colors:[UIColor] {
        pieVisual.colors
    }
    
    let bottomColor: UIColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard pieVisual != nil else { return }
        
        let context = UIGraphicsGetCurrentContext()!
        let circleCenter = bounds.mid
        
        for index in 0..<angles.count {
            // 绘弧线
            draw(angle: angles[index], withColor: colors[index % colors.count], using: context)
        }
        
        // 如果没有angle 则单独绘制 0%
        // 如果有剩余 灰色补齐剩余
        if angles.count == 0 {
            drawZeroCicle(using: context)
        }
        else if pieVisual.totalPercent < 1 {
            let remaining = 1 - pieVisual.totalPercent
            let start = pieVisual.totalPercent
            
            let lastAngle = LYAnglePercent(title: nil, detail: nil, percentStart: start, percentLength: remaining)

            draw(angle: lastAngle, withColor: bottomColor, using: context)
        }
        
        context.move(to: circleCenter)
        context.addArc(center: circleCenter, radius: centerRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        context.closePath()
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fillPath()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 330, height: 270)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 330, height: 270)
    }
    
    private func getColor(_ index: Int) -> UIColor {
        return colors[index % colors.count]
    }
    
    // MARK: - Drawing
    
    /// 绘制弧线
    func draw(angle: LYAnglePercent, withColor color: UIColor, using context: CGContext) {
        let circleCenter = bounds.mid
        
        let path = UIBezierPath()
        path.move(to: circleCenter)
        path.addArc(withCenter: circleCenter, radius: pieRadius, startAngle: angle.startAngle, endAngle: angle.endAngle, clockwise: true)
        path.close()
        path.lineWidth = 3
        
        color.setFill()
        UIColor.white.setStroke()
        
        path.fill()
        path.stroke()
        
        // 绘外置点
        guard angle.title != nil else { return }
        
        let textTranslation = angle.getTranslation(newRadius: pieRadius + 15)
        let textStartPoint = CGPoint(
            x: circleCenter.x + textTranslation.width,
            y: circleCenter.y + textTranslation.height
        )
        
        context.move(to: textStartPoint)
        context.addArc(center: textStartPoint, radius: 4, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        context.closePath()
        
        context.setFillColor(color.cgColor)
        context.fillPath()
        
        // 延长线
        context.move(to: textStartPoint)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(1.5)
        
        // 折线
        let line_1_translation = angle.getTranslation(newRadius: pieRadius + 25)
        let line_1_point = CGPoint(
            x: circleCenter.x + line_1_translation.width,
            y: circleCenter.y + line_1_translation.height
        )
        
        // 平线
        let line_2_x_offset:CGFloat = line_1_translation.width > 0 ? 62:-62
        let line_2_point = CGPoint(
            x: line_1_point.x + line_2_x_offset,
            y: line_1_point.y
        )
        
        context.addLines(between: [textStartPoint, line_1_point, line_2_point])
        context.strokePath()
        
        // 上字
        let topText = NSAttributedString(
            string: angle.title,
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium),
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
        )
        
        let topTextSize = topText.size()
        let topTextPoint = CGPoint(
            x: line_2_point.x + (line_1_translation.width > 0 ? -topTextSize.width: 0),
            y: line_2_point.y - 5 - topTextSize.height
        )
        
        topText.draw(at: topTextPoint)
        
        // 下字
        guard let detailText = angle.detail else {
            return
        }
        
        let bottomText = NSAttributedString(
            string: detailText,
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium),
                NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel
            ]
        )
        
        let bottomTextSize = bottomText.size()
        let bottomTextPoint = CGPoint(
            x: line_2_point.x + (line_1_translation.width > 0 ? -bottomTextSize.width: 0),
            y: line_2_point.y + 3
        )
        
        bottomText.draw(at: bottomTextPoint)
    }
    
    /// 绘制 纯灰圈(0%)
    func drawZeroCicle(using context: CGContext) {
        let circleCenter = bounds.mid
        
        let path = UIBezierPath()
        path.move(to: circleCenter)
        path.addArc(withCenter: circleCenter, radius: pieRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.close()
        path.lineWidth = 3
        
        bottomColor.setFill()
        UIColor.white.setStroke()
        
        path.fill()
        
        // 三角函数
        let rad30 = 30.0 * CGFloat.pi / 180.0
        
        // 绘外置点
        let textStartPoint = CGPoint(
            x: circleCenter.x + (pieRadius + 15) * cos(rad30),
            y: circleCenter.y + (pieRadius + 15) * sin(rad30)
        )
        
        context.move(to: textStartPoint)
        context.addArc(center: textStartPoint, radius: 4, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        context.closePath()
        
        context.setFillColor(#colorLiteral(red: 1, green: 0.4392156863, blue: 0.2392156863, alpha: 1))
        context.fillPath()
        
        // 延长线
        context.move(to: textStartPoint)
        context.setStrokeColor(#colorLiteral(red: 1, green: 0.4392156863, blue: 0.2392156863, alpha: 1))
        context.setLineWidth(1.5)
        
        // 折线
        let line_1_point = CGPoint(
            x: circleCenter.x + (pieRadius + 25) * cos(rad30),
            y: circleCenter.y + (pieRadius + 25) * sin(rad30)
        )
        
        // 平线
        let line_2_x_offset:CGFloat = 62
        let line_2_point = CGPoint(
            x: line_1_point.x + line_2_x_offset,
            y: line_1_point.y
        )
        
        context.addLines(between: [textStartPoint, line_1_point, line_2_point])
        context.strokePath()
        
        // 上字
        let topText = NSAttributedString(
            string: "0%",
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium),
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            ]
        )
        
        let topTextSize = topText.size()
        let topTextPoint = CGPoint(
            x: line_2_point.x +  -topTextSize.width,
            y: line_2_point.y - 5 - topTextSize.height
        )
        
        topText.draw(at: topTextPoint)
    }
    
    // MARK: - nib
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.pieVisual = LYPieVisual.demo
    }
    
}


