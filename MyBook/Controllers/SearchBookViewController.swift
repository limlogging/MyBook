//
//  SearchBookViewController.swift
//  MyBook
//
//  Created by imhs on 5/3/24.
//

import UIKit
import Kingfisher
import CoreData

class SearchBookViewController: UIViewController {
    let recentlyViewedBooksCollectionViewItemSpacing: CGFloat = 0   //아이템 사이 간격
    let recentlyViewedBooksCollectionViewItemCnt: CGFloat = 1       //라인에 들어갈 아이템 수
    
    var bookData: Book?                 //api를 통해 받아온 정보를 담을 객체
    var bookViewLogList: [ViewLog] = []     //내가 선택했던 책 보기
    
    // MARK: - 최근 본 책의 title과 컬렉션뷰가 담길 뷰
    private var recentlyViewedBooksView: UIView = {
        let view = UIView()
//        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - 최근 본 책 타이틀
    private var recentlyViewedBooksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 본 책"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 최근 본 책 컬랙션 뷰
    private lazy var recentlyViewedBooksCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = self.recentlyViewedBooksCollectionViewItemSpacing
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - 검색 결과 타이틀과 검색결과 테이블뷰가 담길 뷰
    private var searchResultView: UIView = {
        let view = UIView()
//        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - 검색 결과 타이틀
    private var searchResultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 검색 결과 테이블 뷰
    private var searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSearchController() //서치 컨트롤러 설정
        setupCollectionView()   //컬렉션 뷰 설정
        setupTableView()        //테이블 뷰 설정
        setupAddView()          //뷰 추가
        setupAutoLayout()       //오토레이아웃 설정
        
        //checkRecentlyView()

        fetchEntityData()           //코어데이터에서 최근 본 책 데이터 가져오기
        
                
        print("최근 본 책 수 : \(fetchEntityDataCount())")
    }
    
    // MARK: - 최근 본 책 확인
    private func checkRecentlyView() {
        if bookViewLogList.count == 0 {
            print("최근 본 책 데이터 없음 ")
            recentlyViewedBooksView.isHidden = true
            
            NSLayoutConstraint.activate([
                //테이블 뷰와 타이틀을 담을 뷰
                //searchResultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ])
            
            
        } else {
            print("최근 본 책 데이터 있음 ")
            recentlyViewedBooksView.isHidden = false
            
            NSLayoutConstraint.activate([
                //테이블 뷰와 타이틀을 담을 뷰
                //searchResultView.topAnchor.constraint(equalTo: recentlyViewedBooksView.bottomAnchor, constant: 10),
            ])
        }
    }
    
//    // MARK: - 코어데이터 엔티티 전체 삭제하기
//    private func deleteEntityData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookViewLog")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//            print("최근 본 책 데이터 삭제 완료")
//
//            self.bookViewLogList = [] //배열 초기화
//            
//            DispatchQueue.main.async { [weak self] in
//                self?.recentlyViewedBooksCollectionView.reloadData()
//            }
//        } catch {
//            print("최근 본 책 데이터 삭제 실패: \(error.localizedDescription)")
//        }
//    }
    
    // MARK: - 코어데이터 엔티티의 데이터 수 가져오기
    private func fetchEntityDataCount() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookViewLog")
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("엔티티의 데이터 수를 가져오는데 실패했습니다.: \(error.localizedDescription)")
            return 0
        }
    }
    
    // MARK: - 코어데이터 엔티티의 데이터 가져오기
    private func fetchEntityData() {
        do {
            //배열 초기화
            bookViewLogList = []
            
            // 코어 데이터에서 BookWishList 엔티티의 모든 데이터를 가져오기
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request = NSFetchRequest<BookViewLog>(entityName: "BookViewLog")
            let result = try context.fetch(request)
             
            // 가져온 데이터를 WishList 구조체로 변환하여 배열에 추가
            for data in result {
                let viewLog = ViewLog(title: data.title ?? "",
                                      isbn: data.isbn ?? "",
                                      imgUrl: data.imgUrl ?? "", 
                                      date: data.insertDt ?? Date())
                bookViewLogList.append(viewLog)
            }
            
            // 날짜를 기준으로 내림차순으로 정렬
            bookViewLogList.sort(by: { $0.date > $1.date })
            
            //컬렉션 뷰 새로고침
            DispatchQueue.main.async { [weak self] in
                self?.recentlyViewedBooksCollectionView.reloadData()
            }
            print("bookViewLogList: \(bookViewLogList)")
        } catch {
            print("코어 데이터에서 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 코어데이터 중복 유무 확인
    private func checkOverlapData(title: String, isbn: String, imgUrl: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        // 중복 데이터 확인
        let fetchRequest: NSFetchRequest<BookViewLog> = BookViewLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND isbn == %@ AND imgUrl == %@", title, isbn, imgUrl)
        let results = try? context.fetch(fetchRequest)
        
        return results?.isEmpty ?? false
    }
    
    // MARK: - 배열에 입력
    private func insertBookLog(title: String, isbn: String, imgUrl: String, insertDt: Date) {
        let viewLog = ViewLog(title: title,
                              isbn: isbn,
                              imgUrl: imgUrl,
                              date: insertDt)
        bookViewLogList.append(viewLog)
                        
        // 날짜를 기준으로 내림차순으로 정렬
        bookViewLogList.sort(by: { $0.date > $1.date })
    }
    
    // MARK: - 최근 본 책 날짜만 업데이트
    private func updateEntityData(isbn: String, insertDt: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookViewLog> = BookViewLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        fetchRequest.resultType = .managedObjectResultType // 데이터를 모두 가져오도록 설정
        
        do {
            let result = try context.fetch(fetchRequest)
       
            if let bookViewLog = result.first {
                bookViewLog.insertDt = insertDt
                try context.save() // 변경된 내용을 저장
                print("날짜 업데이트에 성공했습니다.")
            }
        } catch {
            print("코어 데이터에서 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 최근 본 책 정보를 코어데이터에 입력
    private func insertEntityData(title: String, isbn: String, imgUrl: String, insertDt: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "BookViewLog", in: context) else { return }
        let viewLog = NSManagedObject(entity: entity, insertInto: context)
        viewLog.setValue(title, forKey: "title")
        viewLog.setValue(isbn, forKey: "isbn")
        viewLog.setValue(imgUrl, forKey: "imgUrl")
        viewLog.setValue(insertDt, forKey: "insertDt")
        
        try? context.save()
    }
    
    // MARK: - 코어데이터 삭제하기
    private func deleteEntityData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookViewLog> = BookViewLog.fetchRequest()
        
        // 입력 날짜를 기준으로 오름차순 정렬하여 가장 빠른 날짜 찾기
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "insertDt", ascending: true)]
        
        do {
            let insertDts = try context.fetch(fetchRequest)
            if let firstDt = insertDts.first {
                context.delete(firstDt)         // 가장 빠른 날짜를 삭제
                try context.save()              // 변경 사항을 저장
                bookViewLogList.removeLast()    // 배열의 마지막 인덱스 삭제
            } else {
                print("삭제할 이벤트가 없습니다.")
            }
        } catch {
            print("이벤트를 삭제하는데 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 최근 본 책 정보를 코어데이터에 입력
    private func checkEntityData(title: String, isbn: String, imgUrl: String) {
        //1. 중복된 데이터가 없는데 개수가 10개 미만이면 입력
        //2. 중복된 데이터가 없는데 개수가 10개면 가장 먼저 입력된 날짜를 찾아 삭제 후 입력
        //3. 중복된 데이터가 있으면 날짜 업데이트
        if checkOverlapData(title: title, isbn: isbn, imgUrl: imgUrl) { // 중복아님
            // 입력된 데이터가 10개 미만이면 입력
            if fetchEntityDataCount() < 10 {
                let date = Date()
                //코어데이터에 추가하기
                insertEntityData(title: title, isbn: isbn, imgUrl: imgUrl, insertDt: date)
                //배열에 입력하기
                insertBookLog(title: title, isbn: isbn, imgUrl: imgUrl, insertDt: date)
            } else {
                //10개 이상일때 가장 오래된 검색 날짜를 찾아 삭제 후 입력
                //오래된 날짜 삭제
                deleteEntityData()
                
                let date = Date()
                //코어데이터에 추가하기
                insertEntityData(title: title, isbn: isbn, imgUrl: imgUrl, insertDt: date)
                //배열에 입력하기
                insertBookLog(title: title, isbn: isbn, imgUrl: imgUrl, insertDt: date)
            }
        } else {
            //중복
            let date = Date()
            updateEntityData(isbn: isbn, insertDt: date)    //코어데이터 날짜 업데이트
            if let index = bookViewLogList.firstIndex(where: { $0.title == title && $0.isbn == isbn && $0.imgUrl == imgUrl }) {
                bookViewLogList[index].date = date  //배열에서도 날짜 업데이트 
            }
            // 날짜를 기준으로 내림차순으로 정렬
            bookViewLogList.sort(by: { $0.date > $1.date })
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            //컬렉션뷰와 레이블 담을 뷰
            recentlyViewedBooksView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            recentlyViewedBooksView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recentlyViewedBooksView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recentlyViewedBooksView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),   //view 높이의 20%로 설정
            
            //최근 본 책 타이틀
            recentlyViewedBooksTitleLabel.topAnchor.constraint(equalTo: recentlyViewedBooksView.topAnchor, constant: 10),
            recentlyViewedBooksTitleLabel.leadingAnchor.constraint(equalTo: recentlyViewedBooksView.leadingAnchor, constant: 10),

            //최근 본 책 컬렉션뷰
            recentlyViewedBooksCollectionView.topAnchor.constraint(equalTo: recentlyViewedBooksTitleLabel.bottomAnchor, constant: 10),
            recentlyViewedBooksCollectionView.leadingAnchor.constraint(equalTo: recentlyViewedBooksView.leadingAnchor, constant: 10),
            recentlyViewedBooksCollectionView.trailingAnchor.constraint(equalTo: recentlyViewedBooksView.trailingAnchor, constant: -10),
            recentlyViewedBooksCollectionView.bottomAnchor.constraint(equalTo: recentlyViewedBooksView.bottomAnchor, constant: -10),

            //테이블 뷰와 타이틀을 담을 뷰
            searchResultView.topAnchor.constraint(equalTo: recentlyViewedBooksView.bottomAnchor, constant: 10),
            searchResultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchResultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchResultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            //검색 결과 타이틀
            searchResultTitleLabel.topAnchor.constraint(equalTo: searchResultView.topAnchor, constant: 10),
            searchResultTitleLabel.leadingAnchor.constraint(equalTo: searchResultView.leadingAnchor, constant: 10),

            //검색 결과 테이블 뷰
            searchResultTableView.topAnchor.constraint(equalTo: searchResultTitleLabel.bottomAnchor, constant: 10),
            searchResultTableView.leadingAnchor.constraint(equalTo: searchResultView.leadingAnchor, constant: 10),
            searchResultTableView.trailingAnchor.constraint(equalTo: searchResultView.trailingAnchor, constant: -10),
            searchResultTableView.bottomAnchor.constraint(equalTo: searchResultView.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: - 뷰 추가
    private func setupAddView() {
        //최근 본 책
        view.addSubview(recentlyViewedBooksView)
        recentlyViewedBooksView.addSubview(recentlyViewedBooksTitleLabel)
        recentlyViewedBooksView.addSubview(recentlyViewedBooksCollectionView)

        //검색 결과
        view.addSubview(searchResultView)
        searchResultView.addSubview(searchResultTitleLabel)
        searchResultView.addSubview(searchResultTableView)
    }
    
    // MARK: - 테이블뷰 설정
    private func setupTableView() {
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier) //검색 결과 테이블뷰에서 사용할 Cell 등록
    }
    
    // MARK: - 컬렉션뷰 설정
    private func setupCollectionView() {
        recentlyViewedBooksCollectionView.dataSource = self
        recentlyViewedBooksCollectionView.delegate = self
        recentlyViewedBooksCollectionView.register(RecentlyViewedBooksCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyViewedBooksCollectionViewCell.identifier)    //최근 본 책 컬렉션 뷰에서 사용할 Cell 등록
    }
    
    // MARK: - UISearchController 설정
    private func setupSearchController() {
        //UISearchController 추가하기 (searchController에 searchBar 포함되어 있음)
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        self.navigationItem.title = "검색하기"
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title로 설정
        //searchController.hidesNavigationBarDuringPresentation = false //검색할때 title이 숨겨지는데 title을 계속 보이게하려면 false 설정
        //self.navigationItem.hidesSearchBarWhenScrolling = false //tableView 스크롤시 서치바가 사라지는데 계속보이게 하려면 false 설정
        searchController.searchBar.placeholder = "검색어를 입력하세요."
        
        //검색어 확인을 위해 SearchBar의 delegate를 SearchBookViewController로 설정
        searchController.searchBar.delegate = self
    }
}

// MARK: - 서치바 델리게이트 프로토콜 채택
extension SearchBookViewController: UISearchBarDelegate {
    // 사용자가 검색 버튼을 눌렀을 때 호출되는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print("검색어: \(searchText)")
            NetworkManager.shared.searchBook(query: searchText) { [weak self] result in
                switch result {
                case .success(let resultData):
                    self?.bookData = resultData
                    //검색 후 테이블 뷰 새로고침
                    DispatchQueue.main.async {
                        self?.searchResultTableView.reloadData()
                    }
                case .failure(let error):
                    print("데이터를 가져오는데 실패했습니다. \(error)")
                }
            }
        }
    }
}

// MARK: - 컬렉션뷰 데이터소스 프로토콜 채택
extension SearchBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookViewLogList.count
    }
    
    //최근 본 책 셀 데이터 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedBooksCollectionViewCell.identifier, for: indexPath) as? RecentlyViewedBooksCollectionViewCell else { return UICollectionViewCell() }
        
        //최근 본 책
        if let url = URL(string: bookViewLogList[indexPath.row].imgUrl) {
            DispatchQueue.main.async {
                cell.bookImageView.kf.setImage(with: url)
            }
        }
        
        //최근 본 책 이름
        cell.bookTitleLabel.text = bookViewLogList[indexPath.row].title
        
        return cell
    }
}

// MARK: - 컬렉션뷰 플로우 레이아웃 프로토콜 채택
extension SearchBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (recentlyViewedBooksCollectionView.bounds.height - (recentlyViewedBooksCollectionViewItemSpacing * (recentlyViewedBooksCollectionViewItemCnt - 1))) / recentlyViewedBooksCollectionViewItemCnt
        
        return CGSize(width: 100, height: height)
    }
}

