//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Maksim  on 24.01.2024.
//

import UIKit
import SkeletonView

protocol WeatherViewControllerDelegate: AnyObject {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}

class WeatherViewController: UIViewController {
    
    // MARK: IB Outlet
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: Private Properties
    private let weatherManager = WeatherManager()

    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        fetchWeather()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddCity" {
            if let destination = segue.destination as? AddCityViewController {
                destination.delegate = self
            }
        }
    }
    
    // MARK: IB Action
    @IBAction func addCityButtonTapped() {
        performSegue(withIdentifier: "ShowAddCity", sender: nil)
    }
    
    @IBAction func locationButtonTapped() {}
    
    // MARK: Private Methods
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
        
}

// MARK: WeatherViewControllerDelegate
extension WeatherViewController: WeatherViewControllerDelegate {
    // Тут происходит обновление модели
    func didUpdateWeatherFromSearch(model: WeatherModel) {
        presentedViewController?.dismiss(animated: true) { [weak self] in
            self?.updateView(with: model)
        }
    }
}
    
