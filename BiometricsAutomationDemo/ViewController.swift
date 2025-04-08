

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet private var biometricsStateLabel: UILabel!
    @IBOutlet private var authenticateButton: UIButton!
    
    @IBAction private func authenticateButtonTapped(_ sender: UIButton) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Authenticate now!",
                               reply:
                                //call back
                                { success, error in
            let title = success ? "Authenticated successfully!" : "Authentication failed. \nFall back to Password/PIN authentication"
            let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                controller.dismiss(animated: true)
            }))
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
        
        setupBioStateLabel()
        if isBiometryAvailable {
            handleBiometryAvailable()
            authenticateButton.isHidden = false
        } else {
            handleBiometryUnavailable()
            authenticateButton.isHidden = true
        }
    }
    
    private func setupBioStateLabel() {
        biometricsStateLabel.font = .systemFont(ofSize: 17, weight: .medium)
        biometricsStateLabel.textColor = .black
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

