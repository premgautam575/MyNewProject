//
//  FirstViewController.swift
//  MyNewProject
//
//  Created by prem  on 13/09/23.
//

import UIKit
import AVKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    var Sender : Int?
    
    var moviedata = [ResponseData]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var songDescriptionLbl: UILabel!
    @IBOutlet weak var songTitleLbl: UILabel!
    
    @IBOutlet weak var playBtn: NSLayoutConstraint!
    
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var labelOverallDuration: UILabel!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var ButtonPlay: UIButton!
    
    
    func initAudioPlayer(url:String){
        let url = URL(string: url)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        playbackSlider.minimumValue = 0
        
        //To get overAll duration of the audio
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        labelOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
        
        //To get the current duration of the audio
        let currentDuration : CMTime = playerItem.currentTime()
        let currentSeconds : Float64 = CMTimeGetSeconds(currentDuration)
        labelCurrentTime.text = self.stringFromTimeInterval(interval: currentSeconds)
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        
        
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider.value = Float ( time );
                self.labelCurrentTime.text = self.stringFromTimeInterval(interval: time)
            }
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                
                //        self.loadingView.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
                
                //        self.loadingView.isHidden = true
            }
        }
        
        //change the progress value
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        
        //check player has completed playing audio
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)}
    
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        self.ButtonPlay.isHidden = true
        self.pauseBtn.isHidden = false
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0 {
            player?.play()
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        ButtonPlay.isHidden = false
        pauseBtn.isHidden = true
        //reset player when finish
        playbackSlider.value = 0
        let targetTime:CMTime = CMTimeMake(value: 0, timescale: 1)
        player!.seek(to: targetTime)
    }
    
    @IBAction func playButton(_ sender: Any) {
        player?.play()
        self.ButtonPlay.isHidden = true
        self.pauseBtn.isHidden = false
        
    }
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
    
    @IBAction func seekBackWards(_ sender: Any) {
        if player == nil { return }
        self.ButtonPlay.isHidden = true
        self.pauseBtn.isHidden = false
        let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = playerCurrenTime - seekDuration
        if newTime < 0 { newTime = 0 }
        player?.pause()
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
        player?.play()
        
    }
    
    
    @IBAction func seekForward(_ sender: Any) {
        if player == nil { return }
        self.ButtonPlay.isHidden = true
        self.pauseBtn.isHidden = false
        if let duration = player!.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
            let newTime = playerCurrentTime + seekDuration
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as
                                                                   Float64), timescale: 1000)
                player!.seek(to: selectedTime)
            }
            player?.pause()
            player?.play()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
        cell.pushViewBtn.tag = indexPath.row
        cell.pushViewBtn.addTarget(self, action: #selector(pushViewBtnClicked(_:)), for: .touchUpInside)
        
        cell.tabledata = moviedata[indexPath.row]
        return cell
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secondView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirstTableViewCell", bundle: nil), forCellReuseIdentifier: "FirstTableViewCell")
        print(moviedata)
        self.pauseBtn.isHidden = true
        
        fetchMovies{ Response in
            print(Response)
            self.moviedata = Response.data ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func fetchMovies (completion: @escaping(Response) -> Void ) {
        guard let url = URL(string: "https://cms.samespace.com/items/songs") else { return }
        
        let datatask = URLSession.shared.dataTask(with: url) { (data,_,error) in
            if let error = error {
                print ("Error fetching movies: \(error.localizedDescription)")
            }
            guard let jsonData = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(Response.self, from:jsonData)
                print (decodedData)
                completion(decodedData)
            }
            catch {
                print ("Error decoding data.")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        datatask.resume()
    }
    
    @objc func pushViewBtnClicked( _ sender : AnyObject) {
        self.secondView.isHidden = false
        self.ButtonPlay.isHidden = true
        self.pauseBtn.isHidden = false
        let url = moviedata[sender.tag].url ?? ""
        songTitleLbl.text = moviedata[sender.tag].name
        songDescriptionLbl.text = moviedata[sender.tag].artist
        initAudioPlayer(url: url)
        player?.play()
    }
    
    @IBAction func forYouBtn(_ sender: Any) {
        
        
    }
    
    @IBAction func topTrackBtn(_ sender: Any) {
        
        
        
    }
    
    @IBAction func secondViewHideBtn(_ sender: Any) {
        self.secondView.isHidden = true
    }
    
    @IBAction func playBtn(_ sender: Any) {
        
        
    }
    
    @IBAction func backwardBtn(_ sender: Any) {
        
    }
    
    @IBAction func forwardBtn(_ sender: Any) {
        
    }
    
    @IBAction func pauseBtn(_ sender: Any) {
        player?.pause()
        self.pauseBtn.isHidden = true
        self.ButtonPlay.isHidden = false
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
