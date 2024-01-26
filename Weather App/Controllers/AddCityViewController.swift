//
//  AddCityViewController.swift
//  Weather App
//
//  Created by Maksim  on 25.01.2024.
//

import UIKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
   // private var textTF = "Uknow"
    
    private let weatherManager = WeatherManager()
    
    weak var delegate: WeatherViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        cityTextField.becomeFirstResponder()
        
    }
    
//    func addTextTF(str: String) {
//       // textTF = str
//        cityTextField.text = textTF
//    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.8)
        statusLabel.isHidden = true
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showSearchError(text: String) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemRed
        statusLabel.text = text
    }
    
    private func handleSearchSuccess(model: WeatherModel) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemGreen
        statusLabel.text = "Success!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.delegate?.didUpdateWeatherFromSearch(model: model)
        }
        
    }
 
    private func searchForCity(query: String) {
        view.endEditing(true)

        
        weatherManager.fetchWeather(city: query) { [weak self] result in
           
            switch result {
            case .success(let model):
                self?.handleSearchSuccess(model: model)
            case .failure(let error):
                self?.showSearchError(text: error.localizedDescription)
            }
        }
    }
    
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let query = cityTextField.text, !query.isEmpty else {
            showSearchError(text: "City cannot be empty. Please, try again!")
            return
        }
        
        searchForCity(query: query)
    }
    
}

extension AddCityViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
