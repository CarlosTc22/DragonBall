//
//  HeroDetailViewController.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import UIKit
import MapKit
import Kingfisher

// Protocol defining interactions with HeroDetailViewController's ViewModel.
protocol HeroDetailViewControllerDelegate {
    var viewState: ((HeroDetailViewState) -> Void)? { get set }
    func onViewAppear()
}

// Possible states of the hero detail view to update corresponding UI.
enum HeroDetailViewState {
    case loading(_ isLoading: Bool)
    case updateData(hero: Hero?, locations: [HeroAnnotation]?)
}

class HeroDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UITextView!
    
    // MARK: - Properties
    var viewModel: HeroDetailViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        setupObservers()
        viewModel?.onViewAppear()
    }
    
    // MARK: - Initial Setup
    private func initializeViews() {
        mapView.delegate = self
    }
    
    // Observes changes in the ViewModel's view state to update the UI.
    private func setupObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleViewState(state)
            }
        }
    }
    
    // Handles UI updates based on the current view state.
    private func handleViewState(_ state: HeroDetailViewState) {
        switch state {
        case .loading(let isLoading):
            loadingView.isHidden = !isLoading
        case .updateData(let hero, let heroLocations):
            updateViews(hero: hero, heroLocations: heroLocations)
        }
    }
    
    // Updates UI elements with hero and its locations data.
    private func updateViews(hero: Hero?, heroLocations: [HeroAnnotation]?) {
        photo.kf.setImage(with: URL(string: hero?.photo ?? ""))
        roundImage(image: photo)
        name.text = hero?.name
        heroDescription.text = hero?.description
        heroLocations?.forEach { mapView.addAnnotation($0) }
    }
    
    // Rounds the hero's photo.
    private func roundImage(image: UIImageView) {
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
    }
    
    // MARK: - Actions
    @IBAction func onBackButtonPress() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension HeroDetailViewController: MKMapViewDelegate {
    // Customizes annotation view for hero locations.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let heroAnnotation = annotation as? HeroAnnotation {
            return configureHeroAnnotationView(for: heroAnnotation, in: mapView)
        }
        return nil // Returns nil for default annotation views or user location
    }
    
    // Configures a view for HeroAnnotation.
    private func configureHeroAnnotationView(for annotation: HeroAnnotation, in mapView: MKMapView) -> MKAnnotationView {
        let identifier = "HeroAnnotation"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "Pin-location")?.resizedImage(newSize: CGSize(width: 30, height: 30))
        return annotationView
    }
}

// MARK: - UIImage Extension for resizing images
extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
