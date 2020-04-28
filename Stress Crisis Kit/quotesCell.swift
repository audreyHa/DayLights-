//
//  quotesCell.swift
//  DayLights
//
//  Created by Audrey Ha on 9/8/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Firebase

class quotesCell: UITableViewCell {

    @IBOutlet weak var quotesLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var quote: String!
    var author: String!
    @IBOutlet weak var subBack: UIView!
    
    @IBAction func bookmarkButtonPressed(_ sender: Any) {
        if bookmarkButton.imageView!.image==UIImage(imageLiteralResourceName: "bookmark"){
            Analytics.logEvent("savedQuote", parameters: nil)
            
            print("bookmarking")
            var newQuote=CoreDataHelper.newQuote()
            newQuote.quote=self.quote
            newQuote.author=self.author
            CoreDataHelper.saveDaylight()

            NotificationCenter.default.post(name: Notification.Name("reloadQuotesArray"), object: nil)
        }else{
            print("un-bookmarking")
            var allQuotes=CoreDataHelper.retrieveQuote()
            var currentIndexPath=getIndexPath()
            
            for savedQuote in allQuotes{
                if savedQuote.quote! == self.quote{
                    CoreDataHelper.delete(quote: savedQuote)
                    CoreDataHelper.saveDaylight()
                }
            }

            NotificationCenter.default.post(name: Notification.Name("reloadQuotesArray"), object: nil)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        var myIndexPath = superView.indexPath(for: self)
        return myIndexPath
    }
}
