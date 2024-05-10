//
//  BookDetailViewController.swift
//  MyBook
//
//  Created by imhs on 5/5/24.
//

import UIKit
import Kingfisher
import CoreData

class BookDetailViewController: UIViewController {
//    var tempTitle: String?          //책 제목
//    var tempAuthors: [String]?      //저자
//    var tempTranslators: [String]?  //번역
//    var tempPublisher: String?      //출판사
//    var tempImageView: String?      //책 이미지
//    var tempPrice: Int?             //책 가격
//    var tempSalePrice: Int?         //책 세일 가격
//    var tempContents: String?       //책 소개
//    var tempIsbn: String?           //책 isbn
    
    var tempDocument: Documents? //검색화면에서 전달받은 데이터가 저장되는 변수
    
    // MARK: - 책 데이터가 담길 스크롤 뷰
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - 책 이미지
    private var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - 책 제목
    private var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "책 제목"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 저자와 번역 레이블을 담는 스택 뷰
    private var bookAuthorsTranslatorsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - 저자
    private var bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.text = "저자"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 번역
    private var bookTranslatorsLabel: UILabel = {
        let label = UILabel()
        label.text = "번역"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 할인율, 할인 가격, 정가를 담을 스택 뷰
    private var bookPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - 할인율
    private var bookDiscountLabel: UILabel = {
        let label = UILabel()
        label.text = "할인율"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 책 세일 가격
    private var bookSalePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "세일가"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 책 가격
    private var bookPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "정가"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 출판사
    private var bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.text = "출판사"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 책 소개 타이틀
    private var bookContentsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "책 소개"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 책 소개
    private var bookContentsLabel: UILabel = {
        let label = UILabel()
        label.text = "책 소개 내용"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    // MARK: - 버튼이 담길 뷰
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - 닫기 버튼
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white   //버튼의 색상
        button.backgroundColor = .darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 책 담기 버튼
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("책 담기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 닫기 및 담기 버튼이 담기는 스택 뷰
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        guard let title = tempTitle,
//           let authors = tempAuthors,
//           let translators = tempTranslators,
//           let publisher = tempPublisher,
//           let imageView = tempImageView,
//           let salePrice = tempSalePrice,
//           let price = tempPrice,
//           let contents = tempContents,
//           let isbn = tempIsbn else { return }
        guard let document = tempDocument else { return }
                
        bookTitleLabel.text = document.title
        bookAuthorsLabel.text = document.authors.joined(separator: ", ") + " 저자(글)"
 
        if document.translators.count == 0 {
            bookTranslatorsLabel.text = ""
        } else {
            bookTranslatorsLabel.text = document.translators.joined(separator: ", ") + " 번역"
        }
        bookPublisherLabel.text = document.publisher     //출판사
                
        if let url = URL(string: document.thumbnail) {
            DispatchQueue.main.async { [weak self] in
                self?.bookImageView.kf.setImage(with: url)
            }
        }

        let discountPercent = ((Double(document.price) - Double(document.salePrice)) / Double(document.price)) * 100
        let formattedDiscount = String(format: "%.0f%%", discountPercent)
        bookDiscountLabel.text = "\(formattedDiscount)"                         //할인율
        bookSalePriceLabel.text = setComma(number: document.salePrice) + "원"    //할인가
        let salePriceWithUnderline = addStrikethrough(to: setComma(number: document.price) + "원")
        bookPriceLabel.attributedText = salePriceWithUnderline      //정가
        bookContentsLabel.text = document.contents   //책 소개
        
        setupAddView()
        setupAutoLayout()
    }
    
    // MARK: - 닫기 버튼 선택
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 책 담기 버튼 선택
    @objc private func addButtonTapped() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        
//        guard let entity = NSEntityDescription.entity(forEntityName: "BookWishList", in: context) else { return }
//        let myBook = NSManagedObject(entity: entity, insertInto: context)
//        myBook.setValue(tempTitle, forKey: "title")
//        myBook.setValue(tempIsbn, forKey: "isbn")
//        myBook.setValue(tempImageView, forKey: "imgUrl")
//        
//        try? context.save()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // 중복 데이터 확인
        let fetchRequest: NSFetchRequest<BookWishList> = BookWishList.fetchRequest()
        if let title = tempDocument?.title,
           let isbn = tempDocument?.isbn,
           let imgUrl = tempDocument?.thumbnail {
            fetchRequest.predicate = NSPredicate(format: "title == %@ AND isbn == %@ AND imgUrl == %@", title, isbn, imgUrl)
        }
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty { // 중복되지 않은 경우에만 저장
                guard let entity = NSEntityDescription.entity(forEntityName: "BookWishList", in: context) else { return }
                let myBook = NSManagedObject(entity: entity, insertInto: context)
                myBook.setValue(tempDocument?.title, forKey: "title")
                myBook.setValue(tempDocument?.isbn, forKey: "isbn")
                myBook.setValue(tempDocument?.thumbnail, forKey: "imgUrl")
                
                try context.save()
                print("책 담기 성공")
            
            } else {
                print("이미 담은 책입니다.")
            }
        } catch let error as NSError {
            print("책 담기 에러: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 취소선 추가
    private func addStrikethrough(to string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: string.count))
        return attributedString
    }
    
    // MARK: - 숫자 자리수 추가
    private func setComma(number: Int) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let num = numberFormatter.string(for: number) {
            return num
        } else {
            return String(number)
        }
    }
    
    // MARK: - 뷰 추가
    private func setupAddView() {
        //저자 및 번역가
        bookAuthorsTranslatorsStackView.addArrangedSubview(bookAuthorsLabel)
        bookAuthorsTranslatorsStackView.addArrangedSubview(bookTranslatorsLabel)
        
        //할인율, 할인가, 정가
        bookPriceStackView.addArrangedSubview(bookDiscountLabel)
        bookPriceStackView.addArrangedSubview(bookSalePriceLabel)
        bookPriceStackView.addArrangedSubview(bookPriceLabel)
    
        scrollView.addSubview(bookImageView)                    //책 이미지
        scrollView.addSubview(bookTitleLabel)                   //책 제목
        scrollView.addSubview(bookAuthorsTranslatorsStackView)  //저자 및 번역가
        scrollView.addSubview(bookPublisherLabel)               //출판사
        scrollView.addSubview(bookPriceStackView)               //할인율, 할인가, 정가
        scrollView.addSubview(bookContentsTitleLabel)           //책 소개 텍스트
        scrollView.addSubview(bookContentsLabel)                //책 소개
        view.addSubview(scrollView)
        
        buttonStackView.addArrangedSubview(closeButton)
        buttonStackView.addArrangedSubview(addButton)
        buttonView.addSubview(buttonStackView)
        view.addSubview(buttonView)
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            //스크롤 뷰
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonView.topAnchor),
           
            //책 이미지
            bookImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            bookImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bookImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.4),
            bookImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5),
                        
            //책 제목
            bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 30),
            bookTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            bookTitleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                        
            //저자 및 번역가
            bookAuthorsTranslatorsStackView.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 10),
            bookAuthorsTranslatorsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bookAuthorsTranslatorsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            //출판사
            bookPublisherLabel.topAnchor.constraint(equalTo: bookAuthorsTranslatorsStackView.bottomAnchor, constant: 10),
            bookPublisherLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            
            //할인율, 할인가, 정가
            bookPriceStackView.topAnchor.constraint(equalTo: bookPublisherLabel.bottomAnchor, constant: 30),
            bookPriceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bookPriceStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            bookDiscountLabel.widthAnchor.constraint(equalTo: bookPriceStackView.widthAnchor, multiplier: 0.15),
            bookSalePriceLabel.widthAnchor.constraint(equalTo: bookPriceStackView.widthAnchor, multiplier: 0.25),
            //bookPriceLabel.widthAnchor.constraint(equalTo: bookPriceStackView.widthAnchor, multiplier: 0.15),
            
            //책 소개 타이틀
            bookContentsTitleLabel.topAnchor.constraint(equalTo: bookPriceStackView.bottomAnchor, constant: 30),
            bookContentsTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            
            //책 소개
            bookContentsLabel.topAnchor.constraint(equalTo: bookContentsTitleLabel.bottomAnchor, constant: 10),
            bookContentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bookContentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bookContentsLabel.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
                        
            //버튼이 담기는 뷰
            buttonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //닫기버튼과 담기 버튼을 스택뷰로 묶기
            buttonStackView.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10),
            buttonStackView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -10),
            buttonStackView.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -10),
            
            //leading, trailing, spacing때문에 -30, 버튼을 1:4 비율로
            closeButton.widthAnchor.constraint(equalToConstant: (view.bounds.width - 30) * 0.2),
            addButton.widthAnchor.constraint(equalToConstant: (view.bounds.width - 30) * 0.8),
        ])
    }
}
