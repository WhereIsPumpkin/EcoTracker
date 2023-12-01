//
//  SolarResourceViewController.swift
//  EcoTracker App
//
//  Created by Saba Gogrichiani on 29.11.23.
//

import UIKit
 
final class SolarResourceViewController: UIViewController {
    
    // MARK: - UI Componenets
    let viewModel = SolarResourceViewModel()
    private var latitudeTextField: UITextField!
    private var longitudeTextField: UITextField!
    private var fetchDataButton: UIButton!
    private var scrollView: UIScrollView!
    private var containerView: UIView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setUpLatitudeTextField()
        setUpLongitudeTextField()
        setupFetchDataButton()
        setupScrollView()
        setupTabBarColor()
    }
    
    private func setUpLatitudeTextField() {
        latitudeTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 40))
        latitudeTextField.placeholder = "Enter latitude"
        latitudeTextField.borderStyle = .roundedRect
        view.addSubview(latitudeTextField)
    }
    
    private func setUpLongitudeTextField() {
        longitudeTextField = UITextField(frame: CGRect(x: 20, y: 160, width: 200, height: 40))
        longitudeTextField.placeholder = "Enter longitude"
        longitudeTextField.borderStyle = .roundedRect
        view.addSubview(longitudeTextField)
    }
 
    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: fetchDataButton.frame.maxY + 20, width: view.frame.width, height: view.frame.height - fetchDataButton.frame.maxY - 20))
        scrollView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        view.addSubview(scrollView)
 
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0))
        scrollView.addSubview(containerView)
 
        fetchData()
    }
    
    private func setupTabBarColor() {
        tabBarController?.tabBar.backgroundColor = .systemBackground
    }
    
    // MARK: Methods
    
    private func setupFetchDataButton() {
        fetchDataButton = UIButton(type: .system)
        fetchDataButton.frame = CGRect(x: 20, y: 220, width: 200, height: 40)
        fetchDataButton.setTitle("Fetch Data", for: .normal)
        fetchDataButton.setTitleColor(.white, for: .normal)
        fetchDataButton.backgroundColor = UIColor.buttonBackground
        fetchDataButton.layer.cornerRadius = 8
        fetchDataButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        view.addSubview(fetchDataButton)
        fetchDataButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
 
    @objc private func buttonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.fetchDataButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.fetchDataButton.transform = .identity
            }
        }
    }
 
    @objc func fetchData() {
        guard let latitudeText = latitudeTextField.text, !latitudeText.isEmpty,
              let longitudeText = longitudeTextField.text, !longitudeText.isEmpty,
              let latitude = Double(latitudeText),
              let longitude = Double(longitudeText)
        else {
            return
        }
 
        viewModel.fetchSolarData(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let self = self else { return }
 
            switch result {
            case .success(let solarData):
                DispatchQueue.main.async {
                    self.handleSolarData(solarData)
                }
            case .failure(let error):
                print("Error fetching solar data: \(error)")
            }
        }
    }
 
    private func handleSolarData(_ solarData: SolarData) {
        let avgDNIMonthly = solarData.outputs.avgDni.monthly
        let avgGHIMonthly = solarData.outputs.avgGhi.monthly
        let avgLatTiltMonthly = solarData.outputs.avgLatTilt.monthly
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
 
        var yOffset: CGFloat = 10.0
 
        addLabelToContainer(withText: generateLabelText(for: avgDNIMonthly, title: "Average Direct Normal Irradiance (monthly):"), yOffset: &yOffset, in: containerView)
        addLabelToContainer(withText: generateLabelText(for: avgGHIMonthly, title: "\nAverage Global Horizontal Irradiance (monthly):"), yOffset: &yOffset, in: containerView)
        addLabelToContainer(withText: generateLabelText(for: avgLatTiltMonthly, title: "\nAverage Tilt at Latitude (monthly):"), yOffset: &yOffset, in: containerView)
 
        containerView.frame.size.height = yOffset
        scrollView.contentSize = CGSize(width: containerView.frame.width, height: yOffset)
        
    }
 
    private func generateLabelText(for data: [String: Double], title: String) -> String {
        var text = title + "\n"
        for (month, value) in data {
            text += "\(month): \(value)\n"
        }
        return text
    }
 
    private func addLabelToContainer(withText text: String, yOffset: inout CGFloat, in view: UIView) {
        let label = UILabel(frame: CGRect(x: 20, y: yOffset, width: view.bounds.width - 40, height: 0))
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        view.addSubview(label)
        yOffset += label.frame.height + 20
    }
}
 
