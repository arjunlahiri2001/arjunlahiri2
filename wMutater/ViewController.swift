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
import AudioToolbox


// Read word list and create the dictionary




class ViewController: UIViewController, UIPageViewControllerDelegate{
 
    var pageViewController: UIPageViewController?

//--Disable landscape mode
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

    
    ///////////////////////

    // BEGIN: GLOBAL VARIABLES
    
    
    
    
    
    var path = Bundle.main.path(forResource: "highScores", ofType: "txt")
    // high Score file
    
    
    
    
    @IBOutlet weak var numSubwordsLeft: UILabel!
    
    @IBOutlet weak var previousTypedWord: UILabel!
    
    @IBOutlet weak var currentHighScore: UILabel!
    
    
    
    
    
    @objc var correctWords = 0

    
    //activity loading
    @objc var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
        // The current word that the user will have to generate subwords for
    @objc var currentWord = String()
    
    // All the legal subwords of a wordInDict
    @objc var subWordList: Set<String> = Set<String>()
    
    // List of words that the user has entered so far
    @objc var enteredWords: Set<String> = Set<String>()
    
    // The number of sub words left for the user to enter
    @objc var numSubWordsLeft = Int(0)
    
    // Current score
    @objc var score = Int(0)
    
    
    
    //Timer
    @objc var seconds = Int(0)
    @objc var timer = Timer()
    @objc var isTimerRunning = false
    
    
    // END: GLOBAL VARIABLES
    
    // BEGIN: Functions
    
