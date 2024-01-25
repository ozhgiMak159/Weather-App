//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Maksim  on 24.01.2024.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.featherWeather(city: "London")
    }
    
    @IBAction func addLocationButtonTapped() {}
    
    @IBAction func locationButtonTapped() {}
    


}

