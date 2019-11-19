//
//  ViewController.swift
//  Friends
//
//  Created by Amirhossein Sayyah on 2/24/19.
//  Copyright © 2019 Amirhossein Sayyah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(displayP3Red: 0.926, green: 0.938, blue: 0.934, alpha: 1.0)
        generateButton.layer.cornerRadius = 10
        generateButton.layer.borderWidth = 1
        generateButton.layer.backgroundColor = UIColor(displayP3Red: 0.547, green: 0.562, blue: 0.566, alpha: 1.0).cgColor
        generateButton.layer.borderColor = UIColor(displayP3Red: 0.547, green: 0.562, blue: 0.566, alpha: 1.0).cgColor //UIColor.lightGray.cgColor
    }
    
    @IBAction func generate(){
        let season = generateRandomSeason()
        let episode = generateRandomEpisode(season: season)
        seasonLabel.text = String(season)
        seasonLabel.textAlignment = .center
        episodeLabel.text = String(episode)
        episodeLabel.textAlignment = .center
        let name = getEpisodeName(season: season, episode: episode)
        episodeNameLabel.text = name
        episodeNameLabel.textAlignment = .center
    }
    
    func generateRandomSeason() -> Int{
        let number = Int.random(in: 1 ..< 11)
        return number
    }
    
    func generateRandomEpisode(season: Int) -> Int{
        var episode = 0
        if (season == 3) || (season == 6){
            episode = Int.random(in: 1 ..< 26)
        }else if (season == 10){
            episode = Int.random(in: 1 ..< 18)
        }else{
            episode = Int.random(in: 1 ..< 25)
        }
        return episode
    }
    
    func getEpisodeName(season: Int, episode: Int) -> String{
        let seasonString = String(season)
        var episodeString = String(episode)
        if episodeString.count < 2{
            episodeString = "0" + episodeString
        }
        let seasonEpisode = seasonString + "." + episodeString
        var contents = ""
        if let filepath = Bundle.main.path(forResource: "friends", ofType: "txt") {
            do {
                contents = try String(contentsOfFile: filepath)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        let array = contents.components(separatedBy: CharacterSet.newlines)
        var episodeDict: [String:String] = [:]
        for line in array{
            var sepLine = line.components(separatedBy: CharacterSet.whitespaces)
            episodeDict[sepLine[0]] = line
        }
        var name = ""
        if episodeDict[seasonEpisode] != nil{
            name = episodeDict[seasonEpisode]!
        }
        if name == "1.01 Pilot"{
            name = "Pilot"
        }else{
            if name[0..<2] == "10"{
                name = name.substring(6)
            }else{
                name = name.substring(5)
            }
        }
        return name
        
    }


}

extension String {
    
    func substring(_ from: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        return String(self[start ..< endIndex])
    }
    
    //Allow closed integer range subscripting like `string[0...n]`
    subscript(range: ClosedRange<Int>) -> Substring {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[start...end]
    }
    
    //Allow string[Int] subscripting
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    //Allow open ranges like `string[0..<n]`
    subscript(range: Range<Int>) -> Substring {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return self[start..<end]
    }
}

