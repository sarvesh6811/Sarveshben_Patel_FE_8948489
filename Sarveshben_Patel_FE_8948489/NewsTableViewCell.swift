

import UIKit

class NewsTableViewCell: UITableViewCell {
                @IBOutlet private weak var labelForTitle: UILabel!
                @IBOutlet private weak var labelForDescription: UILabel!
               @IBOutlet private weak var labelForSouce: UILabel!
               @IBOutlet private weak var labelOfAuthor: UILabel!
               func configure(with article: NewsCellStruct)
               {
                   labelForTitle?.text = article.title
                    labelForDescription?.text = article.description
                       labelOfAuthor?.text = "Author: \(article.author ?? "N/A")"
                       labelForSouce?.text = "Source: \(article.source.name)"
                   labelForTitle?.numberOfLines = 0
                       labelForDescription?.numberOfLines = 0
                   labelOfAuthor?.numberOfLines = 0
                   labelForSouce?.numberOfLines = 0
               }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

 

    }

}

