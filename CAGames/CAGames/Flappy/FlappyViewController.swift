//
//  FlappyViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/10.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SpriteKit

let SCREEN_SIZE = UIScreen.main.bounds


class FlappyViewController: UIViewController {
    var gameModel = FlappyGameModel()
    var timer: CADisplayLink!
    var timerOfBg: CADisplayLink!
    var timerOfWood: CADisplayLink!
    var T = 0.25
    
    let G = 9.8
    
    var bird: UIImageView!
    
    var birdModel: FlappyBird {
        return gameModel.bird
    }
    
    var isGameOver: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        createWood()
        createBird()
        // Do any additional setup after loading the view.
        createTimer()
    }
    
    func createTimer() {
        timer = CADisplayLink(target: self, selector: #selector(moveBird(step:)))
        timer.add(to: .current,
                  forMode: RunLoop.Mode.default)
        timerOfBg = CADisplayLink(target: self, selector: #selector(moveBackground(strp:)))
        timerOfBg.add(to: .current,
                       forMode: RunLoop.Mode.default)
        timerOfWood = CADisplayLink(target: self, selector: #selector(moveWood(step:)))
        timerOfWood.add(to: .current, forMode: .default)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func createBird() {
        let height = SCREEN_SIZE.height
        var images = [UIImage]()
        for i in 1...4 {
            if let img = UIImage(named: "bird\(i)") {
               images.append(img)
            } 
        }
        
        bird = UIImageView(frame: CGRect(x: 50, y: 200, width: 35, height: 35))
        bird.animationImages = images
        bird.animationRepeatCount = 0
        bird.animationDuration=0.3
        bird.image=images[0] as? UIImage
        bird.startAnimating()
        self.view.addSubview(bird)
    }
    
    func createWood() {
        let imageTop = UIImage(named: "pipeTop")
        let imageBottom = UIImage(named: "pipeBottom")
        var view1 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width, y: -SCREEN_SIZE.height, width: WoodWidth, height: SCREEN_SIZE.height))
        var view2 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width, y: SCREEN_SIZE.height, width: WoodWidth, height: SCREEN_SIZE.height))
        view1.image = imageTop
        view2.image = imageBottom
        view1.tag = 301
        view2.tag = 302
        
        var view3 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width + DisBetweenWoods , y: -SCREEN_SIZE.height, width: WoodWidth, height: SCREEN_SIZE.height))
        var view4 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width + DisBetweenWoods, y: SCREEN_SIZE.height, width: WoodWidth, height: SCREEN_SIZE.height))
        view3.image = imageTop
        view4.image = imageBottom
        view3.tag = 303
        view4.tag = 304
        
        var view5 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width + 2*DisBetweenWoods, y: -SCREEN_SIZE.height, width: WoodWidth, height: SCREEN_SIZE.height))
        var view6 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width + 2*DisBetweenWoods, y: SCREEN_SIZE.height, width: WoodWidth, height: SCREEN_SIZE.height))
        view5.image = imageTop
        view6.image = imageBottom
        view5.tag = 305
        view6.tag = 306
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        self.view.addSubview(view3)
        self.view.addSubview(view4)
        self.view.addSubview(view5)
        self.view.addSubview(view6)
    }
    
    func woodAppear(withWoodTop top: UIView, woodBottom bottom: UIView) {
        let height = 222.arc4random + 30
        var rectTop = top.frame
        rectTop.origin.y += CGFloat(height)
        top.frame = rectTop
        var rectBottom = bottom.frame
        rectBottom.origin.y = CGFloat(height + 100)
        bottom.frame = rectBottom
    }
    
    @objc func moveWood(step: CADisplayLink) {
        if let wood1 = view.viewWithTag(301),
            let wood2 = view.viewWithTag(302),
            let wood3 = view.viewWithTag(303),
            let wood4 = view.viewWithTag(304),
            let wood5 = view.viewWithTag(305),
            let wood6 = view.viewWithTag(306) {
            if wood1.frame.origin.x < -offsetOfWood {
                var frame1 = wood1.frame
                frame1.origin.x -= 2
                wood1.frame = frame1
                var frame2 = wood2.frame
                frame2.origin.x -= 2
                wood2.frame = frame2
            } else {
                var frame1 = wood1.frame
                frame1.origin.x = ScreenSize.width
                wood1.frame = frame1
                var frame2 = wood2.frame
                frame2.origin.x = ScreenSize.width
                wood2.frame = frame2
                woodAppear(withWoodTop: wood1, woodBottom: wood2)
            }
            if wood3.frame.origin.x < -offsetOfWood {
                var frame3 = wood1.frame
                frame3.origin.x -= 2
                wood3.frame = frame3
                var frame4 = wood4.frame
                frame4.origin.x -= 2
                wood4.frame = frame4
            } else {
                var frame3 = wood3.frame
                frame3.origin.x = ScreenSize.width
                wood3.frame = frame3
                var frame4 = wood4.frame
                frame4.origin.x = ScreenSize.width
                wood4.frame = frame4
                woodAppear(withWoodTop: wood3, woodBottom: wood4)
            }
            if wood5.frame.origin.x < -offsetOfWood {
                var frame5 = wood1.frame
                frame5.origin.x -= 2
                wood5.frame = frame5
                var frame6 = wood4.frame
                frame6.origin.x -= 2
                wood6.frame = frame6
            } else {
                var frame5 = wood5.frame
                frame5.origin.x = ScreenSize.width
                wood5.frame = frame5
                var frame6 = wood6.frame
                frame6.origin.x = ScreenSize.width
                wood6.frame = frame6
                woodAppear(withWoodTop: wood5, woodBottom: wood6)
            }
        }
    }
    
    
    func setupBackgroundView() {
        let image = UIImage(named: "bg")
        var imageView101 = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height))
        imageView101.image = image
        var imageView102 = UIImageView(frame: CGRect(x: SCREEN_SIZE.width, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height))
        imageView102.image = image
        imageView101.tag = 101
        imageView102.tag = 102
        self.view.addSubview(imageView101)
        self.view.addSubview(imageView102)
        
    }
    
    @objc func moveBackground(strp: CADisplayLink) {
        if var view101 = view.viewWithTag(101), var view102 = view.viewWithTag(102) {
            if view101.frame.origin.x > -SCREEN_SIZE.width {
                var frame = view101.frame
                frame.origin.x -= 1
                view101.frame = frame
            } else {
                var frame = view101.frame
                frame.origin.x = SCREEN_SIZE.width
                view101.frame = frame
            }
            if view102.frame.origin.x > -SCREEN_SIZE.width {
                var frame = view102.frame
                frame.origin.x -= 1
                view102.frame = frame
            } else {
                var frame = view102.frame
                frame.origin.x = SCREEN_SIZE.width
                view102.frame = frame
            }
        }
        
    }
  
    @objc func moveBird(step: CADisplayLink) {
        print("Bird pos: \(bird.frame.origin.y) Bird direction: \(birdModel.direction) timestamp: \(step.timestamp)")
        switch birdModel.direction {
        case .up:
            if bird.frame.origin.y < SCREEN_SIZE.height - 100 {
                var rect = bird.frame
                rect.origin.y += CGFloat(G*T*T/2) // 1/2 * g * t^2 初始速度为零的下降s
                bird.frame = rect
                T += 0.025
                gameModel.bird.direction = .down
            }
        case .down:
            if T < 0.24 {
                var rect = bird.frame
                rect.origin.y -= 4.9-(CGFloat)(G*T*T/2)
                bird.frame = rect
                T += 0.25
            }
        default:
            return
        }
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            
        } else {
            gameModel.bird.direction = .up
            T = 0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FlappyViewController {
    struct SizeRatio {
        
    }
    
    private var ScreenSize: CGSize {
        return self.view.bounds.size
    }
    
    private var WoodWidth: CGFloat {
        return 53
    }
    
    private var DisBetweenWoods: CGFloat {
        return (ScreenSize.width - paddingLeft)/2 - WoodWidth
    }
    
    private var offsetOfWood: CGFloat {
        return DisBetweenWoods - paddingLeft + WoodWidth
    }
    
    private var paddingLeft: CGFloat {
        return WoodWidth - 4
    }
}
