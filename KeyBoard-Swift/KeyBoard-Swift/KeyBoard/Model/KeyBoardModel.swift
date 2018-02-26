//
//  KeyBoardModel.swift
//  KeyBoard
//  键盘模型
//
//  Created by yangqianhua on 2018/2/24.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class KeyBoardModel:NSObject {

    //键盘上的字母或者数字
    var key = ""
    
    //是否是大写
    var isUpper = false
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - key: 键盘上的字母或者数字
    ///   - isUpper: 是否是大写
    init(key:String,isUpper:Bool) {
        self.key = key
        self.isUpper = isUpper
    }
    
}
