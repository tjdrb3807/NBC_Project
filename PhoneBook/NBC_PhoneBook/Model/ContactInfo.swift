//
//  ContactInfo.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/10/24.
//

import Foundation
import Alamofire

class ContactInfo {
    private let userDefaultsKey = "ContactInfoList"
    
    var name: String = ""
    var phoneNumber: String = ""
    var profileImageURL: URL?
    
    var beforeName: String = ""
    var beforePhoneNumber: String = ""
    var beforeProfileImgaeURL: URL?
    
    /// profileImageURL이 변경됐을 때 호출되는 클로저
    var profileImageURLDidChange: ((URL) -> Void)?
    
    init() { }
    
    init(name: String, phoneNumber: String, profileImageURL: URL? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.profileImageURL = profileImageURL
    }
    
    func updateName(_ value: String) { self.name = value }
    
    func updatePhoneNumber(_ value: String) { self.phoneNumber = value }
    
    // MARK: UserDefaults logic
    func loadData() -> [ContactInfoDTO] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let contactInfoDTOList = try? JSONDecoder().decode([ContactInfoDTO].self, from: data) else { return [] }
        
        return contactInfoDTOList
    }
    
    func saveData(_ dtoList: [ContactInfoDTO]) {
        if let encodedData = try? JSONEncoder().encode(dtoList) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
    
    func addData(_ model: ContactInfo) {
        var contacts = loadData()
        let dto = model.toDTO()
        
        if contacts.contains(where: { $0.phoneNumber == dto.phoneNumber }) {
            return print("이미 존재하는 휴대폰번호입니다.")
        }
        
        contacts.append(dto)
        saveData(contacts)
    }
    
    func updateData(_ model: ContactInfo) {
        var contacts = loadData()
        let dto = model.toDTO()
        
        if let index = contacts.firstIndex(where: { $0.phoneNumber == model.beforePhoneNumber }) {
            contacts[index] = dto
        }
        
        saveData(contacts)
    }
}

// MARK: Network
extension ContactInfo {
//    func fetchRandomImageURLWithURLSession() {
//        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))") else { return }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self = self, let data = data, error == nil else { return }
//
//            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
//                guard let decodedData = try? JSONDecoder().decode(RandomImageResponseDTO.self, from: data) else { return }
//
//                profileImageURL = decodedData.image.url
//                profileImageURLDidChange?(decodedData.image.url)
//            }
//        }.resume()
//    }
    
    func fetchRandomImageURLWithAlamo() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))") else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: ["Content-Type": "application/json", "Accept": "application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: RandomImageResponseDTO.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let responseDTO):
                profileImageURL = responseDTO.image.url
                profileImageURLDidChange?(responseDTO.image.url)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

extension ContactInfo {
    func toDTO() -> ContactInfoDTO {
        return ContactInfoDTO(
            name: self.name,
            phoneNumber: self.phoneNumber,
            profileImageURL: self.profileImageURL)
    }
}
