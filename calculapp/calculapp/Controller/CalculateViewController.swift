//
//  CalculateViewController.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/23.
//

import UIKit

class CalculateViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calculatedView: UILabel!
    @IBOutlet weak var copyBtn: UIView!
    @IBOutlet var editBtn: UIBarButtonItem!
    
    var doneButton: UIBarButtonItem?
    var forms = [Form]() {
        didSet{
            self.saveData()
        }
    }
    
    var calculated : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        copyBtn.layer.cornerRadius = 10
        print("CalculateViewController Load")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadData()
    }
    
    //done 버튼을 눌렀을때 실행됨
    @objc func doneButtonTap(){
        //edit 버튼으로 바꿈
        self.navigationItem.leftBarButtonItem = self.editBtn
        //편집창 닫음
        self.tableView.setEditing(false, animated: true)
    }
    
    func saveData(){
        let data = self.forms.map {
            [
                "title" : $0.title,
                "money" : $0.money,
                "done"  : $0.done
            ]
        }
        let UD = UserDefaults.standard
        UD.set(data, forKey: "DataBox")
    }
    func loadData(){
        let UD = UserDefaults.standard
        //https://zeddios.tistory.com/153
        guard let data = UD.object(forKey: "DataBox") as? [[String: Any]] else { return }
        self.forms = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let money = $0["money"] as? Int else { return nil }
            //guard let done = $0["done"] as? Bool else { return nil }
            return Form(title: title, money: money, done: false)
        }
    }
    
    @IBAction func tapAddBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "정산 목록 추가", message: nil, preferredStyle: .alert)
        let registBtn = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            
            guard let title = alert.textFields?[0].text else { return }
            guard let money = Int(alert.textFields?[1].text ?? "") else { return }
            let form = Form(title: title, money: money, done: false)
            self?.forms.append(form)
            self?.tableView.reloadData()
        })
        let cancleBtn = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(registBtn)
        alert.addAction(cancleBtn)
        alert.addTextField(configurationHandler: { inputText in
            inputText.placeholder = "정산항목을 입력하세요."
        })
        alert.addTextField(configurationHandler: { inputText in
            inputText.placeholder = "금액을 입력하세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapEditBtn(_ sender: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    @IBAction func tapCopyBtn(_ sender: UIButton) {
        self.navigationItem.leftBarButtonItem = self.doneButton
    }
}

extension CalculateViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let form = self.forms[indexPath.row]
        cell.textLabel?.text = form.title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: form.money))
        
        cell.detailTextLabel?.text = ("\(result!) 원")
        if form.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       //선택한 항목을 배열에서 삭제
       self.forms.remove(at: indexPath.row)
       //선택한 항목을 테이블에서 삭제
       tableView.deleteRows(at: [indexPath], with: .automatic)
       
       if self.forms.isEmpty {
           self.doneButtonTap()
       }
   }
   //특정 위치의 행을 재정렬 할 수 있는지 묻는 메서드
   func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
       return true
   }
   //행이 다른 위치로 이동되면 어디에서 어디로 이동했는지 알려주는 메서드
   func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
       var forms  = self.forms
       //선택한 데이터를 저장, sourceIndexPath.row : 이동할 셀 번호
       let form = forms[sourceIndexPath.row]
       forms.remove(at: sourceIndexPath.row)
       //destinationIndexPath.row: 도착할 셀 위치
       forms.insert(form, at: destinationIndexPath.row)
       //배열 덮어쓰기
       self.forms = forms
   }
}

extension CalculateViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var form = self.forms[indexPath.row]
        form.done = !form.done
        self.forms[indexPath.row] = form
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        if form.done {
            calculated += form.money
        } else {
            calculated -= form.money
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: calculated))
        
        self.calculatedView.text = result
    }
}
