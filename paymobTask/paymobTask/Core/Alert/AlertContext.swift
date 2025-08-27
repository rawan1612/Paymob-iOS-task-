import UIKit

struct AlertItem {
    let title: String
    let message: String
    let dismissButton: UIAlertAction 
    let secondaryButton: UIAlertAction?
    let secondaryButtonAction: (() -> Void)?
    
    // Initialize with default values for optional secondary button/action
    init(title: String,
         message: String,
         dismissButton: UIAlertAction,
         secondaryButton: UIAlertAction? = nil,
         secondaryButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
        self.secondaryButton = secondaryButton
        self.secondaryButtonAction = secondaryButtonAction
    }
    
    // Helper to create and configure a UIAlertController
    func makeAlertController() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add dismiss button
        alert.addAction(dismissButton)
        
        // Add secondary button if it exists
        if let secondaryButton = secondaryButton {
            // If there's a secondary button action, wrap it in the UIAlertAction's handler
            let action = UIAlertAction(title: secondaryButton.title,
                                     style: secondaryButton.style,
                                     handler: { _ in secondaryButtonAction?() })
            alert.addAction(action)
        }
        
        return alert
    }
}

struct AlertContext {
    static let invalidUrl = AlertItem(
        title: "Server Error",
        message: "The URL you made a request with is an Invalid URL.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
    
    static let invalidData = AlertItem(
        title: "Server Error",
        message: "The data received from the request is invalid.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
    
    static let invalidResponse = AlertItem(
        title: "Server Error",
        message: "The response received from the request is invalid.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
    
    static let unableToComplete = AlertItem(
        title: "Server Error",
        message: "Unable to complete sending request and getting response.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
    
    static let invalidFormInput = AlertItem(
        title: "Invalid Input",
        message: "Unable to save data; some of your personal info is invalid. Please enter valid data.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
    
    static let invalidEmail = AlertItem(
        title: "Invalid Email",
        message: "Unable to save data; your email is invalid. Please enter a valid email.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
    
    static let accountCreated = AlertItem(
        title: "Account Created",
        message: "Account data saved successfully.",
        dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil)
    )
}
