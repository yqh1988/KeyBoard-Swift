//
//  KeyBoardTipView.swift
//  KeyBoard
//  点击时的提示视图
//
//  Created by yangqianhua on 2018/2/24.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class KeyBoardTipView: UIImageView {
    
    //提示按钮
    private lazy var tipButton = UIButton()
    
    /// 设置MODEL
    var model:KeyBoardModel?{
        didSet{
            //大写
            if(!(model?.isUpper ?? false)){
                tipButton.setTitle(model?.key.lowercased(), for: .normal)
            }else{//小写
                tipButton.setTitle(model?.key, for: .normal)
            }
        }
    }
    
    /// 初始化
    init(){
        //图片
        let image = UIImage(named: "keyboard_magnifier", in: nil, compatibleWith: nil)
        super.init(image: image)
        
        //设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1);
        
        //设置按钮的锚点
        tipButton.layer.anchorPoint =  CGPoint(x: 0.5, y: 0);
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = self.bounds.width * 0.5

        //设置字体和属性
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        tipButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
