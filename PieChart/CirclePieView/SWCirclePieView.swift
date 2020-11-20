//
//  SWCirclePieView.swift
//  LYAdmin
//
//  Created by c.c on 2020/11/12.
//  Copyright © 2020 c.c. All rights reserved.
//

import SwiftUI

struct SWCirclePieView: UIViewRepresentable {
    
    typealias UIViewType = LYCirclePieView
    
    var visual:LYPieVisual
    
    func makeUIView(context: Context) -> LYCirclePieView {
        let pieView = LYCirclePieView(frame: CGRect(x: 0, y: 0, width: 330, height: 270))
        pieView.pieVisual = visual
        pieView.backgroundColor = UIColor.white
        
        return pieView
    }
    
    func updateUIView(_ uiView: LYCirclePieView, context: Context) {
        
    }
    
}

struct TJCirclePieView_Previews: PreviewProvider {
    static var previews: some View {
        SWCirclePieView(visual: LYPieVisual(
            datas: [
                
            ],
            colors: nil
        ))
        .previewLayout(PreviewLayout.fixed(width: 330, height: 270))
    }
}
