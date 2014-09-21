//
//  MainViewController.swift
//  ChainChatiOS
//
//  Created by Jeremy Francispillai on 2014-09-20.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    var player:MPMoviePlayerController = MPMoviePlayerController()
    var camera:UIImagePickerController = UIImagePickerController()
    var messages = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clickTakeVideo(sender: AnyObject) {
        takeVideo()
    }
    
    
    
    override func viewWillAppear(animated: Bool){
        getVideos()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath)  as NameTableViewCell
        //cell.name.text = messages[indexPath.row]["sender"] as? String
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var message = messages[indexPath.row]
        var videoFile:PFFile = message["video"] as PFFile
        var videoURL = NSURL.URLWithString(videoFile.url)
        self.player.contentURL = videoURL
        self.player.prepareToPlay()
        self.player.view.frame = self.view.bounds
        self.view.addSubview(self.player.view)
        self.player.setFullscreen(true, animated: true)
        self.player.play()    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getVideos(){
        println("getVideos")
        messages.removeAll(keepCapacity: true)
        var query = PFQuery(className: "video")
        query.whereKey("recipient", equalTo: PFUser.currentUser().username)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println(objects.count)
                
                for object in objects {
                    var message:PFObject = object as PFObject
                    self.messages.append(message)
                    /*var videoFile:PFFile = message["video"] as PFFile
                    var videoURL = NSURL.URLWithString(videoFile.url)
                    self.player.contentURL = videoURL
                    self.player.prepareToPlay()
                    self.player.view.frame = self.view.bounds
                    self.view.addSubview(self.player.view)
                    self.player.play()*/
                }
                
            }
            self.tableView.reloadData()
        }
    }
    
    
    func takeVideo()
    {
        camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        camera.mediaTypes.append(kUTTypeMovie)
        camera.mediaTypes.removeAtIndex(0)
        camera.allowsEditing = false
        //camera.videoMaximumDuration = 5
        
        self.presentViewController(camera, animated: true, completion: nil)
        //NSThread.sleepForTimeInterval(5)
        //camera.stopVideoCapture()
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        var videoURL = info.objectForKey(UIImagePickerControllerMediaURL) as NSURL
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func saveVideo(videoURL:NSURL){
        
        
        var videoData:NSData = NSData.dataWithContentsOfURL(videoURL, options: nil, error: nil)
        var videoFile = PFFile(name: "video.mp4", data: videoData)
        
        var videoObject = PFObject(className: "video")
        videoObject["video"] = videoFile
        videoObject["recipient"] = "qwe"
        videoObject.saveInBackground()
        
        println("video saved")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
