//
//  KeyBoardView.swift
//  KeyBoard
//
//  Created by yangqianhua on 2018/2/24.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

//屏幕的宽度
private let KSCREEN_WIDTH:CGFloat  = UIScreen.main.bounds.width

//键盘的高宽比
private let BOARDRATIO:CGFloat = 224.0 / 275.0

//按键的高宽比
private let KEYRATIO:CGFloat = 86.0  / 63.0

//键盘的高
private let KEYBOARD_HEIGHT:CGFloat = KSCREEN_WIDTH * BOARDRATIO

//按键的宽
private let BTN_WIDTH:CGFloat = KSCREEN_WIDTH / 10.0 - 6.0

//按键的高
private let BTN_HEIGHT:CGFloat = BTN_WIDTH * KEYRATIO

//item的高
private let ITEM_HEIGHT:CGFloat = BTN_HEIGHT + 10.0

//CELLID
private let CELL_ID = "KeyBoardCell"

//底部安全区高度
private let SAFE_BOTTOM:CGFloat = (UIScreen.main.bounds.height == 812.0) ? 34.0 : 0.0

//总高
private let TOTAL_HEIGHT:CGFloat = ITEM_HEIGHT * 4 + 10.0 + SAFE_BOTTOM

class KeyBoardView: UIView {

    //是否大写，默认不是大写，是小写
    private var isUp = false
    
    //输入源，如ITextFied、UITextView
    weak public var inputSource:UIView?
    
    //按键MODEL
    private lazy var modelArray = [KeyBoardModel]()
    
    //26个字母
    private lazy var letterArray = ["Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M"]

    ///第一、二行的布局
    lazy private var topView:UICollectionView = {
        //布局
        let flowLayout = self.collectionLayout()
        
        //设置UICollectionView
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: KSCREEN_WIDTH, height: ITEM_HEIGHT * 2), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(KeyBoardCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        return collectionView
    }()
    
