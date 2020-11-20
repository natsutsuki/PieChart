//
//  LYCirclePieModel.swift
//  LYAdmin
//
//  Created by c.c on 2020/11/12.
//  Copyright © 2020 c.c. All rights reserved.
//

import UIKit

/// 填充饼状图用数据
struct LYPieData {
    
    /// 标题
    var title: String
    
    /// 副标题(下方、灰色)
    var detail: String?
    
    /// 百分比,取值0...1
    var percent: Double
    
}

/// 填充饼状图用 视觉效果
class LYPieVisual {
    
    var angles: Array<LYAnglePercent>
    var colors:[UIColor] = [#colorLiteral(red: 0.7960784314, green: 0.8705882353, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.6705882353, blue: 0.06666666667, alpha: 1), #colorLiteral(red: 0.2392156863, green: 0.8431372549, blue: 1, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.831372549, blue: 0.05490196078, alpha: 1), #colorLiteral(red: 1, green: 0.4392156863, blue: 0.2392156863, alpha: 1)]
    
    /// 总百分比
    var totalPercent: Double = 0
    
    init(datas: Array<LYPieData>, colors: Array<UIColor>? = nil) {
        var start: Double = 0
        angles = Array<LYAnglePercent>()
        
        for index in 0..<datas.count {
            let data = datas[index]
            
            start = totalPercent
            totalPercent += data.percent
            
            let angle = LYAnglePercent(title: data.title, detail: data.detail, percentStart: start, percentLength: data.percent)
            angles.append(angle)
        }
        
        guard totalPercent <= 1 else { fatalError("总百分比 不能超过1") }
        
        if let newColors = colors, newColors.isEmpty == false {
            self.colors = newColors
        }
    }
    
    static let demo: LYPieVisual = {
        let tempColors = [#colorLiteral(red: 0.7960784314, green: 0.8705882353, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.6705882353, blue: 0.06666666667, alpha: 1), #colorLiteral(red: 0.2392156863, green: 0.8431372549, blue: 1, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.831372549, blue: 0.05490196078, alpha: 1), #colorLiteral(red: 1, green: 0.4392156863, blue: 0.2392156863, alpha: 1)]
        let tempDatas = [
            LYPieData(title: "A级", detail: "5%", percent: 0.05),
            LYPieData(title: "B级", detail: "15%", percent: 0.15),
            LYPieData(title: "C级", detail: "20%", percent: 0.2),
            LYPieData(title: "D级", detail: "20%", percent: 0.2),
            LYPieData(title: "E级", detail: "10%", percent: 0.1),
            LYPieData(title: "S级", detail: "30%", percent: 0.3)
        ]
        
        return LYPieVisual.init(datas: tempDatas, colors: tempColors)
    }()
    
}

/// 百分占比 转化为 弧度(弧度制)
struct LYAnglePercent {
    
    var title: String!
    
    var detail: String?
    
    /// 起始
    var percentStart: Double
    
    /// 长度
    var percentLength: Double
    
    /// 起始角(弧度)
    var startAngle: CGFloat {
        return CGFloat.pi * 2 * CGFloat(percentStart) - CGFloat.pi / 2
    }
    
    /// 结束角(弧度)
    var endAngle: CGFloat {
        return CGFloat.pi * 2 * CGFloat(percentStart + percentLength) - CGFloat.pi / 2
    }
    
    /// 角度转弧度
    private func degreeToRadian(_ degree: CGFloat) -> CGFloat {
        return degree * CGFloat.pi / 180.0
    }
    
    /// 给定长度 算出中点延长线 方向，偏移量
    func getTranslation(newRadius: CGFloat) -> CGSize {
        // 算出度数 = (总度数 - 起始度数) / 2 + 起始度数
        let targetAngle = startAngle + (endAngle - startAngle) / 2
        
        let xPos = cos(targetAngle) * newRadius
        let yPos = sin(targetAngle) * newRadius
        
        return CGSize(width: xPos, height: yPos)
    }
    
}
