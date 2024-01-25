//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Maksim  on 24.01.2024.
//

import UIKit
import SkeletonView


class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        fetchWeather()
       // weatherManager.fetchWeather(city: "London")
    }
    
    private func showAnimation() {
        for element in [conditionImageView, temperatureLabel, conditionLabel] {
            element?.showAnimatedGradientSkeleton()
        }
    }
    
    private func hideAnimation() {
        for element in [conditionImageView, temperatureLabel, conditionLabel] {
            element?.hideSkeleton()
        }
        
    }
    
    //
    private func fetchWeather() {
        weatherManager.fetchWeather(city: "Perm") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let wetherData):
                self.updateView(with: wetherData)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView(with data: WeatherData) {
        hideAnimation()
        navigationItem.title = data.name ?? ""
        temperatureLabel.text = data.main?.temp?.toString().appending(" °С")
        conditionLabel.text = data.weather?.first?.description
        
    }
    
    @IBAction func addCityButtonTapped() {
        performSegue(withIdentifier: "ShowAddCity", sender: nil)
    }
    
    @IBAction func locationButtonTapped() {}
    


}

