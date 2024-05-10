//
//  MyBookListViewController.swift
//  MyBook
//
//  Created by imhs on 5/3/24.
//

import UIKit
import SnapKit
import CoreData
import Kingfisher

class MyBookListViewController: UIViewController {
    private let collectionViewItemSpacing: CGFloat = 5
    private let collectionViewLineItemCnt: CGFloat = 3
    
    var myBookWishList: [WishList] = [] //코어데이터에서 불러온 데이터를 담을 변수
    
    // MARK: - 컬렉션뷰를 담을 뷰
    private var cvView: UIView = {
        let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - 담은 책 컬렉션 뷰
    lazy private var MyBookCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = collectionViewItemSpacing
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEntityData()         //코어데이터에서 데이터 가져오기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationButton()         //네비게이션 버튼 설정
        setupMyBookListCollectionView() //컬렉션 뷰 설정
        setupAddView()                  //뷰 추가 설정
        setupAutoLayout()               //오토레이아웃 설정
    }
    
    // MARK: - 네비게이션 버튼 설정
    func setupNavigationButton() {
        navigationItem.title = "담은 책 리스트"
        // 왼쪽 삭제 버튼 추가
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash , target: self, action: #selector(deleteButtonTapped))
        navigationItem.leftBarButtonItem = deleteButton
        // 오른쪽 추가 버튼 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - 담은 책 리스트 전체 삭제
    @objc func deleteButtonTapped() {
        let alertController = UIAlertController(title: "담은 책 리스트 삭제", message: "정말 삭제 하시겠습니까?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "삭제", style: .default) { [weak self] _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
    
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookWishList")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("담은 책 데이터 삭제 완료")
    
                self?.myBookWishList = [] //배열 초기화
                
                DispatchQueue.main.async { [weak self] in
                    self?.MyBookCollectionView.reloadData()
                }
            } catch {
                print("담은 책 데이터 삭제 실패: \(error.localizedDescription)")
            }
        }
        alertController.addAction(cancelButton)
        alertController.addAction(submitButton)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - 추가 버튼
    @objc func addButtonTapped() {
        
    }
    
    // MARK: - 컬렉션 뷰 설정
    func setupMyBookListCollectionView() {
        MyBookCollectionView.dataSource = self
        MyBookCollectionView.delegate = self
        MyBookCollectionView.register(MyBookListCollectionViewCell.self, forCellWithReuseIdentifier: MyBookListCollectionViewCell.identifier)
    }
    
    // MARK: - 뷰 추가 설정
    func setupAddView() {
        cvView.addSubview(MyBookCollectionView)
        view.addSubview(cvView)
    }
    
    // MARK: - 오토레이아웃 설정
    func setupAutoLayout() {
        // MARK: - 컬렉션 뷰를 담을 뷰
        cvView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // MARK: - 담은 책 컬렉션 뷰
        MyBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(cvView.snp.top).offset(10)
            make.leading.equalTo(cvView.snp.leading).offset(10)
            make.trailing.equalTo(cvView.snp.trailing).inset(10)
            make.bottom.equalTo(cvView.snp.bottom).inset(10)
        }
    }
    
    // MARK: - 코어데이터 데이터 가져오기
    private func fetchEntityData() {
        do {
            //배열 초기화
            myBookWishList = []
            
            // 코어 데이터에서 BookWishList 엔티티의 모든 데이터를 가져오기
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request = NSFetchRequest<BookWishList>(entityName: "BookWishList")
            let result = try context.fetch(request)
             
            // 가져온 데이터를 WishList 구조체로 변환하여 배열에 추가
            for data in result {
                let wishList = WishList(title: data.title ?? "",
                                        isbn: data.isbn ?? "",
                                        imgUrl: data.imgUrl ?? "")
                myBookWishList.append(wishList)
            }
            
            //컬렉션 뷰 새로고침
            DispatchQueue.main.async { [weak self] in
                self?.MyBookCollectionView.reloadData()
            }
            
            print("myBookWishList: \(myBookWishList)")
        } catch {
            print("코어 데이터에서 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
        }
    }
}

extension MyBookListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBookWishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBookListCollectionViewCell.identifier, for: indexPath) as? MyBookListCollectionViewCell else { return UICollectionViewCell() }
        
        if let url = URL(string: myBookWishList[indexPath.row].imgUrl) {
            DispatchQueue.main.async {
                cell.bookImageView.kf.setImage(with: url)
            }
        }
        cell.bookTilteLabel.text = myBookWishList[indexPath.row].title
        
        return cell
    }
}

extension MyBookListViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - 컬렉션 뷰 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (collectionViewItemSpacing * (collectionViewLineItemCnt - 1))) / collectionViewLineItemCnt
        return CGSize(width: width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(myBookWishList[indexPath.row].title)
    }
}
