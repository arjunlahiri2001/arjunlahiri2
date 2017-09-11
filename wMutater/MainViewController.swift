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



var player:AVAudioPlayer = AVAudioPlayer()

var timesVisited = 0

 
func InitDictionary(fileName: String) -> Int
{
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
                if(word.characters.count > 1){
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

//func addHighScores(fileName: String) -> Int
//{
//    print(Bundle.main.resourceURL!)
//    let path2 = Bundle.main.path(forResource: "highScores", ofType: "txt")
//    if (path2 != nil) {
//        do {
//            
//            
//        } catch {
//            print(error)
//        }
//    }
//    
//    return 0;
//}







class MainViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBAction func playGame(_ sender: Any) {
    
        performSegue(withIdentifier: "segue", sender: self)
    }
    override func viewDidLoad() {
        timesVisited += 1
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
            //reference sound file for the game
        if(timesVisited == 1){
            do{
                let audioPath = Bundle.main.path(forResource: "correct", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
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
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()

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
