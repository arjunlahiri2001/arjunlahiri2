//: Playground - noun: a place where people can play

import UIKit
import Foundation



// First dictionary mapping words to numbers
var dctWord = [String: Int]();

// Second dictionary maps numbers to words
var dctNum = [Int:String]();

// All the legal subwords of a word given to the user
var subWordList: Set<String> = Set<String>()

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
                lowerWord = word.lowercased()
                dctWord[lowerWord] = iter
                dctNum[iter] = lowerWord
                iter += 1
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

// Generate all permutations of length k from position "curr"
//
func Permute(word: inout Array<Character>, curr:Int, k:Int) {
    
    if (curr == (k - 1)) {
        let currPerm = String(word[0...k-1])
        
        if (dctWord[currPerm] != nil) {
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

func PermuteAll(word:inout Array<Character>)
{
    for i in 1...word.count {
        Permute(word:&word, curr:0, k:i)
    }
}


// This function is the central game driver function
func PlayGame() {
    
    var validWord = false
    var wordInDict = String()
    var continueGame = true
    let numWords = dctWord.count
    var score = 0
    
    while continueGame {
        validWord = false
        wordInDict = String()
        
        // First generate a word between 10 and 3 characters
        while !validWord {
            let wordIdx = arc4random_uniform(_:UInt32(numWords))
            wordInDict = dctNum[Int(wordIdx)]!
            if  (wordInDict.characters.count < 10 && wordInDict.characters.count > 3) {
                print("Your lucky word is:", wordInDict)
                validWord = true
            }
        }
        
        // initialize subwords entered by user list
        var listOfWords = Set<String>()
        
        // initialize list of actual subwords and the number of subwords left to be guessed
        subWordList = Set<String>()
        var wordArray:Array<Character> = Array(wordInDict.characters)
        PermuteAll(word: &wordArray)
        
        var numSubWordsLeft = subWordList.count
        var continueWord = true
        
        // keep letting user guess subwords till she decides to stop
        while (continueWord == true) {
            print("Enter a subword of", wordInDict, ":")
            var subWord = readLine()
            subWord = subWord?.lowercased()
            
            if (!listOfWords.contains(_:subWord!)) {
                if (WordCheck(word:wordInDict,subWord: subWord!) == true) {
                    score += 1
                    numSubWordsLeft -= 1
                    print("Great! You have", numSubWordsLeft, "subwords left to go. Score:",score)
                    listOfWords.insert(subWord!)
                }
                else {
                    score -= 1
                    print("Boo! Wrong word. You still have", numSubWordsLeft, "Score:",score)
                }
            }
            else {
                score -= 1
                print("Sorry, already used. You still have", numSubWordsLeft, "subwords lefT to go. Score:",score)
            }
            
            // see what user wants to do next
            print("Enter 1 to continue")
            print("Enter 2 for a new word")
            print("Enter 3 see all possible subwords and to get a new word")
            print("Enter 4 to leave game")
            let status = readLine()
            
            switch status! {
            case "1":   print("OK keep going")
            case "2":   print("OK, new word ..")
            continueWord = false
            case "3":   print("OK, you give up? Here's all the subwords possible")
            for wordListItem in subWordList {
                print(wordListItem)
            }
            continueWord = false
            case "4": print("Exiting game, your score was ", score)
            continueGame = false
            continueWord = false
            default: print("I don't know what", status!, "means so let's keep going")
            }
        }
    }
}

let retval = InitDictionary(fileName:"words");
PlayGame()
print("Are you happy now?", retval)