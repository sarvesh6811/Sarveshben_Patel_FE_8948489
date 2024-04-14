//
//import UIKit
//
//class HistoryViewController: UITableViewController {
//    var searchHistory: [Interaction] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
//        preloadSearchHistory()
//    }
//
//    func preloadSearchHistory() {
//
//        let cities = ["Toronto", "Montreal", "Vancouver", "Calgary", "Ottawa"]
//        for city in cities {
//            let weatherDetails = "Date/Time: \(Date()), Weather:  \(city)"
//            let searchInteraction = Interaction(source: .weather, type: .weather, details: weatherDetails, dateTime: Date())
//            searchHistory.append(searchInteraction)
//        }
//
//        let newsDetails = "ABBA Fans Celebrate"
//        let newsInteraction = Interaction(source: .news, type: .news, details: newsDetails, dateTime: Date())
//        searchHistory.append(newsInteraction)
//
//
//        let mapDetails = "Start: Brampton, End: Toronto, Mode: Driving, Distance: 44 km"
//        let mapInteraction = Interaction(source: .map, type: .map, details: mapDetails, dateTime: Date())
//        searchHistory.append(mapInteraction)
//
//        tableView.reloadData()
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchHistory.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
//        let interaction = searchHistory[indexPath.row]
//        cell.configure(with: interaction)
//        return cell
//    }
//}
//

import UIKit

class HistoryViewController: UITableViewController {
    var searchHistory: [Interaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        preloadSearchHistory()
    }

    func preloadSearchHistory() {
        let cities = ["Toronto", "Montreal", "Vancouver", "Calgary", "Ottawa"]
        for city in cities {
            let weatherDetails = "Date/Time: \(Date()), Weather: \(city)"
            let searchInteraction = Interaction(source: .weather, type: .weather, details: weatherDetails, dateTime: Date())
            searchHistory.append(searchInteraction)
        }

        let newsDetails = "ABBA Fans Celebrate"
        let newsInteraction = Interaction(source: .news, type: .news, details: newsDetails, dateTime: Date())
        searchHistory.append(newsInteraction)

        let mapDetails = "Start: Brampton, End: Toronto, Mode: Driving, Distance: 44 km"
        let mapInteraction = Interaction(source: .map, type: .map, details: mapDetails, dateTime: Date())
        searchHistory.append(mapInteraction)

        tableView.reloadData()
    }
    func saveInteraction(_ interaction: Interaction) {
            // Append the interaction to your search history array
            searchHistory.append(interaction)
            // Reload your table view or update your UI as needed
            tableView.reloadData()
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let interaction = searchHistory[indexPath.row]
        cell.configure(with: interaction)
        return cell
    }
}
