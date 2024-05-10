//
//  RecentlyViewedBooksCollectionViewCell.swift
//  MyBook
//
//  Created by imhs on 5/5/24.
//

import UIKit
import SnapKit

class RecentlyViewedBooksCollectionViewCell: UICollectionViewCell {
    // MARK: - Cell 등록 시 사용할 identifier 설정
    static let identifier = String(describing: RecentlyViewedBooksCollectionViewCell.self)
    
    // MARK: - 책 이미지
    var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - 책 제목
    var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "책 제목"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        addView()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 추가
    func addView() {
        [bookImageView, bookTitleLabel].forEach { item in
            //item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
        }
    }
    
    // MARK: - 오토레이아웃 설정
    func setupAutoLayout() {
//        NSLayoutConstraint.activate([
//            bookImageView.topAnchor.constraint(equalTo: topAnchor),
//            bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            bookImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            bookImageView.widthAnchor.constraint(equalTo: widthAnchor),
//            bookImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),  //Cell의 80%
//            
//            bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor),
//            bookTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            bookTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            bookTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//            bookTitleLabel.widthAnchor.constraint(equalTo: widthAnchor),
//            bookTitleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2), //Cell의 20%
//        ])
        bookImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8) // Cell의 80%
        }

        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2) // Cell의 20%
        }
    }
}
