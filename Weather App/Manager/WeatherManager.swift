//
//  WeatherManager.swift
//  Weather App
//
//  Created by Maksim  on 25.01.2024.
//

import Alamofire
import Foundation

struct WeatherManager {
    
    private let api_Key = "d72b5b51208bad754383e5b46cfa8a42"
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        guard let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let urlString = String(format: path, query, api_Key)
        
        AF.request(urlString).responseDecodable(
            of: WeatherData.self,
            queue: .main,
            decoder: JSONDecoder() ) { (response) in
                
                switch response.result {
                case .success(let wetherModel):
                    let model = wetherModel.wetherModel
                    completion(.success(model))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
