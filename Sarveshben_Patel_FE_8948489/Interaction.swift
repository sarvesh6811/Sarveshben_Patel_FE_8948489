import Foundation

struct Interaction {
    enum Source: String {
        case home = "Home"
        case news = "News"
        case map = "Map"
        case weather = "Weather"
    }
    
    enum InteractionType: String {
        case news = "News"
        case weather = "Weather"
        case map = "Map"
    }
    
    var source: Source
    var type: InteractionType
    var details: String
    var dateTime: Date

    var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }

    var displayDetails: String {
        return "\(formattedDateTime) - \(details)"
    }
}
