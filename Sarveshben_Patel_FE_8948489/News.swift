import UIKit

class NewsViewController: UITableViewController {

    @IBOutlet weak var newsDataFromAPI: UITableView!
            
    var redirectToNewsPage : String?
            private var newsData: [NewsCellStruct] = []

            override func viewDidLoad() {
                super.viewDidLoad()
                newsDataFromAPI.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")

                if let city = redirectToNewsPage {
                    callNewsData(city: city)
                }
                else{
                    callNewsData(city: "Waterloo")
                }
                newsDataFromAPI.rowHeight = UITableView.automaticDimension
                newsDataFromAPI.estimatedRowHeight = 100
            }
            
            // to fetch news data from NewsAPI.org
            private func callNewsData(city: String) {
    
                let apiKey = "93336e2faf3c49a3b20b3db8cdcce72d"
                    
                // Form the URL with the selected city and API key
                let urlString = "https://newsapi.org/v2/everything?q=\(city)&apiKey=\(apiKey)"
                    
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                        if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                                self?.newsData = newsResponse.articles
                                    
                                // Update UI on the main thread
                                DispatchQueue.main.async {
                                    self?.tableView.reloadData()
                                }
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        }
                    }.resume()
                }
            }
            
            // to show an alert for changing the city
            private func displayCityAlert() {
                let alertController = UIAlertController(title: "Change City", message: "Enter the city name", preferredStyle: .alert)
                    
                alertController.addTextField { textField in
                    textField.placeholder = "City"
                }
                    
                let addAction = UIAlertAction(title: "Change", style: .default) { [weak self] _ in
                    if let cityName = alertController.textFields?.first?.text {
                        self?.callNewsData(city: cityName)
                    }
                }
                    
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                alertController.addAction(addAction)
                alertController.addAction(cancelAction)
                    
                present(alertController, animated: true, completion: nil)
            }
        
    //Enter City Button
        @IBAction func enterCityButton(_ sender: UIBarButtonItem) {
            displayCityAlert()
        }
        
            override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return newsData.count
            }

            override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNewsData", for: indexPath) as! NewsTableViewCell
                
                let newsArticle = newsData[indexPath.row]
                cell.configure(with: newsArticle)
                
                return cell
            }

            override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                // Handle row selection if needed
            }
            
            override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                    return UITableView.automaticDimension
            }

}

//Structures
struct NewsResponse: Codable {
    let articles: [NewsCellStruct]
}


struct NewsCellStruct: Codable {
    let title: String
    let description: String
    let author: String?
    let source: SourceDataSturct
}

struct SourceDataSturct: Codable {
    let id: String?
    let name: String
}
