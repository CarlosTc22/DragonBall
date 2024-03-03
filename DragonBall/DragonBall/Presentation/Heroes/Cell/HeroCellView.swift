//
//  HeroCellView.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import UIKit
import Kingfisher

class HeroCellView: UITableViewCell {
    // Estimated height for the cell, used to calculate the size of cells in the tableView.
    static let estimatedHeight: CGFloat = 256
    // Reusable identifier for the cell, used when registering and dequeuing the cell in the tableView.
    static let identifier: String = "HeroCellView"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        heroDescription.text = nil
        photo.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure the appearance of the container view.
        containerView.layer.cornerRadius = 8.0
        containerView.layer.borderWidth = 1.0 // Add a border width
        containerView.layer.borderColor = UIColor.cellBorderColor.cgColor // Use the custom border color
        containerView.layer.shadowColor = UIColor.black.cgColor // A more subtle shadow color
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2) // Slight vertical shadow
        containerView.layer.shadowRadius = 4.0 // Reduced radius for a subtle effect
        containerView.layer.shadowOpacity = 0.1 // Less opacity for a lighter shadow
        
        // Configure the appearance of the photo to round the top corners.
        photo.layer.cornerRadius = 20.0
        photo.contentMode = .scaleAspectFill
        photo.layer.borderWidth = 1.5 // A subtle border for the photo
        photo.layer.borderColor = UIColor.cellBorderColor.cgColor // Matching the cell border
        
        // Style the name label
        name.font = UIFont.systemFont(ofSize: 18, weight: .semibold) // Use a semibold font
        name.textColor = UIColor.heroNameColor // Use the custom text color
        
        // Style the hero description label
        heroDescription.font = UIFont.systemFont(ofSize: 14, weight: .regular) // A lighter font for description
        heroDescription.textColor = UIColor.heroDescriptionColor // Use the custom text color
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // Add some line spacing for readability
        heroDescription.attributedText = NSAttributedString(string: heroDescription.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        selectionStyle = .none // Disable selection style for the cell.
    }
    
    // Update the cell with the provided hero data.
    func updateWith(name: String? = nil, photoURL: String? = nil, about: String? = nil) {
        self.name.text = name
        // Set attributed text with line spacing for heroDescription
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // Keep line spacing consistent
        if let aboutText = about {
            let attributedString = NSAttributedString(string: aboutText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            self.heroDescription.attributedText = attributedString
        } else {
            self.heroDescription.text = about
        }
        // Set the image with a custom placeholder
        self.photo.kf.setImage(with: URL(string: photoURL ?? ""), placeholder: UIImage(named: "customPlaceholderImage")) // Use a better placeholder image name
    }
}

extension UIColor {
    static let heroNameColor = UIColor.black // A color for the hero name label
    static let heroDescriptionColor = UIColor.darkGray // A color for the hero description label
    static let cellBorderColor = UIColor(white: 0.9, alpha: 1.0) // A border color for the cell
}
