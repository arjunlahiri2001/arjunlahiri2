//
//  MainViewController.swift
//  wMutater
//
//  Created by Arjun Lahiri on 17/08/2017.
//  Copyright © 2017 Arjun Lahiri. All rights reserved.
//

import UIKit
import AVFoundation

















// First dictionary maps words to a sequence number (use this to check if a word exists)
var dctWord = [String: Int]();

// Second dictionary maps numbers to words (use this to generate a random word)
var dctNum = [Int:String]();

var Scores = [Int]()
var HighScores = [Int]()
var savedScore = 0
 


var player:AVAudioPlayer = AVAudioPlayer()
var player1:AVAudioPlayer = AVAudioPlayer()
var player2:AVAudioPlayer = AVAudioPlayer()

// high scores

var timesVisited = 0

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 0/255, blue: 205/255, alpha: 1)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    
    return true
}

 
func InitDictionary(fileName: String) -> Int
{
  
    
//    print(UIDevice.current.model)
    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    
    if((screenWidth < 768 && screenWidth >= 414) && (screenHeight < 1024 && screenHeight >= 736)){
        
        
    }
    
    print(screenWidth)
    print(screenHeight)
    
    print(Bundle.main.resourceURL!)
    let path2 = Bundle.main.path(forResource: "words", ofType: "txt")
    if (path2 != nil) {
        do {
            let data = try String(contentsOfFile: path2!, encoding: .utf8)
            let myWords = data.components(separatedBy: .newlines)
            var iter = 0
            var lowerWord = String()
            for word in myWords {
                // Now populate dictionary from myWords 
                
                if(word.count > 1){
                    lowerWord = word.lowercased()
                    dctWord[lowerWord] = iter
                    dctNum[iter] = lowerWord
                    iter += 1
                }
            }
            
            print("Inserted", iter, "elements")
        } catch {
            print(error)
        }
    }
    
    return 0;
}

class MainViewController: UIViewController , UIPageViewControllerDelegate{
    
    
    var pageViewController: UIPageViewController?
    
    @IBOutlet weak var descriptionParagraph: UILabel!
    
    open override var shouldAutorotate: Bool{
        get{
            return false
        }
    }
    
    private var _orientations = UIInterfaceOrientationMask.portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }
    @objc var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBAction func playGame(_ sender: Any) {
       
        
         performSegue(withIdentifier: "segue", sender: self)
        
    }
    
    override func viewDidLoad() {
        let deviceType = String(UIDevice.current.model)

        if(deviceType.contains("iPad") != false ){
            descriptionParagraph.font = UIFont.systemFont(ofSize: 30)
            
            
            
            
        }
        timesVisited += 1
            //reference sound file for the game
        if(timesVisited == 1){
            do{
                let audioPath = Bundle.main.path(forResource: "correctSound", ofType: "wav")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                
                let audioPath1 = Bundle.main.path(forResource: "backgroundSong", ofType: "mp3")
                try player1 = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath1!) as URL)
                
                let audioPath2 = Bundle.main.path(forResource: "error", ofType: "wav")
                try player2 = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath2!) as URL)
                
                
                
            }
            catch{
                //ERROR
            }
        
            //initialize all words into the dictionary
            _ = InitDictionary(fileName:"words");
            
            //have activity indicator to show that everything is being setup
           

        
            //Load the view

        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player1.play()
        player1.numberOfLoops = -1
        
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
