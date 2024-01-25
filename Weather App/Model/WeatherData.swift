//
//  WeatherData.swift
//  Weather App
//
//  Created by Maksim  on 25.01.2024.
//


struct WeatherData: Decodable {
    let name: String?
    let main: Main?
    let weather: [Weather]?
}

struct Main: Decodable {
    let temp: Double?
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
}
