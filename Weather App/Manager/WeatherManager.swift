//
//  WeatherManager.swift
//  Weather App
//
//  Created by Maksim  on 25.01.2024.
//

import Alamofire
import Foundation

enum WeatherError: Error, LocalizedError {
    case unknown
    case invalidCity
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "This is an invalid"
        case .invalidCity:
            return "Hey, this is an unknown error!"
        case .custom(description: let description):
            return description
        }
    }
}


struct WeatherManager {
    
    private let api_Key = "d72b5b51208bad754383e5b46cfa8a42"
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        guard let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let urlString = String(format: path, query, api_Key)
        // "https://api.openweathermap.org/data/2.5/weather?q=query=api_Key"
        
       
        AF.request(urlString).validate().responseDecodable(of: WeatherData.self) { (response) in
                switch response.result {
                case .success(let wetherModel):
                    let model = wetherModel.wetherModel
                    completion(.success(model))

                case .failure(let error):
                    if let errorCust = getWeatherError(error: error, data: response.data) {
                        completion(.failure(errorCust))
                    } else {
                        completion(.failure(error))
                    }
                }
        }
    }
    
    private func getWeatherError(error: AFError, data: Data?) -> Error? {
        if error.responseCode == 404,
           let data = data,
           let failure = try? JSONDecoder().decode(WeatherDataFailure.self, from: data) {
            let message = failure.message

            return WeatherError.custom(description: message)
        } else {
            return nil
        }
    }
}
