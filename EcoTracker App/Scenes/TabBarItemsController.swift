//
//  TabBarItemsController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit

class TabBarItemsController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarViews()
    }
    
    // MARK: - Setup Tab Bar Views
    private func setUpTabBarViews() {
        let airQualityVC = createAirQualityVC()
        let weatherVC = createWeatherVC()
        let specieVC = createSpecieVC()
        let solarResourceVC = createSolarResourceVC()
        let populationVC = createPopulationVC()
        
        setViewControllers([airQualityVC, weatherVC, specieVC, solarResourceVC, populationVC], animated: true)
    }
    
    // MARK: - Create TabBarItem View Controllers
    private func createAirQualityVC() -> UINavigationController {
        let airQualityVC = UINavigationController(rootViewController: AirQualityViewController())
        airQualityVC.tabBarItem.image = UIImage(systemName: "air.purifier")
        airQualityVC.title = "Air Quality"
        return airQualityVC
    }
    
    private func createWeatherVC() -> UINavigationController {
        let weatherVC = UINavigationController(rootViewController: WeatherViewController())
        weatherVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        weatherVC.title = "Weather"
        return weatherVC
    }
    
    private func createSpecieVC() -> UINavigationController {
        let specieVC = UINavigationController(rootViewController: SpecieViewController())
        specieVC.tabBarItem.image = UIImage(systemName: "leaf")
        specieVC.title = "Species"
        return specieVC
    }
    
    private func createSolarResourceVC() -> UINavigationController {
        let solarResourceVC = UINavigationController(rootViewController: SolarResourceViewController())
        solarResourceVC.tabBarItem.image = UIImage(systemName: "sun.max")
        solarResourceVC.title = "Solar Resource"
        return solarResourceVC
    }
    
    private func createPopulationVC() -> UINavigationController {
        let populationVC = UINavigationController(rootViewController: PopulationViewController())
        populationVC.tabBarItem.image = UIImage(systemName: "person.3")
        populationVC.title = "Population"
        return populationVC
    }
}

