

import SpriteKit
import GameplayKit
import GoogleMobileAds
import AVFoundation



struct Physics {
    static let ghost : UInt32 = 0x1 << 1
    static let ground : UInt32 = 0x1 << 2
    static let wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4

}
var highscore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    let defaults = UserDefaults()
  var ground = SKSpriteNode()
    var ground2 = SKSpriteNode()
    var ground3 = SKSpriteNode()


    var ghost = SKSpriteNode()
   
    var wallPair = SKNode()
    var background = SKSpriteNode()
    var background2 = SKSpriteNode()
    var background3 = SKSpriteNode()

    var audioPlayer = AVAudioPlayer()
    let coinSound = SKAction.playSoundFileNamed("pass.wav", waitForCompletion: false)
    let deathSound = SKAction.playSoundFileNamed("death.wav", waitForCompletion: false)
    let flapSound = SKAction.playSoundFileNamed("flap.wav", waitForCompletion: false)


    var movePipes = SKAction()
    var removePipes = SKAction()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var score = Int()
    var start = SKLabelNode()
       let scoreLbl = SKLabelNode()
    var scoretext = SKLabelNode()
    var besttext = SKLabelNode()
    var died = Bool()
    var restartBTN = SKSpriteNode()
    var deadScoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    
   let topWallTex = SKTexture(imageNamed: "topWall")
   let botWallTex = SKTexture(imageNamed: "bottomWall")
    var timer = Timer()
  



   
   final func restartScene(){
         
         self.removeAllChildren()
         self.removeAllActions()
         died = false
         gameStarted = false
         score = 0
    scoreLbl.isHidden = false
    start.isHidden = false
         createScene()
    
         
     }
    
    
    final func createScene() {
        self.physicsWorld.contactDelegate = self
      start = SKLabelNode()
             start.text = "TAP TO START"
             start.fontSize = 26
             start.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 150)
             start.fontName = "ChalkboardSE-Bold"
             start.fontColor = UIColor.black
        start.zPosition = 5
             addChild(start)
        
             start.run(SKAction.scale(to: 3.0, duration: 0.3))
        
        background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        background.size = CGSize(width: self.frame.width*1.06, height: self.frame.height)

        
        background2 = SKSpriteNode(imageNamed: "bg")
        background2.position = CGPoint(x: self.frame.width*1.5 , y: self.frame.height/2)
        background2.size = CGSize(width: self.frame.width*1.06, height: self.frame.height)

        
        background3 = SKSpriteNode(imageNamed: "bg")
        background3.position = CGPoint(x: self.frame.width*2.5, y: self.frame.height/2)
        background3.size = CGSize(width: self.frame.width*1.06, height: self.frame.height)

       
        addChild(background)
        addChild(background2)
        addChild(background3)
   highscore = self.defaults.integer(forKey: "hs")

        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
          scoreLbl.text = "\(score)"
          scoreLbl.fontName = "ChalkboardSE-Bold"
          scoreLbl.zPosition = 5
          scoreLbl.fontSize = 90
          self.addChild(scoreLbl)
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.size = CGSize(width: self.frame.size.width+5, height: self.frame.height/6.95)
               ground.position = CGPoint(x: Int(self.frame.width)/2, y: 0+Int(ground.frame.height)/2 )
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
               ground.physicsBody?.categoryBitMask = Physics.ground
               ground.physicsBody?.collisionBitMask = Physics.ghost
               ground.physicsBody?.contactTestBitMask = Physics.ghost
               ground.physicsBody?.affectedByGravity = false
               ground.physicsBody?.isDynamic = false
               ground.zPosition = 3
        
        ground2 = SKSpriteNode(imageNamed: "ground")
        ground2.size = CGSize(width: self.frame.size.width+5, height: self.frame.height/6.95)
            ground2.position = CGPoint(x: self.frame.width*1.5, y: ground.frame.height/2)
        ground2.physicsBody =  SKPhysicsBody(rectangleOf: ground.size)
               ground2.physicsBody?.categoryBitMask = Physics.ground
               ground2.physicsBody?.collisionBitMask = Physics.ghost
               ground2.physicsBody?.contactTestBitMask = Physics.ghost
               ground2.physicsBody?.affectedByGravity = false
               ground2.physicsBody?.isDynamic = false
               ground2.zPosition = 3
        
        ground3 = SKSpriteNode(imageNamed: "ground")
        ground3.size = CGSize(width: self.frame.size.width+5, height: self.frame.height/6.95)
            ground3.position = CGPoint(x: self.frame.width*2.5, y: ground.frame.height/2)
        ground3.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
               ground3.physicsBody?.categoryBitMask = Physics.ground
               ground3.physicsBody?.collisionBitMask = Physics.ghost
               ground3.physicsBody?.contactTestBitMask = Physics.ghost
               ground3.physicsBody?.affectedByGravity = false
               ground3.physicsBody?.isDynamic = false
               ground3.zPosition = 3
        
        
        
        
        


               addChild(ground)
        addChild(ground2)
        addChild(ground3)
               
               
               
               ghost = SKSpriteNode(imageNamed: "user")
               ghost.size = CGSize(width: 175, height: 175)
               ghost.position = CGPoint(x: self.frame.width/3, y: self.frame.height / 2)
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.height/3.25)
               ghost.physicsBody?.categoryBitMask = Physics.ghost
               ghost.physicsBody?.collisionBitMask = Physics.ground | Physics.wall
        ghost.physicsBody?.contactTestBitMask = Physics.ground | Physics.wall | Physics.Score
               ghost.physicsBody?.affectedByGravity = false
               ghost.physicsBody?.isDynamic = true
               ghost.zPosition = 2
               addChild(ghost)
        
        
       

            
                
        
        
    }
    override func didMove(to view: SKView) {
       
    createScene()
       
      

       
    }
    
    
    
    final func createBTN(){
           restartBTN = SKSpriteNode(imageNamed: "RestartBtn")
        restartBTN.size = CGSize(width: self.frame.width/2.25, height: self.frame.height/4)
           restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 100)
           restartBTN.zPosition = 6
           restartBTN.setScale(0)
           self.addChild(restartBTN)
    
         highscoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        highscoreLabel.position = CGPoint(x:restartBTN.frame.width+100, y:restartBTN.frame.height/2 - 50)
        run(deathSound)

        var hs = defaults.integer(forKey: "hs")
        highscoreLabel.text = "\(hs)"
       
        highscoreLabel.fontSize = 16
        highscoreLabel.zPosition = 10
        
        besttext = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        besttext.position = CGPoint(x: restartBTN.frame.width+100, y: restartBTN.frame.height/2 )
        besttext.fontSize = 16
        besttext.zPosition = 10
        besttext.text = "BEST"
        
        deadScoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        deadScoreLabel.position = CGPoint(x: restartBTN.frame.width-90, y: restartBTN.frame.height/2 - 50)
        deadScoreLabel.text = "\(score)"
        deadScoreLabel.fontSize = 16
        deadScoreLabel.zPosition = 10
        
        scoretext = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoretext.position = CGPoint(x: restartBTN.frame.width-90, y: restartBTN.frame.height/2 )
        scoretext.fontSize = 16
        scoretext.zPosition = 10
        scoretext.text = "SCORE"
        
        
       
        restartBTN.addChild(highscoreLabel)
        restartBTN.addChild(deadScoreLabel)
        restartBTN.addChild(besttext)
        restartBTN.addChild(scoretext)
        restartBTN.run(SKAction.scale(to: 2, duration: 0.3))
        
        highscoreLabel.run(SKAction.scale(to: 3.0, duration: 0.3))
        deadScoreLabel.run(SKAction.scale(to: 3.0, duration: 0.3))
        besttext.run(SKAction.scale(to: 1.5, duration: 0.3))
        scoretext.run(SKAction.scale(to: 1.5, duration: 0.3))
        


        
           
       }
   
    func didBegin(_ contact: SKPhysicsContact) {
          let firstBody = contact.bodyA
          let secondBody = contact.bodyB
          
        
          if firstBody.categoryBitMask == Physics.Score && secondBody.categoryBitMask == Physics.ghost{
              
              score += 1
              run(coinSound)
           
            self.scoreLbl.text = "\(score)"

           
          
             
              firstBody.node?.removeFromParent()
              
          }
          else if firstBody.categoryBitMask == Physics.ghost && secondBody.categoryBitMask == Physics.Score {
              
              score += 1
              run(coinSound)

     
             self.scoreLbl.text = "\(score)"
           

              secondBody.node?.removeFromParent()
              
          }
          
          else if firstBody.categoryBitMask == Physics.ghost && secondBody.categoryBitMask == Physics.wall || firstBody.categoryBitMask == Physics.wall && secondBody.categoryBitMask == Physics.ghost{
          
              

            enumerateChildNodes(withName: "wallPair", using: ({
                  (node, error) in
                  
                  node.speed = 0
                  self.removeAllActions()
                self.timer.invalidate()
                self.wallPair.removeAllActions()
                highscore = self.defaults.integer(forKey: "hs")

                if self.score > highscore
                {
                    highscore = self.score
                    
                    self.defaults.set(highscore, forKey: "hs")
                }

               
               
               
              

                  
              }))
              self.scoreLbl.isHidden = true
            
           
            if died == false{
                
                
                           died = true
                self.removeAllActions()

                self.wallPair.removeAllActions()
                background.removeAllActions()
                background2.removeAllActions()
                background3.removeAllActions()
                
                ground3.removeAllActions()
                ground2.removeAllActions()
                ground.removeAllActions()

                           createBTN()
                       }
            
          }
          else if firstBody.categoryBitMask == Physics.ghost && secondBody.categoryBitMask == Physics.ground || firstBody.categoryBitMask == Physics.ground && secondBody.categoryBitMask == Physics.ghost{
           



              
            enumerateChildNodes(withName: "wallPair", using: ({
                  (node, error) in
                  
                  node.speed = 0
                  self.removeAllActions()
                self.timer.invalidate()
                self.wallPair.removeAllActions()
                highscore = self.defaults.integer(forKey: "hs")

                if self.score > highscore
                               {
                                   highscore = self.score
                                   
                                   self.defaults.set(highscore, forKey: "hs")
                               }


               
               
                             

                  
              }))
            self.scoreLbl.isHidden = true
           
            if died == false{
               
                           died = true
                self.removeAllActions()
                background.removeAllActions()
                background2.removeAllActions()
                background3.removeAllActions()
                
                ground3.removeAllActions()
                ground2.removeAllActions()
                ground.removeAllActions()

                self.wallPair.removeAllActions()
                

                           createBTN()
                       }
            
          }

          
          
          
          
      }
  
    @objc func spawn() {
        let dispatchQueue = DispatchQueue.init(label: "queue", attributes: .concurrent)

        let spawn1 = SKAction.run(createWalls, queue: dispatchQueue)
        if scene?.view?.isPaused == false {
               run(spawn1)
        }
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false {
            
            let parallax = SKAction.repeatForever(SKAction.move(by: CGVector(dx:-self.frame.size.width, dy:0), duration:2.325))

                          background.run(parallax)
                          background2.run(parallax)
                          background3.run(parallax)
            ground.run(parallax)
            ground2.run(parallax)
            ground3.run(parallax)
            gameStarted = true
          run(flapSound)
            start.run(SKAction.scale(to: 0.001, duration: 0.3))
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(spawn), userInfo: nil, repeats: true)

            ghost.physicsBody?.affectedByGravity = true
     
                  
                   let distance = CGFloat(self.frame.width + wallPair.frame.width)
            movePipes = SKAction.moveBy(x: -distance-220, y: 0, duration: 0.004*Double(distance))

            
                    removePipes = SKAction.removeFromParent()
                   moveAndRemove = SKAction.sequence([movePipes, removePipes])

            ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 280))

          
            
        }
        else {
            run(flapSound)

            ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                       ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 280))
       
        
        
        
        }
      
        
            
            if died == true{
                
                timer.invalidate()
                

                           restartScene()
                           
                       }
         
        
 
        }
    
    
 
 

     
 
    @objc func createWalls()
    {
        let dispatchQueue = DispatchQueue.init(label: "queue", attributes: .concurrent)
        dispatchQueue.async {
            
            
        
            
            
           
            self.wallPair = SKNode()
            self.wallPair.name = "wallPair"
            
                
                
                let topWall = SKSpriteNode(imageNamed: "topWall")
                
                topWall.position = CGPoint(x: self.frame.width + 100, y: self.frame.height/1.2-5 + 120)

                topWall.size.height += 500

                topWall.setScale(0.5)


            topWall.physicsBody = SKPhysicsBody(texture: self.topWallTex, size: CGSize(width: 200, height: 800) )
                topWall.physicsBody?.categoryBitMask = Physics.wall
                topWall.physicsBody?.collisionBitMask = Physics.ghost
                topWall.physicsBody?.contactTestBitMask = Physics.ghost
                topWall.physicsBody?.affectedByGravity = false
                topWall.physicsBody?.isDynamic = false
                
                
                let bottomWall = SKSpriteNode(imageNamed: "bottomWall")
                bottomWall.position = CGPoint(x: self.frame.width + 112, y: self.frame.height/3.5-5 - 120 )
                bottomWall.size.height += 500
                bottomWall.setScale(0.5)
                
            bottomWall.physicsBody = SKPhysicsBody(texture: self.botWallTex, size: CGSize(width: 200, height: 800))
                       bottomWall.physicsBody?.categoryBitMask = Physics.wall
                       bottomWall.physicsBody?.collisionBitMask = Physics.ghost
                       bottomWall.physicsBody?.contactTestBitMask = Physics.ghost
                       bottomWall.physicsBody?.affectedByGravity = false
                       bottomWall.physicsBody?.isDynamic = false
               
           

                
                
                let randomPosition = CGFloat.random(in: -200 ... 200)
            self.wallPair.position.y = self.wallPair.position.y +  randomPosition

            self.wallPair.zPosition = 1
              
                
                let scoreNode = SKSpriteNode(imageNamed: "Coin")
                              
                       scoreNode.size = CGSize(width: 0.001, height: 0.001)
                              scoreNode.position = CGPoint(x: self.frame.width + 185, y: self.frame.height / 2)
                       scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 450))
                              scoreNode.physicsBody?.affectedByGravity = false
                       scoreNode.physicsBody?.isDynamic = false
                              scoreNode.physicsBody?.categoryBitMask = Physics.Score
                              scoreNode.physicsBody?.collisionBitMask = 0
                              scoreNode.physicsBody?.contactTestBitMask = Physics.ghost
                              
           
             DispatchQueue.main.async{
                self.wallPair.addChild(topWall)
                self.wallPair.addChild(bottomWall)
            self.wallPair.addChild(scoreNode)

            self.addChild(self.wallPair)
                
            
            self.wallPair.run(self.moveAndRemove)
            }
            
            
            
        }
       

        
    }
    
    
    
        
    override func update(_ currentTime: TimeInterval) {
        
        if background.position.x <= -self.frame.size.width/2 {
            background.position.x = self.frame.size.width*2.5
                      
                  }
               if background2.position.x <= -self.frame.size.width/2{
                background2.position.x = self.frame.size.width*2.5
                     
                  }
               if background3.position.x <= -self.frame.size.width/2{
                background3.position.x = self.frame.size.width*2.5
                   
                  }
        
        if ground.position.x <= -self.frame.size.width/2 {
            ground.position.x = self.frame.size.width*2.5
        }
        
        if ground2.position.x <= -self.frame.size.width/2 {
            ground2.position.x = self.frame.size.width*2.5
        }
        
        if ground3.position.x <= -self.frame.size.width/2 {
            ground3.position.x = self.frame.size.width*2.5
        }
    }
   
}