// MARK: - 테이블뷰 데이터소스 프로토콜 채택
extension SearchBookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let book = bookData else { return 0 }
        
        return book.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        //책 이미지 불러오기
        if let urlString = bookData?.documents[indexPath.row].thumbnail {
            if let url = URL(string: urlString) {
                DispatchQueue.main.async {
                    cell.bookImageView.kf.setImage(with: url)
                }                
            }
        }
        cell.bookTitleLabel.text = bookData?.documents[indexPath.row].title //책 제목
        //저자
        let authors = bookData?.documents[indexPath.row].authors.joined(separator: ", ")
        cell.bookAuthorsLabel.text = authors
        
        cell.bookPublisherLabel.text = bookData?.documents[indexPath.row].publisher //출판사
        
        //책 가격
        if let price = bookData?.documents[indexPath.row].price {
            if price == 0 {
                cell.bookPriceLabel.text = "무료"
            } else {
                let numberFormatter: NumberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                if let formatPrice = numberFormatter.string(for: price) {
                    cell.bookPriceLabel.text = formatPrice + "원"
                }
            }
        }
        cell.bookContentsLabel.text = bookData?.documents[indexPath.row].contents   //책 소개
        
        return cell
    }
}

// MARK: - 테이블뷰 델리게이트 프로토콜 채택
extension SearchBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - tableView Cell을 선택했을때 화면 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailVC = BookDetailViewController()
//        bookDetailVC.tempTitle = bookData?.documents[indexPath.row].title               //책 제목
//        bookDetailVC.tempAuthors = bookData?.documents[indexPath.row].authors           //저자
//        bookDetailVC.tempTranslators = bookData?.documents[indexPath.row].translators       //번역
//        bookDetailVC.tempPublisher = bookData?.documents[indexPath.row].publisher       //출판사
//        bookDetailVC.tempImageView = bookData?.documents[indexPath.row].thumbnail       //책 이미지
//        bookDetailVC.tempSalePrice = bookData?.documents[indexPath.row].salePrice       //책 할인가
//        bookDetailVC.tempPrice = bookData?.documents[indexPath.row].price               //책 가격
//        bookDetailVC.tempContents = bookData?.documents[indexPath.row].contents         //책 소개
//        bookDetailVC.tempIsbn = bookData?.documents[indexPath.row].isbn                 //책 isbn
        
        bookDetailVC.tempDocument = bookData?.documents[indexPath.row]
        
        //최근 본 책 리스트에 추가
        if let title = bookData?.documents[indexPath.row].title,
           let isbn = bookData?.documents[indexPath.row].isbn,
           let imgUrl = bookData?.documents[indexPath.row].thumbnail {
            checkEntityData(title: title, isbn: isbn, imgUrl: imgUrl)
        }
        
        //최근 본 책 새로고침
        recentlyViewedBooksCollectionView.reloadData()
        
        present(bookDetailVC, animated: true, completion: nil)
    }
}
