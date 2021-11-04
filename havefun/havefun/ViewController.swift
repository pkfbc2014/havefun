//
//  ViewController.swift
//  havefun
//
//  Created by PanDapao on 2021/10/28.
//  Copyright © 2021 PanDapao. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer_giao: AVAudioPlayer! //Create audioPlayer of giao
var audioPlayer_en: AVAudioPlayer! //Create audioPlayer of en
var audioPlayer_zen: AVAudioPlayer! //Create audioPlayer of zen me shuo ne
var audioPlayer_cao: AVAudioPlayer! //Create audioPlayer of kan wo cao zuo
var audioPlayer_kang: AVAudioPlayer! //Create audioPlayer of rang wo kang kang
var audioPlayer_bkmusic: AVAudioPlayer! //Create audioPlayer of background music
var button_sound_whether: Bool = true //按键音控制，false关闭，true打开

func playSound_bkmusic() //Create sound playing function
{
    let soundUrl = Bundle.main.url(forResource: "aliu", withExtension: "mp3") //Url to sound file
    do
    {
        audioPlayer_bkmusic = try AVAudioPlayer(contentsOf: soundUrl!) //Make player with sound file
    }
    catch
    {
        print(error)
    }
    audioPlayer_bkmusic.numberOfLoops = -1 //无限循环bgm
    audioPlayer_bkmusic.play() //Play sound
}

func stopSound_bkmusic() //Create sound playing function
{
    audioPlayer_bkmusic.stop() //stop playing background music
}

func playSound_giao() //Create sound playing function
{
    let soundUrl = Bundle.main.url(forResource: "giao", withExtension: "mp3") //Url to sound file
    do
    {
        audioPlayer_giao = try AVAudioPlayer(contentsOf: soundUrl!) //Make player with sound file
    }
    catch
    {
        print(error)
    }
    if button_sound_whether == true
    {
        audioPlayer_giao.play() //Play sound
    }
}

func playSound_en() //Create sound playing function
{
    let soundUrl = Bundle.main.url(forResource: "en", withExtension: "mp3") //Url to sound file
    do
    {
        audioPlayer_en = try AVAudioPlayer(contentsOf: soundUrl!) //Make player with sound file
    }
    catch
    {
        print(error)
    }
    if button_sound_whether == true
    {
        audioPlayer_en.play() //Play sound
    }
}

func playSound_zen() //Create sound playing function
{
    let soundUrl = Bundle.main.url(forResource: "zen", withExtension: "mp3") //Url to sound file
    do
    {
        audioPlayer_zen = try AVAudioPlayer(contentsOf: soundUrl!) //Make player with sound file
    }
    catch
    {
        print(error)
    }
    if button_sound_whether == true
    {
        audioPlayer_zen.play() //Play sound
    }
}

func playSound_cao() //Create sound playing function
{
    let soundUrl = Bundle.main.url(forResource: "cao", withExtension: "mp3") //Url to sound file
    do
    {
        audioPlayer_cao = try AVAudioPlayer(contentsOf: soundUrl!) //Make player with sound file
    }
    catch
    {
        print(error)
    }
    if button_sound_whether == true
    {
        audioPlayer_cao.play() //Play sound
    }
}

func playSound_kang() //Create sound playing function
{
    let soundUrl = Bundle.main.url(forResource: "kang", withExtension: "mp3") //Url to sound file
    do
    {
        audioPlayer_kang = try AVAudioPlayer(contentsOf: soundUrl!) //Make player with sound file
    }
    catch
    {
        print(error)
    }
    if button_sound_whether == true
    {
        audioPlayer_kang.play() //Play sound
    }
}

public func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->()) //延时器函数自实现
{
    if repeatCount <= 0
    {
        return
    }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
    timer.schedule(wallDeadline: .now(), repeating: timeInterval)
    timer.setEventHandler(handler:
    {
        count -= 1
        DispatchQueue.main.async
        {
            handler(timer, count)
        }
        if count == 0
        {
            timer.cancel()
        }
    })
    timer.resume()
}

