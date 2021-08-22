//
//  ViewController.swift
//  GoodWeather
//
//  Created by Junior Ferreira on 20/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var tempetureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
                
            }).disposed(by: disposeBag)
    }

    private func displayWeather(_ weather: Weather?) {
        
        if let weather = weather {
            self.tempetureLabel.text = "\(weather.temp) "
            self.humidityLabel.text = "\(weather.humidity)"
        } else {
            self.tempetureLabel.text = "🙈"
            self.humidityLabel.text = "🦃"
        }
    }

    
    private func fetchWeather(by city: String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .catchError { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp)" }
            .drive(self.tempetureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity)" }
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
