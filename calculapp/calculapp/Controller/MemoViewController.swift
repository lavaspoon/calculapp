//
//  ChartViewController.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/23.
//

import UIKit

class MemoViewController: UIViewController {
//MARK: OUTLET SETTING
    @IBOutlet weak var collectionView: UICollectionView!
    private var diaryList = [Diary]()
//MARK: VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
//MARK: COLLECTION VIEW STYLE
    private func configureCollectionView() {
        //FlowLayout 인스턴스 대입
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //컨텐츠 간격 10
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    //화면에 날짜를 표시할때 사용
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
//MARK: DELEGATE PATTERN - SEGUE
    //세그웨이로 화면전환하기 때문에 prepare 메서드 실행 , MemoWriteViewController으로 화면이 전환될때 실행되는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //세그웨이로 이동하는 뷰컨트롤러가 무엇인지 작성
        if let MemoWriteViewController = segue.destination as? MemoWriteViewController {
            //delegate 위임
            MemoWriteViewController.delegate = self
        }
    }
}

//MARK: DELEGATE PATTERN
extension MemoViewController : MemoWriteViewDelegate {
    func didSelectRegister(diary : Diary) {
        self.diaryList.append(diary)
        collectionView.reloadData()
    }
}
//MARK: COLLECTION VIEW - DELEGATE
extension MemoViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    //cellForItemAt : 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() } //DiaryCell로 다운캐스팅, 다운캐스팅이 실패하면 빈 UICollection셀 반환되도록 구현
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}
extension MemoViewController : UICollectionViewDelegateFlowLayout {
    //셀의 사이즈를 설정하는 메서드
    func collectionView(_ collectionView: UICollectionView, layout UICollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}