    // BEGIN: 3 functions relating to timer
    @objc func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        print(timer)
    }
    
    @objc func updateTimer(){
        if(TimerOfTheGame.text != String()){
            TimerOfTheGame.text = "Timer: \(seconds)"
        }
        if(seconds >= -1 || subWordListLength > 0){
            if(seconds == 0 || subWordListLength == 0){
                mutatWord.text = String()
//                ScoreOfGame.text = String()
                TimerOfTheGame.text = String()
                seconds = 0
                typedWord.text = String()
                messageOfWord.text = String()
                seconds = Int(0)
                countPermut = Int(0)
                qButton.isHidden = true
                wButton.isHidden = true
                eButton.isHidden = true
                rButton.isHidden = true
                tButton.isHidden = true
                yButton.isHidden = true
                uButton.isHidden = true
                iButton.isHidden = true
                oButton.isHidden = true
                pButton.isHidden = true
                aButton.isHidden = true
                sButton.isHidden = true
                dButton.isHidden = true
                fButton.isHidden = true
                gButton.isHidden = true
                hButton.isHidden = true
                jButton.isHidden = true
                kButton.isHidden = true
                lButton.isHidden = true
                zButton.isHidden = true
                xButton.isHidden = true
                cButton.isHidden = true
                vButton.isHidden = true
                bButton.isHidden = true
                nButton.isHidden = true
                mButton.isHidden = true
                deleteButton.isHidden = true
                enterWord.isHidden = true

                createButton()
                
                }else{
                    seconds -= 1
                
                }
        }

    }
    
    @objc func resetTimer(){
        timer.invalidate()
 
    }
    //END: 3 functions relating to timer
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var x = 0
    
    
    //High Score file writing-------------------------------------------------
    @objc func highScores(){
        let contains = HighScores.contains(Scores.max()!)
        if(contains){
             
        }else {
            HighScores.append(Scores.max()!)
            savedScore = Scores.max()!
            print(HighScores)
            if(HighScores[0] != 0){
                if(HighScores[0] < 30){
                    newHighScore.text = "You are an atomic whiz!! New High Score: \(Scores.max()!)"
                    currentHighScore.text = "Current High Score: \(Scores.max()!)"
                }else if(HighScores[0] >= 30 && HighScores[0] < 60){
                    newHighScore.text = "You are an nuclear scientist!! New High Score: \(Scores.max()!)"
                    currentHighScore.text = "Current High Score: \(Scores.max()!)"

                }else if(HighScores[0] >= 60 && HighScores[0] <= 168){
                    newHighScore.text = "You are the wordmutator!! New High Score: \(Scores.max()!)"
                    currentHighScore.text = "Current High Score: \(Scores.max()!)"

                }
            }
            
            //set path for the high score file

            print(Bundle.main.resourceURL!)
            
            //write the file
            
            let highscore = "High Score: \(String(describing: Scores.max()))";
            
            do{
                try highscore.write(toFile: path!, atomically: true, encoding: String.Encoding.utf8)
                print("Writing file")
            }catch let error as NSError{
                print(error);
            }
            
            //read the file
                do{
                    let data = try String(contentsOfFile: path!, encoding: .utf8)
                    let lines = data.components(separatedBy: .newlines)
                    print("Reading file")
                    print(lines.count)
                
                } catch {
                    print(error)
                }
            
        }
    }
    
    //-------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

 
    // Determine if a word is a valid subWord of the given word
    // Also check if it is in the dictionary
    @objc func WordCheck(word: String, subWord:String)->Bool {
        var validWord = true
        if (!dctWord.keys.contains(subWord)) {
            validWord = false
        }
        else {
            let subWordChars = Array(subWord)
            var wordChars = Array(word)
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
    var countPermut = 0
    var subWordListLength = 0
    func Permute(word: inout Array<Character>, curr:Int, k:Int) {
        
        if (curr == (k - 1)) {
            let currPerm = String(word[0...k-1])
            
            if (dctWord[currPerm] != nil) {
                //if len currPerm > 1
                    subWordList.insert(currPerm)
                
                
            }
            
            subWordListLength = subWordList.count
            
            return 
        }
        
        for i in curr...(word.count - 1){
            
            // swap the current letter with the rest of teh letters
            if (i > curr) {
                word.swapAt(curr, i)
            }
            /* create a substring with words[i] removed */
            Permute(word:&word, curr:curr+1, k:k)
            
            // backtrack and set the letters back
            if (i > curr) {
                word.swapAt(i, curr)
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
    
 
    
    //Score
    @IBOutlet var ScoreOfGame: UILabel!
    
    //New High Score text field
    @IBOutlet var newHighScore: UILabel!
    
    
  
    
    //Print the timer
    @IBOutlet var TimerOfTheGame: UILabel!
    
    @IBOutlet weak var messageOfWord: UILabel!
    
    
    @IBOutlet weak var qButton: UIButton!
    @IBOutlet weak var wButton: UIButton!
    @IBOutlet weak var eButton: UIButton!
    @IBOutlet weak var rButton: UIButton!
    @IBOutlet weak var tButton: UIButton!
    @IBOutlet weak var yButton: UIButton!
    @IBOutlet weak var uButton: UIButton!
    @IBOutlet weak var iButton: UIButton!
    @IBOutlet weak var oButton: UIButton!
    @IBOutlet weak var pButton: UIButton!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var sButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var fButton: UIButton!
    @IBOutlet weak var gButton: UIButton!
    @IBOutlet weak var hButton: UIButton!
    @IBOutlet weak var jButton: UIButton!
    @IBOutlet weak var kButton: UIButton!
    @IBOutlet weak var lButton: UIButton!
    @IBOutlet weak var zButton: UIButton!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var vButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var nButton: UIButton!
    @IBOutlet weak var mButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var enterWord: UIButton!
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func enterWord(_ sender: Any) {
        
        var subWord = ""
        for character in ((typedWord.text))! {
            subWord += String(character)
        }

        subWord = subWord.lowercased()
        if((mutatWord.text != "" || mutatWord.text != String()) && subWord.count > 1){
            if (!enteredWords.contains(subWord)) {
                if (WordCheck(word:currentWord, subWord: subWord) == true) {
                    
                    
                    player.play() //plays sound when correct
                    //print("Great! You have", numSubWordsLeft, "subwords left to go. Score:",score)
                    enteredWords.insert(subWord)
                    correctWords += 1
                    score += subWord.count
                    seconds += subWord.count + 1
                    previousTypedWord.text = typedWord.text

                    ScoreOfGame.text = "Score: "+String(score)
                    mutatWord.textColor = UIColor.green
                    typedWord.text = ""
                    messageOfWord.text = "Correct!!"
                   
                    subWordListLength -= 1
                    print(subWordListLength)
                    print(subWordList)

                    numSubwordsLeft.text = "\(subWordListLength)"
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                    
                }
                else {
                    // print("Boo! Wrong word. You still have", numSubWordsLeft, "Score:",score)
                    ScoreOfGame.text = "Score: "+String(score)
                    mutatWord.textColor = UIColor.red
                    messageOfWord.text = "Wrong!!"
                    previousTypedWord.text = typedWord.text

                    typedWord.text = ""

                    player2.play()
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                    
                }
            }
            else {
                //print("Sorry, already used. You still have", numSubWordsLeft, "subwords lefT to go. Score:",score)
                ScoreOfGame.text = "Score: "+String(score)
                mutatWord.textColor = UIColor.red
                messageOfWord.text = "Word already used!!"
                previousTypedWord.text = typedWord.text
                typedWord.text = ""
                player2.play()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                
                
            }
          
        }
        
        if((typedWord.text?.count ) == 1){
            ScoreOfGame.text = "Score: "+String(score)
            mutatWord.textColor = UIColor.red
            messageOfWord.text = "No single letters!!"
            previousTypedWord.text = typedWord.text

            typedWord.text = ""
            player2.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
//---------------------------------------------------------
// keyBoard functions
    @objc var word: String = ""
    
    
    
    @IBOutlet weak var typedWord: UILabel!
    
    @IBAction func qButton(_ sender: Any) {
        if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "q"
            typedWord.text = word
        }
       

    }
    
    @IBAction func wButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "w"
            typedWord.text = word
        }
        
      
    }
    
   
    @IBAction func eButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "e"
            typedWord.text = word
        }
        
      
    }
    

    @IBAction func rButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "r"
            typedWord.text = word
        }
        
    
    }
    
    @IBAction func tButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "t"
            typedWord.text = word
        }
     
    }
    
    @IBAction func yButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "y"
            typedWord.text = word
        }
        
       
    }
    
    
    @IBAction func uButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "u"
            typedWord.text = word
        }
        
      
    }
    
    
    @IBAction func iButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "i"
            typedWord.text = word
        }
        
      
    }
    
    @IBAction func oButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "o"
            typedWord.text = word
        }
        
       
    }
    
    @IBAction func pButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "p"
            typedWord.text = word
        }
        
      
    }
    
    @IBAction func aButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "a"
            typedWord.text = word
        }
        
      
    }
    
    @IBAction func sButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "s"
            typedWord.text = word
        }
        
     
    }
    
    @IBAction func dButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "d"
            typedWord.text = word
        }
     
    }
    
    @IBAction func fButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "f"
            typedWord.text = word
        }
        
       
    }
    
    @IBAction func gButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "g"
            typedWord.text = word
        }
        
       
    }
    
    
    @IBAction func hButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "h"
            typedWord.text = word
        }
        
       
    }
    
    @IBAction func jButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "j"
            typedWord.text = word
        }
        
        
    }
    
    
    @IBAction func kButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "k"
            typedWord.text = word
        }
        
       
    }
    
    
    @IBAction func lButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "l"
            typedWord.text = word
        }
        
       
    }
    
    
    @IBAction func zButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "z"
            typedWord.text = word
        }
        
       
    }
    
    
    @IBAction func xButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "x"
            typedWord.text = word
        }
        
       
    }
    
    @IBAction func cButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "c"
            typedWord.text = word
        }
        
        
    }
    
    
    @IBAction func vButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "v"
            typedWord.text = word
        }
        
        
    }
    
    
    @IBAction func bButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "b"
            typedWord.text = word
        }
        
       
    }
    
    @IBAction func nButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "n"
            typedWord.text = word
        }
        
       
    }
    
    @IBAction func mButton(_ sender: Any) {
         if((typedWord.text?.count)! < 20){
            word = typedWord.text!
            word += "m"
            typedWord.text = word
        }
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        if(typedWord.text != ""){
            word = String(word.dropLast())
            typedWord.text = word
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//-------------------------------------------------------------------------------------------------
    
    
  
    
  
    override func viewDidLoad() {
       
        player1.play()
        player1.numberOfLoops = -1
        
        

        //have activity indicator to show that everything is being setup
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Load the view
        super.viewDidLoad()
        resetButton.addTarget(self, action: #selector(resetGameLayout(resetButton:)), for: .touchUpInside)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc var resetButton = UIButton()
    
    @objc var timeNoGame = 0

    @IBOutlet weak var tapOnce: UILabel!
    
    @objc func createButton(){                                                                                         
        timeNoGame += 1
        if(timeNoGame == 1){
            Scores.append(score)
            highScores()
            
        }
       
        resetButton.setTitle("Play Again", for: .normal)
        resetButton.setTitleColor(UIColor.yellow, for: .normal)
        resetButton.backgroundColor = UIColor.lightGray
        resetButton.layer.borderWidth = 2
        resetButton.layer.cornerRadius = 18
        resetButton.frame = CGRect(x: view.frame.width/2 - 50, y: view.frame.height/2 - 18, width: 100, height: 36)
        view.addSubview(resetButton)
        tapOnce.text = "Tap only once"
        super.viewDidLoad()

    }
    
    func refreshView() {
        
        // Calling the viewDidLoad and viewWillAppear methods to "refresh" the VC and run through the code within the methods themselves
        activityIndicator.startAnimating()

        
        super.viewDidAppear(true)
       
        
    }
    
    @objc func resetGameLayout(resetButton: UIButton){
        tapOnce.text = ""

        self.refreshView()
        activityIndicator.stopAnimating()

        qButton.isHidden = false
        wButton.isHidden = false
        eButton.isHidden = false
        rButton.isHidden = false
        tButton.isHidden = false
        yButton.isHidden = false
        uButton.isHidden = false
        iButton.isHidden = false
        oButton.isHidden = false
        pButton.isHidden = false
        aButton.isHidden = false
        sButton.isHidden = false
        dButton.isHidden = false
        fButton.isHidden = false
        gButton.isHidden = false
        hButton.isHidden = false
        jButton.isHidden = false
        kButton.isHidden = false
        lButton.isHidden = false
        zButton.isHidden = false
        xButton.isHidden = false
        cButton.isHidden = false
        vButton.isHidden = false
        bButton.isHidden = false
        nButton.isHidden = false
        mButton.isHidden = false
        deleteButton.isHidden = false
        enterWord.isHidden = false




        timeNoGame = 0
        resetTimer() //reset timer
        score = 0
        countPermut = 0

        typedWord.text = ""
        messageOfWord.text = ""

        newHighScore.text = ""

        var validWord = false
        currentWord = String()
        let numWords = dctWord.count
        self.resetButton.removeFromSuperview()

        ScoreOfGame.text = "Score: \(0)"

        // reset the list of entered words to empty
        enteredWords = Set<String>()

        // Generate a new word between 10 and 3 characters
        while !validWord {
            let wordIdx = arc4random_uniform(_:UInt32(numWords))
            currentWord = dctNum[Int(wordIdx)]!
            if  (currentWord.count < 10 && currentWord.count > 3) {

                // DEBUG - REMOVE LATER
                //print("Your lucky word is:", currentWord)

                mutatWord.text = currentWord
                mutatWord.textColor = UIColor.black
                validWord = true
                seconds = 100 + numSubWordsLeft
                TimerOfTheGame.text = "Timer: \(seconds)"
                runTimer()

            }

        }

        // Now generate the list of subwords for the word that was just given to the user
        // initialize list of actual subwords and the number of subwords left to be guessed
        subWordList = Set<String>()
        var wordArray:Array<Character> = Array(currentWord)
        PermuteAll(word: &wordArray)
        numSubwordsLeft.text = "\(subWordListLength)"


        
    }


    
    
    
    override func viewDidAppear(_ animated: Bool) {
        

            //Stop the activityIndicator animating once  everything is truly set up
            activityIndicator.stopAnimating()
            print(HighScores)
        if(savedScore != 0){
            currentHighScore.text = "Current High Score: \(savedScore)"
        }
             UIApplication.shared.endIgnoringInteractionEvents()
            //Generate the random word and start the timer
            var validWord = false
            currentWord = String()
            let numWords = dctWord.count
            
        
            // reset the list of entered words to empty
            enteredWords = Set<String>()
            
            // Generate a new word between 10 and 3 characters
            while !validWord {
                let wordIdx = arc4random_uniform(_:UInt32(numWords))
                currentWord = dctNum[Int(wordIdx)]!
                if  (currentWord.count < 10 && currentWord.count > 3) {
                    
                    // DEBUG - REMOVE LATER
                    //print("Your lucky word is:", currentWord)
                    
                    mutatWord.text = currentWord
                    validWord = true
                    seconds = 100 + numSubWordsLeft
                    runTimer()
                    print(numSubWordsLeft)
                    

                    
                }
            }
            
            // Now generate the list of subwords for the word that was just given to the user
            // initialize list of actual subwords and the number of subwords left to be guessed
            subWordList = Set<String>()
            var wordArray:Array<Character> = Array(currentWord)
            PermuteAll(word: &wordArray)
            
           resetButton.addTarget(self, action: #selector(resetGameLayout(resetButton:)), for: .touchUpInside)
           numSubwordsLeft.text = "\(subWordListLength)"

        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 

}






