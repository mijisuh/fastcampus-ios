//
//  ViewController.swift
//  Weather
//
//  Created by mijisuh on 2024/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabell: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapFetchWeatherButton(_ sender: Any) {
        guard let cityName = self.cityNameTextField.text else { return }
        self.getCurrentWeather(cityName: cityName)
        self.view.endEditing(true) // 버튼이 클릭되면 키보드가 사라짐
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabell.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "최대: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)") else { return }
        // 1. 세션 생성
        let session = URLSession(configuration: .default)
        // 2. 서버에 요청d
        session.dataTask(with: url) { [weak self] data, response, error in
            // data: 서버에서 응답 받은 데이터
            // response: http 헤더 및 상태 코드와 같은 응답 메타데이터
            // error: 요청 실패 시 에러 객체, 성공 시 nil
            
            let successRange = (200..<300)
            
            // 3. 응답 받은 JSON 데이터를 WeatherInformation 객체로 디코딩
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder() // JSON 객체를 Data 유형의 인스턴스(Decodable 준수)로 디코딩
                
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }// 디코딩 실패시 에러를 던져줌
                debugPrint(weatherInformation)
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation) // 날씨 정보가 뷰에 표시되도록
                }
            } else { // 서버에서 에러 응답을 받으면
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume() // 작업 실행
    }
    
}

