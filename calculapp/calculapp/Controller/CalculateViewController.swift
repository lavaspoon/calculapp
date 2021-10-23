//
//  CalculateViewController.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/23.
//

import UIKit

class CalculateViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var forms = [Form]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CalculateViewController Load")
        self.tableView.dataSource = self
    }
    
    @IBAction func tapAddBtn(_ sender: UIBarButtonItem) {
        //alert 작업
        let alert = UIAlertController(title: "정산 목록 추가", message: nil, preferredStyle: .alert)
        let registBtn = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            
            guard let title = alert.textFields?[0].text else { return }
            guard let money = alert.textFields?[1].text else { return }
            print("품목: \(title), 금액: \(money)")
            
            let form = Form(title: title, money: money)
            self?.forms.append(form)
            print(form)
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
    }
}

extension CalculateViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let form = self.forms[indexPath.row]
        print(form)
        cell.textLabel?.text = form.title
        cell.detailTextLabel?.text = ("\(form.money) 원")
        return cell
    }
    
}