    ///第三行的布局
    lazy private var middleView:UICollectionView = {
        //布局
        let flowLayout = self.collectionLayout()
        
        //设置UICollectionView
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: ITEM_HEIGHT * 2, width:  KSCREEN_WIDTH / 10.0 * 9, height: ITEM_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(KeyBoardCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        return collectionView
    }()
    
    
    ///第四行的布局
    lazy private var bottomView:UICollectionView = {
        //布局
        let flowLayout = self.collectionLayout()
        
        //设置UICollectionView
        let collectionView = UICollectionView.init(frame: CGRect.init(x: KSCREEN_WIDTH * 3.0 / 20.0, y: ITEM_HEIGHT * 3, width:  KSCREEN_WIDTH / 10.0 * 7.0, height: ITEM_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(KeyBoardCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        return collectionView
    }()
    
    /// 清除按钮
    lazy private var clearBtn:UIButton = {
        let btn = UIButton.init()
        //设置按钮属性
        btn.setImage(UIImage.init(named: "newdelete_a"), for: .normal)
        btn.setImage(UIImage.init(named: "newdelete_b"), for: .highlighted)
        btn.backgroundColor = UIColor.white
        
        //设置圆角
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        //设置位置
        btn.frame = CGRect.init(x: KSCREEN_WIDTH - 3 - BTN_WIDTH, y: TOTAL_HEIGHT - BTN_HEIGHT - 10 - BTN_HEIGHT - 10 - SAFE_BOTTOM, width: BTN_WIDTH, height: BTN_HEIGHT)
        
        //设置事件
        btn.addTarget(self, action: #selector(ClearBtnClick(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// 大小写转换按钮
    lazy private var upBtn:UIButton = {
        let btn = UIButton.init()
        //设置按钮属性
        btn.setImage(UIImage.init(named: "up_a"), for: .normal)
        btn.setImage(UIImage.init(named: "up_b"), for: .selected)
        btn.backgroundColor = UIColor.white
        
        //设置圆角
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        //设置位置
        btn.frame = CGRect.init(x: 3, y: TOTAL_HEIGHT - BTN_HEIGHT - 10 - SAFE_BOTTOM , width: BTN_HEIGHT, height: BTN_HEIGHT)
        
        //设置事件
        btn.addTarget(self, action: #selector(UpBtnClick(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// 完成按钮
    lazy private var doneBtn:UIButton = {
        let btn = UIButton.init()
        //设置按钮属性
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.backgroundColor = UIColor.white
        
        //设置圆角
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        //设置位置
        btn.frame = CGRect.init(x: KSCREEN_WIDTH - 3 - BTN_HEIGHT - 4, y: TOTAL_HEIGHT - BTN_HEIGHT - 10 - SAFE_BOTTOM , width: BTN_HEIGHT + 4, height: BTN_HEIGHT)
        
         //设置事件
        btn.addTarget(self, action: #selector(DoneBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    /// 初始化
    ///
    /// - Parameter frame: 位置
    init() {
        super.init(frame: .zero)
        //设置视图位置，键盘只在底部
        self.frame = CGRect.init(x: 0, y: 0, width: KSCREEN_WIDTH, height: TOTAL_HEIGHT)
        
        //设置数据
        self.setData()
        
        //设置UI
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置数据
extension KeyBoardView{
    
    /// 设置数据
    private func setData(){
        //默认小写
        self.isUp = false
        
        //添加1-9数字
        for i in 1..<10{
            self.modelArray.append(KeyBoardModel.init(key: "\(i)", isUpper: self.isUp))
        }
        
        //添加数字0
        self.modelArray.append(KeyBoardModel.init(key: "0", isUpper: self.isUp))
        
        //设置26个英文字母
        for i in 0..<26{
             self.modelArray.append(KeyBoardModel.init(key: self.letterArray[i], isUpper: self.isUp))
        }
    }
}

// MARK: - 设置UI
extension KeyBoardView{
    
    /// 设置UI
    private func setUp(){
        //设置背景色
        self.backgroundColor = UIColor.init(red: 210.0/255.0, green: 214.0/255.0, blue: 198.0/255.0, alpha: 1.0)
        
        //添加控件
        self.addSubview(self.upBtn)
        self.addSubview(self.clearBtn)
        self.addSubview(self.doneBtn)
        self.addSubview(self.topView)
        self.addSubview(self.middleView)
        self.addSubview(self.bottomView)
    }
    
    /// UICollectionView布局
    ///
    /// - Returns: UICollectionViewFlowLayout
    private func collectionLayout() -> UICollectionViewFlowLayout{
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 3, bottom: 0, right: 3)
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize.init(width: BTN_WIDTH, height: BTN_HEIGHT)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 6
        return flowLayout
    }
}

// MARK: - 按键点击代理实现
extension KeyBoardView : KeyBoardCellDelegate{
    func KeyBoardCellBtnClick(tag: Int) {
        //获取到MODEL
        let model = self.modelArray[tag]
        //大写，非数字
        if (!isUp && tag > 9){
            self.inputString(model.key.lowercased())
        }else{//小写
            self.inputString(model.key)
        }
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension KeyBoardView : UICollectionViewDelegate,UICollectionViewDataSource{
    
   public func numberOfSections(in collectionView: UICollectionView) -> Int{
        //顶部是两行，其余是一行
        if (collectionView == self.topView){
            return 2
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //前两行10个。第三行9个，第四行7个
        if (collectionView == self.topView){
            return 10
        }
        if (collectionView == self.middleView){
            return 9
        }
        
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取CELL
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! KeyBoardCell
        
        //获取index
        var index = indexPath.section * 10 + indexPath.item
        if (collectionView == self.middleView){
            index = 20 + indexPath.section * 10 + indexPath.item
        }else if (collectionView == self.bottomView){
            index = 29 + indexPath.section * 10 + indexPath.item
        }
        
        //设置TAG
        cell.tag = index + 100
        cell.delegate = self
        
        //获取并设置MODEL
        let model = self.modelArray[index]
        model.isUpper = self.isUp
        cell.model = model
        
        return cell
    }
}

extension KeyBoardView{
    
    /// 输入框输入文字
    ///
    /// - Parameter string: 输入的文字
    private func inputString(_ string:String){
        guard let inputSource = self.inputSource else {
            return
        }
        
        //UITextField
        if(inputSource.isKind(of: UITextField.self)){
            //获取输入空控件
            let tmp = inputSource as! UITextField
        
            //判断是否实现了代理，是否实现了shouldChangeCharactersIn代理
            if(tmp.delegate != nil && (tmp.delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) ?? false)){
                
                //当前输入框了的选择范围，默认时输入末尾
                var range = NSRange.init(location: tmp.text?.count ?? 0, length: 0)
                
                //有可能不是输入末尾，且选择了几个字符
                if let rag = tmp.selectedTextRange {
                    //光标偏移量，即选中开始位置
                    let currentOffset = tmp.offset(from: tmp.beginningOfDocument, to: rag.start)
                    //选中结束位置
                    let endOffset =  tmp.offset(from: tmp.beginningOfDocument, to: rag.end)
                    //选中字符长度
                    let length = endOffset - currentOffset
                    //选中范围
                    range = NSRange.init(location: currentOffset, length:length)
                }
                
                //代理是否允许输入字符
                let ret = tmp.delegate?.textField?(tmp, shouldChangeCharactersIn: range, replacementString: string) ?? false
                
                //允许输入字符时，输入字符
                if(ret){
                    tmp.insertText(string)
                }
            }else{
                //直接输入字符
                tmp.insertText(string)
            }
            
        }else if(inputSource.isKind(of: UITextView.self)){//和UITextView
            //获取输入空控件
            let tmp = inputSource as! UITextView
            
             //判断是否实现了代理，是否实现了shouldChangeTextIn代理
             if(tmp.delegate != nil && (tmp.delegate?.responds(to: #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) ?? false)){
                //当前输入框了的选择范围，默认时输入末尾
                var range = NSRange.init(location: tmp.text?.count ?? 0, length: 1)
                
                //有可能不是输入末尾，且选择了几个字符
                if let rag = tmp.selectedTextRange {
                    //光标偏移量，即选中开始位置
                    let currentOffset = tmp.offset(from: tmp.beginningOfDocument, to: rag.start)
                    //选中结束位置
                    let endOffset =  tmp.offset(from: tmp.beginningOfDocument, to: rag.end)
                    //选中字符长度
                    let length = endOffset - currentOffset
                    //选中范围
                    range = NSRange.init(location: currentOffset, length:length)
                }
                
                //代理是否允许输入字符
                let ret = tmp.delegate?.textView?(tmp, shouldChangeTextIn: range, replacementText: string) ?? false
                
                //允许输入字符时，输入字符
                if(ret){
                    tmp.insertText(string)
                }
            }else{
                //直接输入字符
                tmp.insertText(string)
            }
        }
    }
    
    /// 删除文字
    ///
    /// - Parameter button: 删除按钮
    @objc private func ClearBtnClick(_ button:UIButton){
        guard let inputSource = self.inputSource else {
            return
        }
        
        //UITextField和UITextView
        if(inputSource.isKind(of: UITextField.self)){
            let tmp = inputSource as! UITextField
            tmp.deleteBackward()
        }else if(inputSource.isKind(of: UITextView.self)){
            let tmp = inputSource as! UITextView
            tmp.deleteBackward()
        }
    }
    
    /// 大小写转换
    ///
    /// - Parameter button: 按钮
    @objc private func UpBtnClick(_ button:UIButton){
        //设置当前按钮不可以点击，防止重复点击
        button.isUserInteractionEnabled = false
        
        //大小写切换
        isUp = !isUp;
        button.isSelected = isUp
        
        //刷新数据
        self.middleView.reloadData()
        self.bottomView.reloadData()
        self.topView.reloadData()
        
        //设置当前按钮可以点击
        button.isUserInteractionEnabled = true
    }
    
    /// 完成按钮，点击关闭键盘
    ///
    /// - Parameter button: 按钮
    @objc private func DoneBtnClick(_ button:UIButton){
        guard let inputSource = self.inputSource else {
            return
        }
        inputSource.endEditing(true)
    }
}





