class ViewController: UIViewController
{
    var bkmusic_whether: Bool = false //背景音乐控制，false关闭，true打开
    var totalbool: Bool = false //一局游戏结束总控制，保证游戏结束后不能see again
    var difficult_choose: Bool = false //是否进行难度选择，保证最多只进行一次难度选择
    var start_whether: Bool = false //是否点击开始游戏，保证在开始游戏前卡片不能点击
    var totalindex: Int = 4 //游戏难度：默认4个随机数（简单难度）
    var card_total: Int = 48 //总卡片数
    var nowindex: Int = 0 //当前游戏进行到序列的下标
    var timeinter: Double = 0.8 //卡片刷新时间间隔
    lazy var game = havefun(numberOfCards: card_total) //实例化游戏对象
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var seeagain: UIButton!
    @IBOutlet var cardButtons: [UIButton]! //按钮数组
    @IBOutlet weak var bkmusic: UIButton! //背景音乐开关
    @IBOutlet weak var button_sound: UIButton! //按键音开关
    lazy var sequence = [Int](repeating: 0, count: 14) //每次游戏的随机数序列
    var mapping1: [Int] = [2, 4, 5, 3, 0, 1, 9, 6, 10, 11, 7, 8, 13, 16, 17, 14, 12, 15, 22, 21, 19, 18, 23, 20, 29, 26, 28, 25, 24, 27, 35, 31, 34, 30, 32, 33, 36, 39, 38, 40, 41, 37, 45, 42, 46, 43, 44, 47] //想要按下的按钮号到实际按钮号的映射（手动映射）
    var mapping2: [Int] = [4, 5, 0, 3, 1, 2, 7, 10, 11, 6, 8, 9, 16, 12, 15, 17, 13, 14, 21, 20, 23, 19, 18, 22, 28, 27, 25, 29, 26, 24, 33, 31, 34, 35, 32, 30, 36, 41, 38, 37, 39, 40, 43, 45, 46, 42, 44, 47] //实际按钮号到想要按下的按钮号的映射（手动映射）
    
    func randomInt(min: Int, max: Int) -> Int //生成min到max的随机数
    {
        return Int(arc4random()) % (max - min + 1) + min
    }
    
    @IBAction func touchCard1(_ sender: UIButton)
    {
        if start_whether == true //已经点击开始游戏
        {
            if let temp_cardnumber = cardButtons.index(of: sender) //检查是否接收成功
            {
                var cardnumber = temp_cardnumber //转cardnumber为变量
                cardnumber = mapping2[cardnumber] //做手动映射
                if cardnumber == sequence[nowindex > (totalindex - 1) ? totalindex - 1 : nowindex] && (totalbool == false) //越界处理
                {
                    game.UptheCard(at: temp_cardnumber)
                    updateViewFromModel()
                    nowindex = nowindex + 1
                    if (nowindex >= totalindex) && (totalbool == false) //>=是做越界处理
                    {
                        updateViewOfheart() //匹配成功游戏结束，所有卡片变成爱心
                        totalbool = true //一局游戏结束
                        playSound_en() //en
                    }
                    if totalbool == false //不是游戏结束前的最后一个按钮，giao
                    {
                        playSound_giao() //giao
                    }
                }
                else
                {
                    if totalbool == false
                    {
                        updateViewOfFail() //匹配失败游戏结束，所有卡片变成鬼脸
                        totalbool = true //一局游戏结束
                        playSound_zen() //zen me shuo ne
                    }
                }
            }
            else
            {
                print("chosed card is not in cardButtons!")
            }
        }
    }
    
    @IBAction func start(_ sender: UIButton) //生成新的随机数序列，播放
    {
        start_whether = true
        playSound_cao() //kan wo cao zuo
        start.setTitle("New Once", for: .normal)
        totalbool = false //新开始一局游戏
        game.start_init() //清除上次游戏点过的卡片
        nowindex = 0
        var i_up: Int = 0
        var i_down: Int = 0
        var flag: Bool = false //每次刷新标志（跳过第一次刷新）
        for i in 0...(totalindex - 1) //生成新的随机数序列
        {
            let a = randomInt(min: 0, max: card_total - 1)
            sequence[i] = a
        }
        
        DispatchTimer(timeInterval: timeinter, repeatCount: totalindex)
        {
            (timer, count) in
            self.updateViewFromModel()
            self.game.UptheCard(at: self.mapping1[self.sequence[i_up]])
            self.updateViewFromModel()
            i_up = i_up + 1
        }
        DispatchTimer(timeInterval: timeinter, repeatCount: totalindex + 1)
        {
            (timer, count) in
            if flag == true
            {
                self.updateViewFromModel()
                self.game.DowntheCard(at: self.mapping1[self.sequence[i_down]])
                self.updateViewFromModel()
                i_down = i_down + 1
            }
            flag = true
        }
    }
    
    @IBAction func seeagain(_ sender: UIButton) //播放已经生成的随机数序列
    {
        if start_whether == true //点了start后才可以点击see again
        {
            if totalbool == false //游戏未结束才可以点击see again
            {
                playSound_kang() //rang wo kang kang
                game.start_init() //清除上次游戏点过的卡片
                var i_up: Int = 0
                var i_down: Int = 0
                var flag: Bool = false //每次刷新标志（跳过第一次刷新）
                DispatchTimer(timeInterval: timeinter, repeatCount: totalindex)
                {
                    (timer, count) in
                    self.updateViewFromModel()
                    self.game.UptheCard(at: self.mapping1[self.sequence[i_up]])
                    self.updateViewFromModel()
                    i_up = i_up + 1
                }
                DispatchTimer(timeInterval: timeinter, repeatCount: totalindex + 1)
                {
                    (timer, count) in
                    if flag == true
                    {
                        self.updateViewFromModel()
                        self.game.DowntheCard(at: self.mapping1[self.sequence[i_down]])
                        self.updateViewFromModel()
                        i_down = i_down + 1
                    }
                    flag = true
                }
            }
        }
    }
    
