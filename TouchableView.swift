//
//  TouchableView.swift
//
//  Created by Ahmadreza on 1/22/1400 AP.
//

import UIKit

class TouchableView: UIView, UIGestureRecognizerDelegate {

    var horizontallyFlipped = false
    var onNormal = {} /* Called when the view goes to normal state (set desired appearance) */
    var onPressed = {} /* Called when the view goes to pressed state (set desired appearance) */
    var onReleased = {} /* Called when the view is released (perform desired action) */
    var touchUpInside: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(touched(sender:)))
        recognizer.delegate = self
        recognizer.minimumPressDuration = 0.0
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        onNormal()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil {
            removeGestureRecognizer()
        }
    }
    
    deinit {
//        Print("--- TouchableView Deinit")
    }
    
    func removeGestureRecognizer() {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(touched(sender:)))
        recognizer.delegate = nil
        removeGestureRecognizer(recognizer)
    }
    
    @objc func touched(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            onPressed()
            shrink()
        } else if sender.state == .ended {
            onNormal()
            onReleased()
            restore()
            let touchLocation = sender.location(in: self)
            if frame.contains(convert(touchLocation, to: superview)) { // MARK: to detect if touch canceled
                if let buttonAction = self.touchUpInside {
                    buttonAction()
                }
            }
        } else if sender.state == .cancelled { // MMARK: this never is calling due to being a long press
            onNormal()
            restore()
        }
    }
    
    func shrink() {
        lightVibrate()
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: self.horizontallyFlipped ? -0.95 : 0.95, y: 0.95)
            self.layoutIfNeeded()
        }
    }
    
    func restore() {
        UIView.animate(withDuration: 0.3) { [self] in
            self.transform = CGAffineTransform(scaleX: self.horizontallyFlipped ? -1 : 1, y: 1)
            self.layoutIfNeeded()
        }
    }
}
