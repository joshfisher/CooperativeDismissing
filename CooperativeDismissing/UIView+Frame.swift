import UIKit

extension CGRect {
    init(copy: CGRect, x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.init(
            x: x ?? copy.origin.x,
            y: y ?? copy.origin.y,
            width: width ?? copy.size.width,
            height: height ?? copy.size.height)
    }
    
    func copy(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> CGRect {
        return CGRect(copy: self, x: x, y: y, width: width, height: height)
    }
}

extension UIView {
    var top: CGFloat {
        get { return CGRectGetMinY(frame) }
        set { frame = frame.copy(y: newValue) }
    }
    
    var bottom: CGFloat {
        get { return CGRectGetMaxY(frame) }
        set { frame = frame.copy(y: newValue - CGRectGetHeight(frame)) }
    }
}