    @IBOutlet weak var easy: UIButton!
    @IBOutlet weak var middle: UIButton!
    @IBOutlet weak var difficult: UIButton!
    @IBOutlet weak var text: UILabel! //please select game difficulty
    
    @IBAction func easy(_ sender: UIButton)
    {
        if difficult_choose == false
        {
            totalindex = 4
            easy.setTitle("", for: .normal)
            middle.setTitle("", for: .normal)
            difficult.setTitle("", for: .normal)
            easy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            middle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            difficult.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            start.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            seeagain.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            start.setTitle("Start", for: .normal)
            start.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            seeagain.setTitle("See again", for: .normal)
            seeagain.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            difficult_choose = true
        }
    }
    
    @IBAction func middle(_ sender: UIButton)
    {
        if difficult_choose == false
        {
            totalindex = 8
            easy.setTitle("", for: .normal)
            middle.setTitle("", for: .normal)
            difficult.setTitle("", for: .normal)
            easy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            middle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            difficult.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            start.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            seeagain.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            start.setTitle("Start", for: .normal)
            start.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            seeagain.setTitle("See again", for: .normal)
            seeagain.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            difficult_choose = true
        }
    }
    
    @IBAction func difficult(_ sender: UIButton)
    {
        if difficult_choose == false
        {
            totalindex = 14
            easy.setTitle("", for: .normal)
            middle.setTitle("", for: .normal)
            difficult.setTitle("", for: .normal)
            easy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            middle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            difficult.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            
            start.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            seeagain.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            start.setTitle("Start", for: .normal)
            start.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            seeagain.setTitle("See again", for: .normal)
            seeagain.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            difficult_choose = true
        }
    }
    
    @IBAction func back(_ sender: UIButton) //回到开始界面
    {
        //以下变量初始化
        nowindex = 0 //初始化已翻卡片数
        totalbool = false //初始化一局游戏结束总控制
        difficult_choose = false //初始化是否进行难度选择
        start_whether = false //初始化是否点击开始游戏
        
        //以下界面初始化
        for index in cardButtons.indices //卡牌全部背面朝上
        {
            let temp_button = cardButtons[index]
            temp_button.setTitle("", for: .normal)
            temp_button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        easy.setTitle("Easy", for: .normal) //easy按钮
        easy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        middle.setTitle("Middle", for: .normal) //middle按钮
        middle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        difficult.setTitle("Difficult", for: .normal) //difficult按钮
        difficult.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        start.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) //start按钮
        start.setTitle("", for: .normal)
        start.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: .normal)
        
        seeagain.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) //see again按钮
        seeagain.setTitle("", for: .normal)
        seeagain.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: .normal)
    
        text.textColor = #colorLiteral(red: 0.9535340636, green: 1, blue: 0.2392067013, alpha: 1)
    }
    
    func updateViewFromModel() //根据card数组刷新卡牌界面
    {
        for index in cardButtons.indices
        {
            let temp_button = cardButtons[index]
            let temp_card = game.cards[index]
            if temp_card.isFaceUp
            {
                temp_button.setTitle("", for: .normal)
                temp_button.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
            }
            else
            {
                temp_button.setTitle("", for: .normal)
                temp_button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    func updateViewOfheart() //游戏胜利爱心
    {
        for index in cardButtons.indices
        {
            cardButtons[index].setTitle("❤️", for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func updateViewOfFail() //游戏失败鬼脸
    {
        for index in cardButtons.indices
        {
            cardButtons[index].setTitle("👻", for: .normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func sound(_ sender: UIButton) //background music
    {
        if bkmusic_whether == false //当前背景音乐处于关闭态，点击后播放
        {
            playSound_bkmusic()
            bkmusic.setTitle("🎵🔊", for: .normal)
            bkmusic_whether = true
        }
        else //当前背景音乐处于播放态，点击后关闭
        {
            stopSound_bkmusic()
            bkmusic.setTitle("🎵🔇", for: .normal)
            bkmusic_whether = false
        }
    }
    
    @IBAction func button_sound(_ sender: UIButton)
    {
        if button_sound_whether == false //当前按键音处于关闭态，点击后开启
        {
            button_sound_whether = true
            button_sound.setTitle("🔘🔊", for: .normal)
        }
        else //当前按键音处于开启态，点击后关闭
        {
            button_sound_whether = false
            button_sound.setTitle("🔘🔇", for: .normal)
        }
    }
}
