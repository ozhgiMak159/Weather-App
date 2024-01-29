//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Maksim  on 24.01.2024.
//

import UIKit
import SkeletonView
import CoreLocation

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
    private lazy var locationManager: CLLocationManager = {
       let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather(byCity: "Berlin")
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
    
    @IBAction func locationButtonTapped() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        default:
            promptForLocationPermission()
        }
    }
    
    // MARK: Private Methods
    
    private func fetchWeather(byLocation location: CLLocation) {
        showAnimation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeather1(lat: lat, lon: lon) { [weak self] result in
            self?.handleResult(result)
        }
    }
    
    private func handleError(_ error: Error) {
        hideAnimation()
        conditionImageView.image = UIImage(named: "imSad")
        cityNameLabel.text = error.localizedDescription
        for i in [temperatureLabel, temperatureMaxLabel, temperatureMinLabel] {
            i?.text = "&"
        }
    }
    
    private func handleResult(_ result: Result<WeatherModel, Error>) {
        switch result {
        case .success(let wetherModel):
            self.updateView(with: wetherModel)
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func promptForLocationPermission() {
        let alertController = UIAlertController(
            title: "Requires Location Permission",
            message: "Would you like to enable location permission in Settings",
            preferredStyle: .alert)
        
        let enableAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(enableAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
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

    private func fetchWeather(byCity city: String) {
        showAnimation()
        weatherManager.fetchWeather(city: city) { [weak self] result in
            self?.handleResult(result)
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
    
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            fetchWeather(byLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleError(error)
    }
}
