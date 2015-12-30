import UIKit

class SecondViewController: UIViewController {
    private lazy var tableView = UITableView()
    private var contentOffsetLock: CGPoint?
    
    override func viewDidLoad() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150.0
        tableView.separatorStyle = .None
        tableView.bounces = false
        view.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    @objc private func tapped(tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .Ended {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None

        let r = CGFloat(arc4random_uniform(55) + 200) / 255.0
        let g = CGFloat(arc4random_uniform(55) + 200) / 255.0
        let b = CGFloat(arc4random_uniform(55) + 200) / 255.0
        cell.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)

        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let lock = contentOffsetLock {
            scrollView.contentOffset = lock
        }
    }
}

extension SecondViewController: CooperativeDismissing {
    func canDismissInDirection(direction: Direction) -> Bool {
        switch direction {
        case .Up: return tableView.contentOffset.y <= 0.0
        case .Down: return tableView.contentOffset.y >= tableView.maxScroll
        }
    }
    
    func willBeginDismissing() {
        contentOffsetLock = tableView.contentOffset
    }
    
    func didCancelDismissing() {
        contentOffsetLock = nil
    }
}