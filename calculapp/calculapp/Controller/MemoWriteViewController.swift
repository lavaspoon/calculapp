//
//  MemoWriteViewController.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/30.
//

import UIKit

protocol MemoWriteViewDelegate : AnyObject {
    func didSelectRegister(diary : Diary)
}
class MemoWriteViewController: UIViewController {
//MARK: OUTLET SETTING
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var selectedDate : Date? = nil
    
    weak var delegate : MemoWriteViewDelegate?
    
//MARK: VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmButton.isEnabled = false
        configureContentsTextView() //contentsTextView 레이어 스타일
        configureDatePicker() //datePicker
        configureInputField() //등록버튼 활성화/비활성화
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
        trans.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        trans.locale = Locale(identifier: "ko_KR")
        self.selectedDate = datePicker.date
        self.dateTextField.text = trans.string(from: datePicker.date)
        //self.dateTextField.sendActions(for: .editingChanged)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
//MARK: ADD BUTTON SETTING
    private func configureInputField(){
        //입력할때마다 validateInputField() 함수 실행
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChanged(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChanged(_:)), for: .editingChanged)
        self.contentsTextView.delegate = self
    }
    private func validateInputField(){
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text.isEmpty)
    }
    @objc private func titleTextFieldDidChanged(_ textField: UITextField){
        self.validateInputField()
    }
    @objc private func dateTextFieldDidChanged(_ textField: UITextField) {
        self.validateInputField()
    }
//MARK: DELEGATE PATTERN - ADD BTN
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.selectedDate else { return }
        
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        //diary객체 전달
        self.delegate?.didSelectRegister(diary: diary)
        self.navigationController?.popViewController(animated: true)
        }
    }
//MARK: ADD BUTTON SETTING
extension MemoWriteViewController : UITextViewDelegate {
//텍스트뷰의 텍스트가 입력될때 마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
