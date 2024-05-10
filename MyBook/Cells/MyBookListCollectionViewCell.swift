//
//  MyBookListCollectionViewCell.swift
//  MyBook
//
//  Created by imhs on 5/9/24.
//

import UIKit
import SnapKit

class MyBookListCollectionViewCell: UICollectionViewCell {
    // MARK: - Cell 등록 시 사용할 identifier 설정
    static let identifier = String(describing: MyBookListCollectionViewCell.self)
    
    // MARK: - 책 이미지
    var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPink
        return imageView
    }()
    
    // MARK: - 책 제목
    var bookTilteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 1
        
        addSubview(bookImageView)
        addSubview(bookTilteLabel)
        
        // 책 이미지
        bookImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(140) // 이미지 뷰 높이 설정
        }
        
        // 책 제목
        bookTilteLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
