//
//  MainViewController.swift
//  Weather
//
//  Created by 전성규 on 12/5/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "lat", value: "37.5"),
        URLQueryItem(name: "lon", value: "126.9"),
        URLQueryItem(name: "appid", value: "26fca33ac13e68d4b6bfa911b5e0f22c"),
        URLQueryItem(name: "units", value: "metric")
    ]
    
    private lazy var currentWeatherView = { CurrentWeahterView() }()
    
    private lazy var pastWeatherTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PastWeatherTableViewCell.self,
                           forCellReuseIdentifier: PastWeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrentWeatherData()
        
        self.configureUI()
        self.setupConstraints()
    }
    
    private func fetchCurrentWeatherData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else { return }
        
        Task {
            let data = await fetchData(url: url)
            
            
        }
        
//        fetchData(url: url) { [weak self] (dto: CurrentWeatherResponseDTO?) in
//            guard let self, let dto else { return }
//            
//            currentWeatherView.updateUI(
//                currentTemp: dto.data.temp,
//                minTemp: dto.data.minTemp,
//                maxTemp: dto.data.maxTemp)
//        }
    }
    
//    private func fetchCurrentWeatherData() {
//           var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
//           urlComponents?.queryItems = self.urlQueryItems
//           
//           guard let url = urlComponents?.url else {
//               print("잘못된 URL")
//               return
//           }
//           
//           fetchData(url: url) { [weak self] (result: CurrentWeatherResult?) in
//               guard let self, let result else { return }
//               // UI 작업은 메인 쓰레드에서 작업
//               DispatchQueue.main.async {
//                   self.tempLabel.text = "\(Int(result.main.temp))°C"
//                   self.tempMinLabel.text = "최소: \(Int(result.main.temp_min))°C"
//                   self.tempMaxLabel.text = "최고: \(Int(result.main.temp_max))°C"
//               }
//               guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png") else { return }
//       
//               // image 를 로드하는 작업은 백그라운드 쓰레드 작업
//               if let data = try? Data(contentsOf: imageUrl) {
//                   if let image = UIImage(data: data) {
//                       // 이미지뷰에 이미지를 그리는 작업은 UI 작업이기 때문에 다시 메인 쓰레드에서 작업.
//                       DispatchQueue.main.async {
//                           self.imageView.image = image
//                       }
//                   }
//               }
//           }
//       }

    
    private func configureUI() {
        view.backgroundColor = .black
        
        [currentWeatherView, pastWeatherTableView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        currentWeatherView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height / 2)
        }
        
        pastWeatherTableView.snp.makeConstraints {
            $0.top.equalTo(currentWeatherView.snp.bottom).offset(30.0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: 제네릭으로 처리하는 생각!
    private func fetchData<T: Codable>(url: URL, completion: @escaping (T?) -> Void) {
        print("Main Thread에서 출력: \(Thread.current)")
        let urlSession = URLSession(configuration: .default)
        urlSession.dataTask(with: URLRequest(url: url)) { data, response, error in
            print("URLSession.dataTack 안에서 출력: \(Thread.current)")
            guard let data = data, error == nil else {
                print("FAIL: Data Load")
                completion(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("FAIL: Decoding")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("FAIL: Respone")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchData(url: URL) async -> CurrentWeatherResponseDTO? {
        let urlSession = URLSession(configuration: .default)
        
        do  {
            let (data, response) = try await urlSession.data(from: url)
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(CurrentWeatherResponseDTO.self, from: data) else {
                    return nil
                }
                return decodedData
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PastWeatherTableViewCell.identifier,
            for: indexPath) as? PastWeatherTableViewCell else { return UITableViewCell() }
        
        cell.setupData("2024-12-05 18:00:00", 22.04)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 50.0 }
}

#if DEBUG

import SwiftUI

struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainViewController_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct MainViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController { MainViewController() }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}

#endif
