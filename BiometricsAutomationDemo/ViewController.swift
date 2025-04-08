

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet private var biometricsStateLabel: UILabel!
    @IBOutlet private var authenticateButton: UIButton!
    
    @IBAction private func authenticateButtonTapped(_ sender: UIButton) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Authenticate now!",
                               reply: { success, error in
            let title = success ? "Authenticated successfully!" : "Authentication failed. \(error)"
            let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            DispatchQueue.main.async() {
                self.present(controller, animated: true)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let context = LAContext()
        var error: NSError?
        let errorPointer: NSErrorPointer = NSErrorPointer(&error)
        let isBiometryAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                            error: errorPointer)
        if isBiometryAvailable {
            handleBiometryAvailable()
        } else {
            handleBiometryUnavailable()
        }
    }
    
    private func handleBiometryAvailable() {
        biometricsStateLabel.text = "Biometrics available"
        authenticateButton.isEnabled = true
    }
    
    private func handleBiometryUnavailable() {
        biometricsStateLabel.text = "Biometrics unavailable"
        authenticateButton.isEnabled = false
    }
}

