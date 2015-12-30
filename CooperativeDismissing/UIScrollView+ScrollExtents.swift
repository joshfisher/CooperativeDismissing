import UIKit

extension UIScrollView {
    var maxScroll: CGFloat {
        return max(contentSize.height - frame.size.height, 0.0)
    }
}