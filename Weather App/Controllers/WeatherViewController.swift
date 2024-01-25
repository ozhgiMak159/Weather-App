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
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    private let weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        fetchWeather()
    }
    
    private func showAnimation() {
        for element in [backgroundView, conditionImageView, temperatureLabel, conditionLabel] {
            element?.showAnimatedGradientSkeleton()
        }
    }
    
    private func hideAnimation() {
        for element in [backgroundView, conditionImageView, temperatureLabel, conditionLabel] {
            element?.hideSkeleton()
        }
        
    }
    
    //
    private func fetchWeather() {
        weatherManager.fetchWeather(city: "London") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let wetherModel):
                self.updateView(with: wetherModel)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView(with data: WeatherModel) {
        hideAnimation()
        
        cityNameLabel.text = data.countryName
        conditionImageView.image = UIImage(named: data.conditionImage)
        
        temperatureLabel.text = data.temp.toString().appending("°")
        temperatureMinLabel.text = data.tempMin.toString().appending("°")
        temperatureMaxLabel.text = data.tempMax.toString().appending("°")
        
        conditionLabel.text = data.conditionDescription
        
    }
    
    @IBAction func addCityButtonTapped() {
        performSegue(withIdentifier: "ShowAddCity", sender: nil)
    }
    
    @IBAction func locationButtonTapped() {}
    


}

