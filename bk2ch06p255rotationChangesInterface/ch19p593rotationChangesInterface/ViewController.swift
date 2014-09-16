
import UIKit

class ViewController : UIViewController {
    lazy var blackRect : UIView = self.makeBlackRect()
    
    func makeBlackRect() -> UIView {
        var f = self.view.bounds
        // but there's just one little problem :)
        // if we are called in portrait orientation, need to swap width and height
        // otherwise we get 1/3 of portrait width, and height for portrait height...
        // for a view that is supposed to fit correctly into landscape only
        if self.traitCollection.verticalSizeClass != .Compact {
            (f.size.width, f.size.height) = (f.size.height, f.size.width)
        }
        f.size.width /= 3.0
        f.origin.x = -f.size.width
        let br = UIView(frame:f)
        br.backgroundColor = UIColor.blackColor()
        return br
    }
    
    /*
    
    Possibly useful facts:
    
    "size" is received on every rotation where the app rotates, 
    but "trait" is received only if there is a trait *change* (e.g. between portrait and landscape)
    
    if both are received, "trait" is first
    
    */
    
    // "willAnimateRotation" etc. are deprecated
    // can capture rotation stages by watching for the trait collection change
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("will transition to trait collection")
        let v = self.blackRect
        var newFrameOriginX = v.frame.origin.x
        if newCollection.verticalSizeClass == .Compact { // landscape
            if v.superview == nil {
                self.view.addSubview(v)
                newFrameOriginX = 0 // set into variable so we can animate change
            }
        } else { // portrait
            if v.superview != nil {
                newFrameOriginX = -v.frame.size.width // ditto
            }
        }
        coordinator.animateAlongsideTransition({
            _ in
            v.frame.origin.x = newFrameOriginX // animate the change in position!
            }, completion: {
                _ in
                if newCollection.verticalSizeClass != .Compact {
                    self.blackRect.removeFromSuperview() // now offscreen, remove
                }
            })
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("will transition to size")
    }


    
    
}
