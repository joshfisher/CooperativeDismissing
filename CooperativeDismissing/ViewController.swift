import UIKit

class ViewController: UIViewController {
    private let customTransitionDelegate = TransitionDelegate()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.grayColor()
        let tap = UITapGestureRecognizer(target: self, action: "tapped:")
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapped(tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .Ended {
            let second = SecondViewController()
            second.modalPresentationStyle = .Custom
            second.transitioningDelegate = customTransitionDelegate
            presentViewController(second, animated: true, completion: nil)
        }
    }
}