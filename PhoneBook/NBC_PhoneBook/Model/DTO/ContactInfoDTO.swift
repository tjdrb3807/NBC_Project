//
//  ContactInfoDTO.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/11/24.
//

import Foundation

struct ContactInfoDTO: Codable {
    var name: String = ""
    var phoneNumber: String = ""
    var profileImageURL: URL?
}

extension ContactInfoDTO {
    func toDomain() -> ContactInfo {
        return ContactInfo(
            name: self.name,
            phoneNumber: self.phoneNumber,
            profileImageURL: self.profileImageURL)
    }
}
