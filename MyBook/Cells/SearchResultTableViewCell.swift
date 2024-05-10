//
//  SearchResultTableViewCell.swift
//  MyBook
//
//  Created by imhs on 5/5/24.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    //TableView Cell을 등록하기위해 식별자 설정
    static let identifier = String(describing: SearchResultTableViewCell.self)
    
    // MARK: - 모든 셀을 담은 스택 뷰
    var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - 책 이미지
    var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - 책 정보를 담을 스택 뷰
    var contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
                
    // MARK: - 책 제목
    var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    // MARK: - 저자
    var bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    // MARK: - 출판사
    var bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return label
    }()
    
    // MARK: - 책 가격
    var bookPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    // MARK: - 책 소개
    var bookContentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupAddView()
        setupAutoLayout()
    }
    
    // MARK: - 뷰 추가
    func setupAddView() {
        //책 제목, 저자, 가격, 소개
        [bookTitleLabel, bookAuthorsLabel, bookPublisherLabel, bookPriceLabel, bookContentsLabel].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentsStackView.addArrangedSubview(item)
        }
        
        //책 소개, 책 정보
        [bookImageView, contentsStackView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            //contentView.addSubview(item)
            cellStackView.addArrangedSubview(item)
        }
        
        //모든 셀
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellStackView)
    }
    
    // MARK: - 오토레이아웃 추가
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            //책 이미지
            bookImageView.widthAnchor.constraint(equalTo: cellStackView.widthAnchor, multiplier: 0.25),
            bookImageView.topAnchor.constraint(equalTo: cellStackView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor),
            
            //책 정보 스택 뷰
            contentsStackView.topAnchor.constraint(equalTo: cellStackView.topAnchor),
            contentsStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            contentsStackView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor),
            contentsStackView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor),
            
            // 책 제목
            bookTitleLabel.topAnchor.constraint(equalTo: contentsStackView.topAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: contentsStackView.leadingAnchor, constant: 10),
            bookTitleLabel.trailingAnchor.constraint(equalTo: contentsStackView.trailingAnchor),
            
            // 책 저자
            bookAuthorsLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor),
            bookAuthorsLabel.leadingAnchor.constraint(equalTo: contentsStackView.leadingAnchor, constant: 10),
            bookAuthorsLabel.trailingAnchor.constraint(equalTo: contentsStackView.trailingAnchor),
       
            // 책 출판사
            bookPublisherLabel.topAnchor.constraint(equalTo: bookAuthorsLabel.bottomAnchor),
            bookPublisherLabel.leadingAnchor.constraint(equalTo: contentsStackView.leadingAnchor, constant: 10),
            bookPublisherLabel.trailingAnchor.constraint(equalTo: contentsStackView.trailingAnchor),
       
            // 책 가격
            bookPriceLabel.topAnchor.constraint(equalTo: bookPublisherLabel.bottomAnchor),
            bookPriceLabel.leadingAnchor.constraint(equalTo: contentsStackView.leadingAnchor, constant: 10),
            bookPriceLabel.trailingAnchor.constraint(equalTo: contentsStackView.trailingAnchor),
            bookPriceLabel.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, multiplier: 0.15),
            
            // 책 소개
            bookContentsLabel.topAnchor.constraint(equalTo: bookPriceLabel.bottomAnchor),
            bookContentsLabel.leadingAnchor.constraint(equalTo: contentsStackView.leadingAnchor, constant: 10),
            bookContentsLabel.trailingAnchor.constraint(equalTo: contentsStackView.trailingAnchor),
            bookContentsLabel.bottomAnchor.constraint(equalTo: contentsStackView.bottomAnchor),
        ])
    }
}
