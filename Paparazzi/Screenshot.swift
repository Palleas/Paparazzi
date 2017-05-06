import Foundation

struct ScreenShot: AutoEquatable {
    
    let displayName: String
    
    let path: String
    
    let changedAt: Date
}

extension ScreenShot {
    static func create(item: NSMetadataItem) throws -> ScreenShot {
        guard let displayName = item.displayName else {
            throw MonitorError.missingAttribute(NSMetadataItemDisplayNameKey)
        }
        
        guard let path = item.path else {
            throw MonitorError.missingAttribute(NSMetadataItemPathKey)
        }
        
        guard let changedAt = item.contentChangedAt else {
            throw MonitorError.missingAttribute(NSMetadataItemFSContentChangeDateKey)
        }
        
        return ScreenShot(displayName: displayName, path: path, changedAt: changedAt)
    }
}

// TODO: Use sourcery's hashable
extension ScreenShot: Hashable {
    var hashValue: Int {
        return path.hashValue ^ displayName.hashValue
    }
}
