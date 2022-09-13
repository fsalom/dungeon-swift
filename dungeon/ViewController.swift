//
//  ViewController.swift
//  dungeon
//
//  Created by Fernando Salom Carratala on 27/7/22.
//

import UIKit

class ViewController: UIViewController {
    let squarePerRow = 10
    var sizeOfSquare: CGFloat = 0
    var character: UIView!
    var numberOfRows: Int = 0
    var controlDuration = 0.5
    var board: [[Int]] = [[]]
    var current: Position!
    var map = [[Terrain]]()

    struct Position {
        var x: Int!
        var y: Int!
    }

    struct Texture {
        var image: UIImage!
        var isBlocked: Bool!
    }

    struct Terrain {
        var texture: Texture!
        var view: UIImageView!
        init(texture: Texture, size: CGFloat) {
            self.view = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            self.view.image = texture.image
            self.texture = texture
        }
    }

    enum Movement {
        case up
        case down
        case left
        case right
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        current = Position(x: 0, y: 0)
        sizeOfSquare = UIScreen.main.bounds.width / CGFloat(squarePerRow)
        numberOfRows = Int(UIScreen.main.bounds.height / CGFloat(sizeOfSquare))
        loadMap()
        character = loadCharacter()
        loadController()
    }

    func loadMap() {
        for n in 0...numberOfRows {
            let positionY = CGFloat(n) * sizeOfSquare
            let row = UIStackView(frame: CGRect(x: 0, y: positionY, width: UIScreen.main.bounds.width, height: sizeOfSquare))
            let terrains = loadRow()
            self.map.append(terrains)
            for terrain in terrains {
                row.addArrangedSubview(terrain.view)
                row.distribution = .fillEqually
            }
            row.backgroundColor = .black
            self.view.addSubview(row)
        }
    }

    func loadRow() -> [Terrain]{
        let textures = [
            Texture(image: UIImage(named: "concrete")!, isBlocked: false),
            Texture(image: UIImage(named: "concrete2")!, isBlocked: false),
            Texture(image: UIImage(named: "concrete3")!, isBlocked: false),
            Texture(image: UIImage(named: "door")!, isBlocked: true),
            Texture(image: UIImage(named: "steel")!, isBlocked: true),
            Texture(image: UIImage(named: "steel2")!, isBlocked: true),
            Texture(image: UIImage(named: "floor")!, isBlocked: false)
        ]

        var mapPieces: [Terrain] = []
        for _ in 0...squarePerRow - 1{
            let isConcrete = arc4random_uniform(20) <= 18 ? true : false
            let texture = isConcrete ? textures[0] : textures.randomElement()!
            mapPieces.append(Terrain(texture: texture, size: sizeOfSquare))
        }

        return mapPieces
    }

    func loadCharacter() -> UIView{
        let image = UIImage(named: "character")
        let character = UIImageView(frame: CGRect(x: 0, y: 0, width: self.sizeOfSquare, height: self.sizeOfSquare))
        character.image = image
        //character.layer.cornerRadius = self.sizeOfSquare/2
        //character.backgroundColor = .white

        self.view.addSubview(character)
        return character
    }

    func canMove(to position: Position) -> Bool {
        if position.x < 0 || position.y < 0 || position.x >= map[0].count || position.y >= map.count{
            return false
        }
        if map[position.y][position.x].texture.isBlocked {
            return false
        }
        return true
    }

    func check(this movement: Movement) -> Bool {
        var futurePosition: Position = current
        switch movement {
        case .up:
            futurePosition.y -= 1
        case .down:
            futurePosition.y += 1
        case .left:
            futurePosition.x -= 1
        case .right:
            futurePosition.x += 1
        }
        if canMove(to: futurePosition) {
            current = futurePosition
            return true
        } else {
            return false
        }

    }

    @objc func moveUp(){
        if !check(this: .up) { return }
        UIView.animate(withDuration: self.controlDuration, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.y = self.character.frame.origin.y - self.sizeOfSquare
        } completion: { finished in
        }
    }
    @objc func moveDown(){
        if !check(this: .down) { return }
        UIView.animate(withDuration: self.controlDuration, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.y = self.character.frame.origin.y + self.sizeOfSquare
        } completion: { finished in
        }
    }
    @objc func moveLeft(){
        if !check(this: .left) { return }
        UIView.animate(withDuration: self.controlDuration, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.x = self.character.frame.origin.x - self.sizeOfSquare
        } completion: { finished in
        }
    }
    @objc func moveRight(){
        if !check(this: .right) { return }
        UIView.animate(withDuration: self.controlDuration, delay: 0, options: .curveEaseIn) {
            self.character.frame.origin.x = self.character.frame.origin.x + self.sizeOfSquare
        } completion: { finished in
        }
    }

    func loadController(){
        let controllerSize: CGFloat = 120.0
        let buttonSize: CGFloat = 40.0

        let image = UIImage(named: "controller")
        let controllerBackground = UIImageView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 200, width: controllerSize, height: controllerSize))
        controllerBackground.image = image

        let mainStack = UIStackView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 200, width: controllerSize, height: controllerSize))
        mainStack.axis = .vertical

        let upButton = UIButton(type: UIButton.ButtonType.custom)
        upButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        upButton.addTarget(self, action: #selector(moveUp), for: .touchUpInside)

        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        leftButton.addTarget(self, action: #selector(moveLeft), for: .touchUpInside)

        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        rightButton.addTarget(self, action: #selector(moveRight), for: .touchUpInside)

        let downButton = UIButton(type: UIButton.ButtonType.custom)
        downButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        downButton.addTarget(self, action: #selector(moveDown), for: .touchUpInside)

        let firstLine = UIStackView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 200, width: controllerSize, height: buttonSize))
        firstLine.axis = .horizontal
        firstLine.addArrangedSubview(upButton)
        firstLine.distribution = .fillEqually

        let secondLine = UIStackView(frame: CGRect(x: 0, y: 0, width: controllerSize, height: buttonSize))
        secondLine.axis = .horizontal
        secondLine.addArrangedSubview(leftButton)
        secondLine.addArrangedSubview(rightButton)
        secondLine.distribution = .fillEqually

        let thirdLine = UIStackView(frame: CGRect(x: 0, y:0, width: controllerSize, height: buttonSize))
        thirdLine.axis = .horizontal
        thirdLine.addArrangedSubview(downButton)
        thirdLine.distribution = .fillEqually

        mainStack.distribution = .fillEqually
        mainStack.addArrangedSubview(firstLine)
        mainStack.addArrangedSubview(secondLine)
        mainStack.addArrangedSubview(thirdLine)

        self.view.addSubview(controllerBackground)
        self.view.addSubview(mainStack)
    }
}

