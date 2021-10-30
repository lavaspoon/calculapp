//
//  MemoWriteViewController.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/30.
//

import UIKit

class MemoWriteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentsTextView() //contentsTextView 레이어 스타일
    }
    
//MARK: STYLE SETTING
    private func configureContentsTextView(){
        self.contentsTextView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        self.contentsTextView.layer.borderWidth = 1
        self.contentsTextView.layer.cornerRadius = 5.0
    }

}
