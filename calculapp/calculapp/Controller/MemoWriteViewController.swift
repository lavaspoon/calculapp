//
//  MemoWriteViewController.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/30.
//

import UIKit

class MemoWriteViewController: UIViewController {
//MARK: OUTLET SETTING
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var selectedDate : Date? = nil
   
//MARK: VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentsTextView() //contentsTextView 레이어 스타일
        configureDatePicker() //datePicker
    }
    
//MARK: STYLE SETTING
    private func configureContentsTextView(){
        self.contentsTextView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        self.contentsTextView.layer.borderWidth = 1
        self.contentsTextView.layer.cornerRadius = 5.0
    }
//MARK: DATE PICKER
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        //날짜를 선택할때 마다 함수 실행
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = datePicker
    }
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        print("datePickerValueDidChange() 실행됨")
        print("선택한 날짜: \(datePicker.date)")
        
        let trans = DateFormatter()
        trans.dateFormat = "yy년 MM월 dd일(EEEEE)"
        trans.locale = Locale(identifier: "ko_KR")
        self.selectedDate = datePicker.date
        self.dateTextField.text = trans.string(from: datePicker.date)
        //self.dateTextField.sendActions(for: .editingChanged)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
//MARK: ADD BUTTON SETTING
    
}
