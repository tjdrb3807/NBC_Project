//
//  RandomImageResponseDTO.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/10/24.
//

import Foundation

struct RandomImageResponseDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let image: ImageResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case id, name, height, weight
        case image = "sprites"
    }
}

struct ImageResponseDTO: Decodable {
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url = "front_default"
    }
}
