//
//  KeyBoardCell.swift
//  KeyBoard
//  键盘CELL
//
//  Created by yangqianhua on 2018/2/24.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

//键盘CELL的代理
protocol KeyBoardCellDelegate:class {
    //CELL点击的代理
    func KeyBoardCellBtnClick(tag:Int)
}

class KeyBoardCell: UICollectionViewCell {
    
    //代理
    weak var delegate:KeyBoardCellDelegate?
    
    //提示视图
    private lazy var tipView = KeyBoardTipView()
    
    //键盘按钮
    lazy var keyboardBtn:UIButton = {
        //定义每个按键的按钮
        let btn = UIButton.init()
        
        //设置相关属性
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btn.backgroundColor = UIColor.white
        
        //设置圆角
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.frame = self.contentView.bounds
        
        //设置事件
        btn.addTarget(self, action: #selector(KeyboardBtnClick(button:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(KeyboardBtnTouchDown(button:)), for: .touchDown)
        btn.addTarget(self, action: #selector(KeyboardBtnTouchUpOutside(button:)), for: .touchUpOutside)
        
        return btn
    }()
    
    //键盘模型
    var model:KeyBoardModel?{
        didSet{
            //大写
            if(!(model?.isUpper ?? false) && self.tag > 9 + 100){
                self.keyboardBtn.setTitle(model?.key.lowercased(), for: .normal)
            }else{//小写
                self.keyboardBtn.setTitle(model?.key, for: .normal)
            }
            self.tipView.model = self.model
        }
    }
    
    /// 初始化
    ///
    /// - Parameter frame: frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加按钮
        self.contentView.addSubview(keyboardBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///加到window上后添加提示View，注意提示View是添加到Window上的
    override func willMove(toWindow newWindow: UIWindow?) {
        guard let w = newWindow else{
            return
        }
        
        //添加提示window，默认隐藏
        w.addSubview(tipView)
        tipView.isHidden = true
    }
}


// MARK: - 按钮相关的事件
extension KeyBoardCell{
    
    /// 按钮点击后手指松开
    ///
    /// - Parameter button: 按钮
    @objc private func KeyboardBtnClick(button:UIButton){
        //执行按钮点击事件
        self.delegate?.KeyBoardCellBtnClick(tag: self.tag - 100)
        
        //延时取消提示视图
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
            DispatchQueue.main.sync {
                self.tipView.isHidden = true
            }
        }
    }
    
    /// 按钮按下时的事件，按下时显示提示视图
    ///
    /// - Parameter button: 按钮
    @objc private func KeyboardBtnTouchDown(button:UIButton){
        tipView.isHidden = false
        var btnCenter = button.center
        btnCenter.y = self.bounds.height
        let center = self.convert(btnCenter, to: self.window)
        
        tipView.center = center
    }
    
    /// 按钮按下后在按钮外松开事件，松开后隐藏提示视图
    ///
    /// - Parameter button: 按钮
    @objc private func KeyboardBtnTouchUpOutside(button:UIButton){
       tipView.isHidden = true
    }
}
