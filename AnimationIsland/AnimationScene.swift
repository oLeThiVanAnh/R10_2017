//
//  AnimationScene.swift
//  AnimationIsland
//
//  Created by Administrator on 2/9/17.
//  Copyright © Le Thi Van Anh. All rights reserved.
//

import SpriteKit

class AnimationScene: SKScene {
    let kHeartScaleWithScreenSize:CGFloat = 0.2
    let kAnimationDuration:Double = 1
    var backgroudSprite: SKSpriteNode!
    var centerHeart: SKSpriteNode!
    var isRunningAnimation = false
    var centerHeartSize = CGSize(width: 0, height: 0)
    var heartWidth:CGFloat = 0


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        super.init(size: size)
        addHeartCenter()
    }
    func addHeartCenter(){
        self.backgroudSprite = SKSpriteNode(color: UIColor.white, size: size)
        self.backgroudSprite.position = CGPoint(x: 0, y: 0)
        self.backgroudSprite.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(backgroudSprite)

        //Calculate center heart size
        heartWidth = [UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height].min()! * self.kHeartScaleWithScreenSize;
        self.centerHeartSize = CGSize(width: heartWidth, height: heartWidth)

        //Add center heart to the scene
        self.centerHeart =  SKSpriteNode(imageNamed: "heart")
        self.centerHeart.position = CGPoint(x: size.width/2, y: size.height/2)
        self.centerHeart.size = self.centerHeartSize

        self.backgroudSprite.addChild(self.centerHeart)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.isRunningAnimation {
            return;
        }
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        // Center heart was touched
        if(self.centerHeart.contains(touchLocation!)){
            self.exploreHeart(numberOfHeart: 10, duration: self.kAnimationDuration)
            self.zoomingHeartCenter()
        }
    }
    
    func zoomingHeartCenter() {
        let scaleDownAction = SKAction.scale(to: 0.1, duration: 0.05)
        let scaleUpAction = SKAction.scale(to: 1, duration: 0.1)
        let scaleActionSequence = SKAction.sequence([scaleDownAction, scaleUpAction])
        centerHeart.run(scaleActionSequence)
    }

    func exploreHeart(numberOfHeart:Int, duration:Double){

        let centerX:CGFloat = self.size.width / 2.0
        let centerY:CGFloat = self.size.height / 2.0
        for index in 0...numberOfHeart {
            let smallHeart = SKSpriteNode(imageNamed: "heart")
            let angle = 2.0 * .pi / CGFloat(numberOfHeart) * CGFloat(index) + self.randomFloat(minVal: 0, maxVal: 2.0 * .pi / CGFloat(numberOfHeart))
            let xPost = centerX - sin(angle) * centerHeartSize.width / 2.0
            let yPost = centerY - cos(angle) * centerHeartSize.width / 2.0
            smallHeart.position = CGPoint(x: xPost, y: yPost)

            //Random scale from 0.3 to 0.9
            let minScale:CGFloat = 0.9
            let maxScale:CGFloat = 1.5
            let randomScale = self.randomFloat(minVal: minScale, maxVal: maxScale)

            //Random angle from 0.0 to 2PI
            let minAngle:CGFloat = 0.0
            let maxAngle:CGFloat = 2.0 * .pi
            smallHeart.zRotation = self.randomFloat(minVal: minAngle, maxVal: maxAngle)

            //Random alpha from 0.5 to 1.0
            let minAlpha:CGFloat = 0.2
            let maxAlpha:CGFloat = 1.0
            smallHeart.alpha = self.randomFloat(minVal: minAlpha, maxVal: maxAlpha)

            //Add small hert to scene
            self.backgroudSprite.addChild(smallHeart)

            //Run animation for small heart
            let minScreen = [UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height].max()!
            let destionationX = centerX - minScreen / 2.0 * sin(angle) + self.randomFloat(minVal: 0, maxVal: self.centerHeartSize.width / 3.0 * sin(angle))
            let destionationY = centerY - minScreen / 2.0 * cos(angle) + self.randomFloat(minVal: 0, maxVal: self.centerHeartSize.width / 3.0 * cos(angle))


            let minScaleUp:CGFloat = 1.5
            let maxScaleUp:CGFloat = 2.7
            let randomScaleUp = self.randomFloat(minVal: minScaleUp, maxVal: maxScaleUp)
            let scaleUpActionUp = SKAction.scale(by: randomScaleUp, duration: duration/3)

            let radius = [UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height].min()!/1.2
            let destionationXUp = centerX - radius / 2.0 * sin(angle) + self.randomFloat(minVal: 0, maxVal: self.centerHeartSize.width / 5.0 * sin(angle))
            let destionationYUp = centerY - radius / 2.0 * cos(angle) + self.randomFloat(minVal: 0, maxVal: self.centerHeartSize.width / 5.0 * cos(angle))
            let destinationUp = CGPoint(x: destionationXUp, y: destionationYUp)
            let moveAcctionUp = SKAction.move(to: destinationUp, duration: duration/3)
            smallHeart.run(scaleUpActionUp)
            smallHeart.run(moveAcctionUp, completion: {
                smallHeart.removeFromParent()
                var heartArr = [SKSpriteNode](repeating: SKSpriteNode(), count:3)
                for i in 0...2 {

                    heartArr[i] = SKSpriteNode(imageNamed: "heart")
                    heartArr[i].position = CGPoint(x: smallHeart.position.x  , y: smallHeart.position.y)
                    self.backgroudSprite.addChild(heartArr[i])

                    let desX = destionationX + 25
                    let desY = destionationY
                    let moveAcction = SKAction.move(to: CGPoint(x: desX + CGFloat(30 * i),y: desY), duration: duration*2/3)
                    let scaleAction = SKAction.scale(to: 0.01, duration: duration*2/3)
                    heartArr[i].size = CGSize(width:self.heartWidth*randomScale, height: self.heartWidth*randomScale)
                    heartArr[i].run(scaleAction)
                    heartArr[i].run(moveAcction, completion: {
                        heartArr[i].removeFromParent()
                    })
                    heartArr[i].alpha = self.randomFloat(minVal: minAlpha, maxVal: maxAlpha)
                }

                var heartArr2 = [SKSpriteNode](repeating: SKSpriteNode(), count:3)
                for i in 0...2 {
                    heartArr2[i] = SKSpriteNode(imageNamed: "heart")
                    heartArr2[i].position = CGPoint(x: smallHeart.position.x  , y: smallHeart.position.y)
                    self.backgroudSprite.addChild(heartArr2[i])

                    let desX = destionationX + 25
                    let desY = destionationY
                    let moveAcction = SKAction.move(to: CGPoint(x: desX + CGFloat(30 * i),y: desY), duration: duration*2/3)
                    let scaleAction = SKAction.scale(to: 0.01, duration: duration*2/3)
                    let random = self.randomFloat(minVal: 0.3, maxVal: 0.5)
                    heartArr2[i].size = CGSize(width:self.heartWidth*random, height: self.heartWidth*random)
                    let waitAction2 = SKAction.wait(forDuration: TimeInterval(self.randomFloat(minVal: 0.1, maxVal: 0.3)))
                    heartArr2[i].run(waitAction2) {
                        heartArr2[i].run(scaleAction)
                        heartArr2[i].run(moveAcction, completion: {
                            heartArr2[i].removeFromParent()
                        })
                    }
                    heartArr[i].alpha = self.randomFloat(minVal: minAlpha, maxVal: maxAlpha)
                }
            })
        }
    }
    
    func randomFloat(minVal: CGFloat, maxVal: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (maxVal - minVal) + minVal
    }
    
}
