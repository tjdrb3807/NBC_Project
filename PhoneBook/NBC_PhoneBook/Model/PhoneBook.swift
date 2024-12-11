//
//  PhoneBook.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/11/24.
//

import Foundation

class PhoneBook {
    var list: [ContactInfo] = []
    
    var listDidChange: (() -> Void)?
}

extension PhoneBook {
    func fetchAllData() {
        guard let data = UserDefaults.standard.data(forKey: "ContactInfoList"),
              let decodedData = try? JSONDecoder().decode([ContactInfoDTO].self, from: data) else { return }
        
        list = decodedData.map { $0.toDomain() }.sorted { $0.name < $1.name }
        listDidChange?()
    }
}
