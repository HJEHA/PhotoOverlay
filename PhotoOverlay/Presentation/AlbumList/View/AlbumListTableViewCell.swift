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
        imageView.image = UIImage(systemName: "heart")
        
        return imageView
    }()
    
    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "All"
        label.font = .preferredFont(forTextStyle: .headline).bold
        
        return label
    }()
    
    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureConstraintsSubview()
    }
}

// MARK: - Update View

extension AlbumListTableViewCell {
    func update(_ item: PhotoItem) {
        albumTitleLabel.text = ""
        thumbnailImageView.image = item.photo
    }
}

// MARK: - Configure View

extension AlbumListTableViewCell {
    private func configureConstraintsSubview() {
        
        // MARK: - Constraints ThumbnailImageView
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(thumbnailImageView.snp.height)
        }
        
        // MARK: - Constraints AlbumTitleLabel
        
        contentView.addSubview(albumTitleLabel)
        albumTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).inset(-8)
            make.centerY.equalTo(thumbnailImageView.snp.centerY)
        }
    }
}
