//
//  ViewController.swift
//  BeatingDegree
//
//  Created by Jesus Ruiz on 10/4/17.
//  Copyright © 2017 AkibaTeaParty. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {

    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = XMLParser()
    var home = [String]()
    var visitor = [String]()
    var hScore = [Int]()
    var vScore = [Int]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return home.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: cellViewController = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! cellViewController
        cell.homeLabel.text = home[indexPath.row]
        cell.visitorLabel.text = visitor[indexPath.row]
        cell.homeScore.text = String(hScore[indexPath.row])
        cell.visitorScore.text = String(vScore[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    //MARK: XMLParserDelegate
    func getData(){
        let url:String="http://www.nfl.com/liveupdate/scorestrip/ss.xml"
        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            print(strXMLData)
            
            //Work in UI
            tableView.reloadData()
            
        } else {
            print("parse failure!")
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="g")
        {
            let hnn: String! = attributeDict["hnn"]
            let vnn: String! = attributeDict["vnn"]
            let hs: Int! = Int(attributeDict["hs"]!)
            let vs: Int! = Int(attributeDict["vs"]!)
            home.append(hnn)
            visitor.append(vnn)
            hScore.append(hs)
            vScore.append(vs)
            if(elementName=="g"){
                passName=true;
            }
            passData=true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="g")
        {
            if(elementName=="g"){
                passName=false;
            }
            passData=false;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData=strXMLData+"\n"+string
        }
        
        if(passData)
        {
            print(string)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }

    
}

