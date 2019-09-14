//
//  StressKitVC.swift
//  DayLights
//
//  Created by Audrey Ha on 9/8/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StressKitVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var phoneNumbersTBV: UITableView!
    
    @IBOutlet weak var crisisTBV: UITableView!
    
    @IBOutlet weak var quotesTBV: UITableView!
    
    @IBOutlet weak var speechTBV: UITableView!
    
    @IBOutlet weak var quotesSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var funnyCollectionView: UICollectionView!
    
    var funnyImages=[FunnyImage]()
    
    var organizations=[Organization]()
    var quotes=[String]()
    var authors=[String]()
    
    var savedQuotes=[String]()
    var savedAuthors=[String]()
    
    var speeches=[Speech]()
    
    var segmentedNumber=0
    var indexPathToScrollTo: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var tbvs=[crisisTBV, quotesTBV, speechTBV]
        for tbv in tbvs{
            tbv!.estimatedRowHeight = 80
            tbv!.rowHeight = UITableView.automaticDimension
            
            tbv!.layer.cornerRadius=10
            tbv!.delegate=self
            tbv!.dataSource=self
            
            if tbv != speechTBV{
                tbv!.allowsSelection=false
            }
        }
        
        funnyImages=CoreDataHelper.retrieveFunnyImage()
        funnyCollectionView.delegate=self
        funnyCollectionView.dataSource=self
        
        var layout=funnyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset=UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        layout.minimumInteritemSpacing=0
        layout.itemSize=CGSize(width: (funnyCollectionView.frame.size.width-15)/2, height: (funnyCollectionView.frame.size.width-15)/2)
        
        if(UserDefaults.standard.bool(forKey: "setUpOrganizations")==false){
            var crisisTextLine=CoreDataHelper.newOrg()
            crisisTextLine.organizationName="Crisis Text Line"
            crisisTextLine.orgDescription="Text HOME to 741-741: 24/7"
            crisisTextLine.contact=""
            
            var hopelineNetwork=CoreDataHelper.newOrg()
            hopelineNetwork.organizationName="National Hopeline Network"
            hopelineNetwork.orgDescription="Helps people dealing with depression and those thinking about suicide: 24/7"
            hopelineNetwork.contact="1-800-422-4673"
            
            
            var parent=CoreDataHelper.newOrg()
            parent.organizationName="National Parent Hotline"
            parent.orgDescription="Emotional support for parents from a trained advocate: 24/7"
            parent.contact="855-427-2736"
            
            CoreDataHelper.saveDaylight()
            
            UserDefaults.standard.set(true, forKey: "setUpOrganizations")
        }
        
        organizations=CoreDataHelper.retrieveOrg()
        
        getRandomQuotes()
        
        speeches=CoreDataHelper.retrieveSpeech()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadQuotesArray(notification:)), name: Notification.Name("reloadQuotesArray"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.possiblyDeleteSpeech(notification:)), name: Notification.Name("possiblyDeleteSpeech"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadFunnyImages(notification:)), name: Notification.Name("reloadFunnyImages"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.permanentlyDeleteSpeech(notification:)), name: Notification.Name("permanentlyDeleteSpeech"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadSpeechTableView(notification:)), name: Notification.Name("reloadSpeechTableView"), object: nil)
    }

    @objc func reloadQuotesArray(notification: Notification){
        print("reloading quotes array")
        matchQuotesSegment()
    }
    
    @objc func reloadSpeechTableView(notification: Notification){
        speeches=CoreDataHelper.retrieveSpeech()
        speechTBV.reloadData()
    }
    
    @objc func possiblyDeleteSpeech(notification: Notification){
        UserDefaults.standard.set("deleteSpeech",forKey: "typeYesNoAlert")
    
        let vc = storyboard!.instantiateViewController(withIdentifier: "YesNoAlert") as! YesNoAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc func permanentlyDeleteSpeech(notification: Notification){
        var indexPathToRemove=UserDefaults.standard.integer(forKey: "possiblyDeleteSpeechRow")
        var speechToRemove=speeches[indexPathToRemove]
        
        CoreDataHelper.delete(speech: speechToRemove)
        CoreDataHelper.saveDaylight()
        speeches=CoreDataHelper.retrieveSpeech()
        speechTBV.reloadData()
    }
    
    @objc func reloadFunnyImages(notification: Notification){
        funnyImages=CoreDataHelper.retrieveFunnyImage()
        funnyCollectionView.reloadData()
    }
    
    func getRandomQuotes(){
        for i in 0...2{
            let apiToContact = "https://api.quotable.io/random"
            
            Alamofire.request(apiToContact).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        var randomQuoteText=json["content"]
                        var randomQuoteAuthor=json["author"]
                        
                        if randomQuoteAuthor=="Donald Trump"{
                            self.quotes.append("Do not judge me by my successes, judge me by how many times I fell down and got back up again.")
                            self.authors.append("Nelson Mandela")
                            
                            print(self.quotes)
                            self.quotesTBV.reloadData()
                        }else{
                            self.quotes.append("\(randomQuoteText)")
                            self.authors.append("\(randomQuoteAuthor)")
                            
                            print(self.quotes)
                            self.quotesTBV.reloadData()
                        }
                        
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func matchQuotesSegment(){
        if quotesSegmentedControl.selectedSegmentIndex==0{
            print("segment number is 0")
            segmentedNumber=0
        }else{
            print("segment number is 1")
            segmentedNumber=1
            
            var allSavedQuotes=CoreDataHelper.retrieveQuote()
            savedQuotes=[]
            savedAuthors=[]
            
            for savedQuote in allSavedQuotes{
                savedQuotes.append(savedQuote.quote!)
                savedAuthors.append(savedQuote.author!)
            }
        }
        
        quotesTBV.reloadData()
    }
    
    @IBAction func quotesSegmentChanged(_ sender: Any) {
        matchQuotesSegment()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == crisisTBV{
            return organizations.count
        }else if tableView==quotesTBV{
            
            if segmentedNumber==0{
                return quotes.count
            }else{
                return savedQuotes.count
            }
            
        }else if tableView==speechTBV{
            return speeches.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == crisisTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell", for: indexPath) as! OrganizationCell

            let organization=self.organizations[indexPath.row]
            var brightRed = UIColor(red: 232.0/255.0, green: 90.0/255.0, blue: 69.0/255.0, alpha: 1.0)
            var teal = UIColor(red: 41.0/255.0, green: 220.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell.orgName.textColor=brightRed
            
            cell.orgName.text=organization.organizationName
            cell.orgDesc.text=organization.orgDescription
            cell.contact.text=organization.contact

            return cell
        }else if tableView==quotesTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCell", for: indexPath) as! quotesCell
            
            let formattedString = NSMutableAttributedString()
            
            var quoteToUse: String
            var authorToUse: String
            
            if segmentedNumber==1{
                quoteToUse=savedQuotes[indexPath.row]
                authorToUse=savedAuthors[indexPath.row]
            }else{
                quoteToUse=quotes[indexPath.row]
                authorToUse=authors[indexPath.row]
            }
            
            formattedString.normal("\(quoteToUse) -- ").bold("\(authorToUse)")
            
            cell.quotesLabel.attributedText = formattedString
            cell.quote=quoteToUse
            cell.author=authorToUse
            
            cell.bookmarkButton.setImage(UIImage(imageLiteralResourceName: "bookmark"), for: .normal)
            
            var allQuotes=CoreDataHelper.retrieveQuote()
            
            for savedQuote in allQuotes{
                if savedQuote.quote! == quoteToUse{
                    cell.bookmarkButton.setImage(UIImage(imageLiteralResourceName: "filledBookmark"), for: .normal)
                }
            }
            
            return cell
        }else if tableView==speechTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpeechCell", for: indexPath) as! SpeechCell
            
            let speech=self.speeches[indexPath.row]
            cell.speechTitleLabel.text=speech.title
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yy"
            
            cell.dateCreated.text=dateformatter.string(from: speech.dateModified!)

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCell", for: indexPath) as! quotesCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView==speechTBV{
            self.performSegue(withIdentifier: "oldSpeech", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Funny images count \(funnyImages.count)")
        return funnyImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=funnyCollectionView.dequeueReusableCell(withReuseIdentifier: "FunnyImageCell", for: indexPath) as! FunnyImageCell

        var filename=funnyImages[indexPath.row].imageFilename
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(filename!)
            let funnyImage = UIImage(contentsOfFile: imageURL.path)
            
            var copyToCrop=funnyImage
            
            let imageWidth = copyToCrop!.size.width
            let imageHeight = copyToCrop!.size.height
            var smallerValue = imageWidth
            
            if imageHeight<imageWidth{
                smallerValue=imageHeight
            }
            
            let origin = CGPoint(x: (imageWidth - smallerValue)/2, y: (imageHeight - smallerValue)/2)
            let size = CGSize(width: smallerValue, height: smallerValue)
            
            copyToCrop=copyToCrop!.crop(rect: CGRect(origin: origin, size: size))
            
            cell.funnyImageView.image=copyToCrop
            
            cell.funnyImageView.frame=cell.bounds
            
            cell.funnyImageView.layer.cornerRadius=10
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "indexPathToScrollTo")
        self.performSegue(withIdentifier: "expandFunnyImage", sender: nil)
    }
    
    @IBAction func addFunnyImage(_ sender: Any) {
        let image=UIImagePickerController()
        image.delegate=self
        
        image.sourceType=UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing=false
        
        self.present(image, animated: true){
            //after using picks image
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // choose a name for your image
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM--dd/hh:mm:ss"
            let dateDrawingGame=dateformatter.string(from: Date())
            
            let fileName = "\(getAlphaNumericValue(yourString: dateDrawingGame)).jpg"
            print("file name: \(fileName)")
            
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = image.jpegData(compressionQuality:  1.0),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("funny image saved")
                    
                    var newFunnyImage=CoreDataHelper.newFunnyImage()
                    newFunnyImage.imageFilename=fileName
                    
                    CoreDataHelper.saveDaylight()
                    NotificationCenter.default.post(name: Notification.Name("reloadFunnyImages"), object: nil)
                } catch {
                    print("error saving file:", error)
                }
            }
        }else{
            print("error with saving the image!!!")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAlphaNumericValue(yourString: String) -> String{
        let unsafeChars = CharacterSet.alphanumerics.inverted  // Remove the .inverted to get the opposite result.
        
        let cleanChars  = yourString.components(separatedBy: unsafeChars).joined(separator: "")
        return cleanChars
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier,
            let destination = segue.destination as? SpeechAlert
            else { return }
        
        switch identifier {
            // 2
            
        case "oldSpeech":
            var speechToEdit: Speech
            guard let indexPath = speechTBV.indexPathForSelectedRow else { return }
            
            let destination = segue.destination as! SpeechAlert
            // 4
            destination.speech = speeches[indexPath.row]
        case "addSpeech":
            print("adding completely new speech")
        default:
            print("unexpected segue identifier")
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        var darkBlue=UIColor(rgb: 0x007ebd)
        
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 19)!,
                                                    .foregroundColor: UIColor(cgColor: darkBlue.cgColor)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
