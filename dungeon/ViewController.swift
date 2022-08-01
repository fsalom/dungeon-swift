//
//  ViewController.swift
//  dungeon
//
//  Created by Fernando Salom Carratala on 27/7/22.
//

import UIKit

class ViewController: UIViewController {
    let squarePerRow = 5
    var sizeOfSquare: CGFloat = 0
    var character: UIView!
    var numberOfRows: Int = 0
    var board: [[Int]] = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sizeOfSquare = UIScreen.main.bounds.width / CGFloat(squarePerRow)
        numberOfRows = Int(UIScreen.main.bounds.height / CGFloat(squarePerRow))
        loadMap()
        character = loadCharacter()
    }

    func loadMap() {
        for n in 0...numberOfRows {
            let positionY = CGFloat(n) * sizeOfSquare
            let row = UIStackView(frame: CGRect(x: 0, y: positionY, width: UIScreen.main.bounds.width, height: sizeOfSquare))
            for terrain in loadRow(){
                row.addArrangedSubview(terrain)
                row.distribution = .fillEqually
            }
            row.backgroundColor = .black
            self.view.addSubview(row)
        }

    }

    func loadRow() -> [UIImageView]{
        let array = ["concrete2", "concrete3", "door", "steel", "steel2", "floor"]

        var terrains: [UIImageView] = []
        for _ in 0...squarePerRow - 1{
            let square = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeOfSquare, height: sizeOfSquare))
            let isConcrete = arc4random_uniform(20) <= 18 ? true : false
            square.image = isConcrete ? UIImage(named: "concrete") : UIImage(named: array.randomElement()!)
            terrains.append(square)
        }

        return terrains
    }

    func loadCharacter() -> UIView{
        let character = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200, width: 50, height: 50))
        character.layer.cornerRadius = 25
        character.backgroundColor = .white

        self.view.addSubview(character)
        return character
    }

    func moveUp(){
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.y = self.character.frame.origin.y - 200
        } completion: { finished in
        }
    }
    func moveDown(){
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.y = self.character.frame.origin.y + 200
        } completion: { finished in
        }
    }
    func moveLeft(){
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.x = self.character.frame.origin.x - 200
        } completion: { finished in
        }
    }
    func moveRight(){
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.x = self.character.frame.origin.x + 200
        } completion: { finished in
        }
    }

}

