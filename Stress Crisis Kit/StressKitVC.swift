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
import Contacts
import MessageUI
import Firebase

class StressKitVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet weak var threeQuotesLabel: UILabel!
    @IBOutlet weak var funnyImagesLabel: UILabel!
    @IBOutlet weak var motivationalSpeechLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    @IBOutlet weak var phoneNumbersTBV: UITableView!
 
    @IBOutlet weak var quotesTBV: UITableView!
    
    @IBOutlet weak var speechTBV: UITableView!
    
    @IBOutlet weak var contactTBV: UITableView!
    
    @IBOutlet weak var quotesSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var funnyCollectionView: UICollectionView!
    
    var funnyImages=[FunnyImage]()
    
    var organizations=[Organization]()
    var quotes=[String]()
    var authors=[String]()
    
    var savedQuotes=[String]()
    var savedAuthors=[String]()
    
    var speeches=[Speech]()
    var contacts=[Contact]()
    
    var segmentedNumber=0
    var indexPathToScrollTo: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var labels=[threeQuotesLabel, funnyImagesLabel, motivationalSpeechLabel, phoneNumberLabel]
        
        for label in labels{
            label?.adjustsFontSizeToFitWidth=true
        }
        
        var tbvs=[quotesTBV, speechTBV, contactTBV]
        
        for tbv in tbvs{
            if tbv != contactTBV{
                tbv!.estimatedRowHeight = 80
                tbv!.rowHeight = UITableView.automaticDimension
            }

            tbv!.layer.cornerRadius=10
            tbv!.delegate=self
            tbv!.dataSource=self
            
            if tbv != speechTBV{
                tbv!.allowsSelection=false
            }
        }
        
        funnyCollectionView.delegate=self
        funnyCollectionView.dataSource=self
        
        var layout=funnyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset=UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        layout.minimumInteritemSpacing=0
        layout.itemSize=CGSize(width: (funnyCollectionView.frame.size.width-15)/2, height: (funnyCollectionView.frame.size.width-15)/2)
        
        if(UserDefaults.standard.bool(forKey: "setUpStressData")==false){
            var hopelineNetwork=CoreDataHelper.newOrg()
            hopelineNetwork.organizationName="National Hopeline Network"
            hopelineNetwork.orgDescription="Helps people dealing with depression and those thinking about suicide: 24/7"
            hopelineNetwork.contact="1-800-422-4673"
            
            
            var parent=CoreDataHelper.newOrg()
            parent.organizationName="National Parent Hotline"
            parent.orgDescription="Emotional support for parents from a trained advocate: 24/7"
            parent.contact="855-427-2736"
            
            var motivationalSpeech=CoreDataHelper.newSpeech()
            motivationalSpeech.dateModified=Date()
            motivationalSpeech.title="Martin Luther King Jr: \"What Is Your Life's Blueprint?\" (abridged)"
            motivationalSpeech.speech="This is the most important and crucial period of your lives, for what you do now and what you decide now at this age may well determine which way your life shall go. And the question is, whether you have a proper, a solid, and a sound blueprint.\n\nAnd I want to suggest some of the things that should be in your life's blueprint. Number one in your life's blueprint should be a deep belief in your own dignity, your own worth, and your own somebodiness. Don't allow anybody to make you feel that you are nobody. Always feel that you count. Always feel that you have worth, and always feel that your life has ultimate significance.\n\nSecondly, in your life's blueprint, you must have a basic principle: the determination to achieve excellence in your various fields of endeavor. You're going to be deciding as the days and the years unfold what you do in life, what your life's work will be. Once you discover what it will be, set out to do it and to do it well. Be a bush if you can't be a tree. If you can't be a highway, just be a trail. If you can't be the sun, be a star, for it isn't by size that you win or you fail. Be the best of whatever you are.\n\nFinally, in your life's blueprint, must be a commitment to the eternal principals of beauty, love, and justice. Well, life for none of us has been a crystal stair, but we must keep moving, we must keep going. If you can't fly, run. If you can't run, walk. If you can't walk, crawl. But by all means, keep moving."
            
            
            var dogLlamaImages=[UIImage(imageLiteralResourceName: "dog1"), UIImage(imageLiteralResourceName: "dog2"), UIImage(imageLiteralResourceName: "dog3"), UIImage(imageLiteralResourceName: "llama1"), UIImage(imageLiteralResourceName: "llama2")]
            
            var imageNames=["dog1", "dog2", "dog3", "llama1", "llama2"]
            var count=0
            
            for image in dogLlamaImages{
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                // choose a name for your image
                let fileName = "\(imageNames[count]).jpg"
                // create the destination file url to save your image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // get your UIImage jpeg data representation and check if the destination file url already exists
                if let data = image.jpegData(compressionQuality:  1.0),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // writes the image data to disk
                        try data.write(to: fileURL)
                        print("file saved")
                    } catch {
                        print("error saving file:", error)
                    }
                }
                
                var newImage=CoreDataHelper.newFunnyImage()
                newImage.imageFilename=fileName
                
                count+=1
            }
            
            CoreDataHelper.saveDaylight()
            UserDefaults.standard.set(true, forKey: "setUpStressData")
            funnyCollectionView.reloadData()
        }
        
        organizations=CoreDataHelper.retrieveOrg()
        
        getRandomQuotes()
        
        speeches=CoreDataHelper.retrieveSpeech()
        
        contacts=CoreDataHelper.retrieveContacts()
        
        funnyImages=CoreDataHelper.retrieveFunnyImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadQuotesArray(notification:)), name: Notification.Name("reloadQuotesArray"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.possiblyDeleteSpeech(notification:)), name: Notification.Name("possiblyDeleteSpeech"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadFunnyImages(notification:)), name: Notification.Name("reloadFunnyImages"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.permanentlyDeleteSpeech(notification:)), name: Notification.Name("permanentlyDeleteSpeech"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.permanentlyDeleteContact(notification:)), name: Notification.Name("permanentlyDeleteContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadSpeechTableView(notification:)), name: Notification.Name("reloadSpeechTableView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadContactTBV(notification:)), name: Notification.Name("reloadContactTBV"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.possiblyDeleteContact(notification:)), name: Notification.Name("possiblyDeleteContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textNumber(notification:)), name: Notification.Name("textNumber"), object: nil)
        
        //end of View Did Load
    }
    
    @objc func textNumber(notification: Notification){
        contacts=CoreDataHelper.retrieveContacts()
        
        var indexPathToText=UserDefaults.standard.integer(forKey: "phoneNumberToText")
        
        var phoneNumberToText=contacts[indexPathToText].phoneNumber!
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            print("phone number: \(phoneNumberToText)")
            controller.recipients = [phoneNumberToText]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAlphaNumericValue(yourString: String) -> String{
        let unsafeChars = CharacterSet.alphanumerics.inverted  // Remove the .inverted to get the opposite result.
        
        let cleanChars  = yourString.components(separatedBy: unsafeChars).joined(separator: "")
        return cleanChars
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func reloadContactTBV(notification: Notification){
        contacts=CoreDataHelper.retrieveContacts()
        contactTBV.reloadData()
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
    
        makeYesNoAlert()
    }
    
    @objc func possiblyDeleteContact(notification: Notification){
        UserDefaults.standard.set("deleteContact",forKey: "typeYesNoAlert")
        
        makeYesNoAlert()
    }
    
    func makeYesNoAlert(){
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
    
    @objc func permanentlyDeleteContact(notification: Notification){
        var indexPathToRemove=UserDefaults.standard.integer(forKey: "possiblyContactRow")
        var contactToRemove=contacts[indexPathToRemove]
        
        CoreDataHelper.delete(contact: contactToRemove)
        CoreDataHelper.saveDaylight()
        contacts=CoreDataHelper.retrieveContacts()
        contactTBV.reloadData()
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
                            
                            self.quotesTBV.reloadData()
                        }else{
                            self.quotes.append("\(randomQuoteText)")
                            self.authors.append("\(randomQuoteAuthor)")
                            
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

        if tableView==quotesTBV{
            
            if segmentedNumber==0{
                return quotes.count
            }else{
                return savedQuotes.count
            }
            
        }else if tableView==speechTBV{
            return speeches.count
        }else if tableView==contactTBV{
            return contacts.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==quotesTBV{
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
        }else if tableView==contactTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberCell", for: indexPath) as! PhoneNumberCell
            
            cell.nameLabel.text=contacts[indexPath.row].name!
            
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
    
    @IBAction func addPhoneNumber(_ sender: Any) {
        makeContactAlert()
    }
    
    func makeContactAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddContact") as! AddContactVC
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addFunnyImage(_ sender: Any) {
        let image=UIImagePickerController()
        image.delegate=self
        
        image.sourceType=UIImagePickerController.SourceType.photoLibrary
        
        image.allowsEditing=false
        
        self.present(image, animated: true){
            //after using picks image
            
            Analytics.logEvent("addFunnyImage", parameters: nil)
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

extension String {
    var removingWhitespacesAndNewlines: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func capitalizingFirstLetter() -> String{
        var stringArray=self.characters.split(separator: " ")
        for n in 0...stringArray.count-1{
            stringArray[n]=stringArray[n].prefix(1).uppercased() + stringArray[n].lowercased().dropFirst()
        }
        
        var combinedString=stringArray.joined(separator: " ")
        return combinedString
    }
}
