
import UIKit
import LTSwiftDate

public extension NSDate {
    
    public static var timestampNow: Int {
        return NSDate().timestamp
    }
    
    public var timestamp: Int {
        return Int(self.timeIntervalSince1970)
    }
    
    public convenience init(timestamp: Int) {
        self.init(timeIntervalSince1970: NSTimeInterval(timestamp))
    }
    
    public func isToday() -> Bool {
        return isEqualToDate(NSDate(), ignoreTime: true)
    }
    
    public func toDateString() -> String {
        return toString(format: "MMM d, yyyy")
    }
}

