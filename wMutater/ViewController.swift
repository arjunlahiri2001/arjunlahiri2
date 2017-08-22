//
//  ViewController.swift
//  wMutater
//
//  Created by Arjun Lahiri on 14/08/2017.
//  Copyright © 2017 Arjun Lahiri. All rights reserved.
//


//There is no losing or losing points in this game


import UIKit
import AVFoundation



class ViewController: UIViewController {

    ///////////////////////

    // BEGIN: GLOBAL VARIABLES
    
    
    @IBOutlet weak var userName: UILabel!
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    var correctWords = 0

    
    //activity loading
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var flag = false
    
    
    // First dictionary maps words to a sequence number (use this to check if a word exists)
    var dctWord = [String: Int]();
    
    // Second dictionary maps numbers to words (use this to generate a random word)
    var dctNum = [Int:String]();
    
    // The current word that the user will have to generate subwords for
    var currentWord = String()
    
    // All the legal subwords of a wordInDict
    var subWordList: Set<String> = Set<String>()
    
    // List of words that the user has entered so far
    var enteredWords: Set<String> = Set<String>()
    
    // The number of sub words left for the user to enter
    var numSubWordsLeft = Int(0)
    
    // Current score
    var score = Int(0)
    
    //Timer
    var seconds = Int(0)
    var timer = Timer()
    var isTimerRunning = false
    
    
    // END: GLOBAL VARIABLES
    
    // BEGIN: Functions
    
    // BEGIN: 2 functions to run timer
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer(){
        seconds -= 1
        TimerOfTheGame.text = "Timer: \(seconds)"
    }
    //END: 2 functions to run timer
    
    

    
    // Read word list and create the dictionary
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
    
 
    // Determine if a word is a valid subWord of the given word
    // Also check if it is in the dictionary
    func WordCheck(word: String, subWord:String)->Bool {
        var validWord = true
        if (!dctWord.keys.contains(subWord)) {
            validWord = false
        }
        else {
            let subWordChars = Array(subWord.characters)
            var wordChars = Array(word.characters)
            for letter in subWordChars {
                if (wordChars.contains(letter)) {
                    let letterIdx = wordChars.index(of:letter)
                    wordChars.remove(at:letterIdx!)
                }
                else {
                    validWord = false
                    break
                }
            }
        }
        print("Valid word:", validWord)
        return validWord
    }

    
    // Generate all permutation of the word of size K that are also dictionary words
    func Permute(word: inout Array<Character>, curr:Int, k:Int) {
        
        if (curr == (k - 1)) {
            let currPerm = String(word[0...k-1])
            
            if (dctWord[currPerm] != nil) {
                //if len currPerm > 1
                    subWordList.insert(currPerm)
            }
            
            return
        }
        
        for i in curr...(word.count - 1){
            
            // swap the current letter with the rest of teh letters
            if (i > curr) {
                swap(&word[curr], &word[i])
            }
            /* create a substring with words[i] removed */
            Permute(word:&word, curr:curr+1, k:k)
            
            // backtrack and set the letters back
            if (i > curr) {
                swap(&word[i], &word[curr])
            }
        }
    }
    
    // Generate all permutation of the word from size 1...N where N is the length of the word
    func PermuteAll(word:inout Array<Character>)
    {
        for i in 1...word.count {
            Permute(word:&word, curr:0, k:i)
        }
    }

    // END Functions
    
    // BEGIN ACTIONS
    
    //Let's get started text
    

    //The word that is chosen randomly from the word dictionary
    @IBOutlet var mutatWord: UILabel!
    
    //Correct combination of letters in random word and is word?
    @IBOutlet var status: UILabel!
    
    //Score
    @IBOutlet var ScoreOfGame: UILabel!
    
    //Number of subwords left in the random word
    @IBOutlet var wordsLeft: UILabel!
    
    //Print the timer
    @IBOutlet var TimerOfTheGame: UILabel!
    
    
   
    
   
    
    @IBAction func enteredWord(_ sender: UITextField) {
        

        var subWord = ""
        for character in ((sender.text)?.characters)!{
            subWord += String(character)
        }
        subWord = subWord.lowercased()
        if(mutatWord.text != "" && subWord.characters.count > 1){
            if (!enteredWords.contains(subWord)) {
                if (WordCheck(word:currentWord, subWord: subWord) == true) {
                    
                    
                        numSubWordsLeft -= 1
                        wordsLeft.text = "# of subwords left: "+String(numSubWordsLeft)
                        player.play() //plays sound when correct
                        status.text = "Correct"
                        //print("Great! You have", numSubWordsLeft, "subwords left to go. Score:",score)
                        enteredWords.insert(subWord)
                        correctWords += 1
                        if(correctWords <= 2){
                            score += 1
                        }else{
                            score += seconds 
                        }
                        ScoreOfGame.text = "Score: "+String(score)
                        sender.text = ""
                }
                else {
                   // print("Boo! Wrong word. You still have", numSubWordsLeft, "Score:",score)
                    wordsLeft.text = "# of subwords left: "+String(numSubWordsLeft)
                    status.text = "Incorrect"
                    ScoreOfGame.text = "Score: "+String(score)
                    
                }
            }
            else {
                //print("Sorry, already used. You still have", numSubWordsLeft, "subwords lefT to go. Score:",score)
                wordsLeft.text = "# of subwords left: "+String(numSubWordsLeft)
                status.text = "Incorrect"
                ScoreOfGame.text = "Score: "+String(score)
            }
        }

    }
  
    
    
  
    
 
    override func viewDidLoad() {
        
        //have activity indicator to show that everything is being setup
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        //reference sound file for the game
        do{
            let audioPath = Bundle.main.path(forResource: "correct", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch{
            //ERROR
        }

        //initialize all words into the dictionary
        _ = InitDictionary(fileName:"words");
        
        //Load the view
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Stop the activityIndicator animating once  everything is truly set up
            activityIndicator.stopAnimating()
        //Generate the random word and start the timer
            userName.text = name
            var validWord = false
            currentWord = String()
            let numWords = dctWord.count
            
            
            // reset the list of entered words to empty
            enteredWords = Set<String>()
            
            // Generate a new word between 10 and 3 characters
            while !validWord {
                let wordIdx = arc4random_uniform(_:UInt32(numWords))
                currentWord = dctNum[Int(wordIdx)]!
                if  (currentWord.characters.count < 10 && currentWord.characters.count > 3) {
                    
                    // DEBUG - REMOVE LATER
                    //print("Your lucky word is:", currentWord)
                    
                    mutatWord.text = currentWord
                    validWord = true
                    seconds = (((currentWord.characters.count)*10) + 100)
                    runTimer()
                    
                }
            }
            
            // Now generate the list of subwords for the word that was just given to the user
            // initialize list of actual subwords and the number of subwords left to be guessed
            subWordList = Set<String>()
            var wordArray:Array<Character> = Array(currentWord.characters)
            PermuteAll(word: &wordArray)
            numSubWordsLeft = subWordList.count
            wordsLeft.text = "# of subwords left: "+String(numSubWordsLeft)
            
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
 
