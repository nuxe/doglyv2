//
//  MultiSelectTableViewCell.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

import UIKit

class MultiSelectTableViewCell: UITableViewCell {
    
    let item: String = ""
    let subitems: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    private func setupSubviews() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
