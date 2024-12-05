//
//  CurrentWeatherResponseDTO.swift
//  Weather
//
//  Created by 전성규 on 12/5/24.
//

import Foundation

struct CurrentWeatherResponseDTO: Codable {
    let data: CurrentWeatherMainResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case data = "main"
    }
}

struct CurrentWeatherMainResponseDTO: Codable {
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
