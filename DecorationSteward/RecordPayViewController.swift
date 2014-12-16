//
//  RecordPayViewController.swift
//  DecorationSteward
//  
//  记录支出View Controller
//
//  Created by ruby on 14-11-9.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class RecordPayViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let CategoryTextFieldTag = 100
    
    @IBOutlet weak var payNavigationItem: UINavigationItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var shopTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var categoryPickerView: UIPickerView!
    
    var orders: Array<OrderItem> = Array<OrderItem>()
    var categorys: Dictionary<String, Array<String>> = Dictionary<String, Array<String>>()
    var firstCategoryArray: Array<String>!
    var secondCategoryArray: Array<String>!
    var firstSelectedString: String!
    var secondSelectedString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        addPickerView()
        // 设置Navigation right bar item
        self.rightBarButton.title = "完成"
        
        // 设置textFiled tag以便于区分
        self.categoryTextField.tag = CategoryTextFieldTag
        
        // 设置空间的代理到本Controller，也可以在IB中连线
        self.moneyTextField.delegate = self
        self.categoryTextField.delegate = self
        self.shopTextField.delegate = self
        self.phoneTextField.delegate = self
        self.addrTextField.delegate = self
        self.commentTextView.delegate = self
        
        // 从userDefault中读取所有的order
        self.orders = OrderArchiver().getOrdesFromUserDefault()
        
        // 从userDefault中读取所有的类别
        self.categorys = CategoryArchiver().getCategoryFromUserDefault()
        
        // 设置类别滚动轴
        self.firstCategoryArray = Array(self.categorys.keys)
        self.secondCategoryArray = self.categorys[self.firstCategoryArray[0]]
        self.firstSelectedString = self.firstCategoryArray[0]
        self.secondSelectedString = self.secondCategoryArray[0]
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPickerView() -> Void {
        self.categoryPickerView = UIPickerView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 216))
        self.categoryPickerView.backgroundColor = ColorScheme().pickerViewBackgroundColor
        
        // 创建toolbar
        var cancleButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "clickCancelButtonItem:")
        var flexibleButtionItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var okButtonItem: UIBarButtonItem = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: "clickOkButtonItem:")
        var toolbarArray = [cancleButtonItem, flexibleButtionItem, okButtonItem]
        var toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width, 44)) // Hard code tool bar height 44
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        toolbar.setItems(toolbarArray, animated: true)
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
        self.categoryPickerView.addSubview(toolbar)
        self.view.addSubview(self.categoryPickerView)

    }
    
    func clickCancelButtonItem(sender: AnyObject) {
        println("点击取消按钮")
    }
    
    func clickOkButtonItem(sender: AnyObject) {
        println("点击确定按钮")
    }
    
    func updateCategoryField(firstCategory: String, secondCategory: String) {
        self.categoryTextField.text = firstCategory + "-" + secondCategory
    }
    
    // 用户完成textField输入后收起键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        println("textFieldShouldReturn() 用户点击‘Done’收起键盘")
        return true
    }

    // 手势控制-点击空白处收起键盘
    @IBAction func tapGesture(sender: AnyObject) {
        self.view.endEditing(true)
        inView(self)
    }
    
    // 用户首次开始输输入时清空原内容
    func textViewDidBeginEditing(textView: UITextView) {
        if self.commentTextView.text == "点击输入备注" {
            self.commentTextView.text = nil
        }
    }
    
    // 用户完成表单输入
    @IBAction func finishRecord(sender: AnyObject) {
        println("finishRecord() 用户完成输入")
        
        // 取得表单信息
        var orderItem = OrderItem()
        orderItem.money = (self.moneyTextField.text as NSString).floatValue
        orderItem.category = self.categoryTextField.text
        orderItem.shop = self.shopTextField.text
        orderItem.phone = self.phoneTextField.text
        orderItem.addr = self.addrTextField.text
        orderItem.comment = self.commentTextView.text
        
        // 数据稽核
        if orderItem.money.isZero {
            var alertView = UIAlertView(title: "空值", message: "请输入正确的金额", delegate: self, cancelButtonTitle: "好的")
            alertView.show()
            
            return
        }
        if orderItem.category.isEmpty {
            var alertView = UIAlertView(title: "空值", message: "请选择一个类别", delegate: self, cancelButtonTitle: "好的")
            alertView.show()
            
            return
        }
        
        orders.append(orderItem)
        
        // 将订单信息写入UserDefaults
        OrderArchiver().saveOrdersToUserDefault(self.orders)
        
        println("金额：\(orderItem.money)")
        println("类别：\(orderItem.category)")
        println("商家：\(orderItem.shop)")
        println("电话：\(orderItem.phone)")
        println("地址：\(orderItem.addr)")
        println("备注：\(orderItem.comment)")
        
        // 记录后返回到上层
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func popView(sender: AnyObject) {
        func popAnimation() {
            self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height - 226, self.view.frame.width, 216)
        }
        
        UIView.animateWithDuration(0.3, animations: popAnimation)
    }
    
    func inView(sender: AnyObject) {
        func inAnimation() {
            self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 216)
        }
        UIView.animateWithDuration(0.3, animations: inAnimation)
    }
    
    // MARK: pickerView dataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(0 == component) {
            return self.firstCategoryArray.count;
        }
        else if(1 == component) {
            return self.secondCategoryArray.count
        }
    
        return 0
    }
    
    //MARK: pickerView Delegete
    
    // 设置每列显示值
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if 0 == component {
            return self.firstCategoryArray[row]
        }
        else if 1 == component {
            return self.secondCategoryArray[row]
        }
        
        return nil
    }
    
    // pickerView联动
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if 0 == component {
            self.secondCategoryArray = self.categorys[self.firstCategoryArray[row]]
            self.categoryPickerView.selectedRowInComponent(1)
            self.categoryPickerView.reloadComponent(1)
            self.categoryPickerView.selectRow(0, inComponent: 1, animated: true)
            self.firstSelectedString = self.firstCategoryArray[row]
            self.secondSelectedString = self.secondCategoryArray[0]
        }
        else if 1 == component {
            self.secondSelectedString = self.secondCategoryArray[row]
        }
        
        updateCategoryField(self.firstSelectedString, secondCategory: self.secondSelectedString)
    }
    
    
    //MARK: -textFieldDelegate
    
    // 点击textField弹出PickerView
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        KeyboardAccessory().moveUpViewIfNeeded(textField, view: self.view)
        
        if textField.tag == CategoryTextFieldTag {
            self.view.endEditing(true)
            popView(self)
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        KeyboardAccessory().restoreViewPositionIfNeeded(self.view)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        KeyboardAccessory().moveUpViewIfNeeded(textView, view: self.view)
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        KeyboardAccessory().restoreViewPositionIfNeeded(self.view)
        return true
    }
}

