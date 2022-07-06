//
//  AlbumListTableViewCell.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import UIKit

import SnapKit

final class AlbumListTableViewCell: UITableViewCell {
    
    // MARK: - View Properties
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).bold
        
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraintsSubview()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Update View

extension AlbumListTableViewCell {
    func update(_ item: AlbumItem) {
        albumTitleLabel.text = item.title
        thumbnailImageView.image = item.thumbnailImage
    }
}

// MARK: - Configure View

extension AlbumListTableViewCell {
    
    private func configureView() {
        selectionStyle = .none
    }
    
    private func configureConstraintsSubview() {
        
        // MARK: - Constraints ThumbnailImageView
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(80)
        }
        
        // MARK: - Constraints AlbumTitleLabel
        
        contentView.addSubview(albumTitleLabel)
        albumTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).inset(-8)
            make.centerY.equalTo(thumbnailImageView.snp.centerY)
        }
    }
}
