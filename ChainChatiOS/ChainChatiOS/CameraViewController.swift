//
//  CameraViewController.swift
//  ChainChatiOS
//
//  Created by Jeremy Francispillai on 2014-09-20.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate{
        
    @IBAction func takeVideo(sender: AnyObject) {
        beginVideo()
    }
    
    
    @IBAction func sendButtonClick(sender: AnyObject) {
        getVideos()
    }
    
    
    var camera:UIImagePickerController = UIImagePickerController()
    var player:MPMoviePlayerController = MPMoviePlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginVideo()
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
    
    //pragma mark- Image
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        var videoURL = info.objectForKey(UIImagePickerControllerMediaURL) as NSURL
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        /*self.player = MPMoviePlayerController()
        self.player.contentURL = videoURL
        player.prepareToPlay()
        //self.player.setFullscreen(true, animated: true)
        player.view.frame = self.view.bounds
        self.view.addSubview(self.player.view)
        
        self.player.play()*/
        
        var videoData:NSData = NSData.dataWithContentsOfURL(videoURL, options: nil, error: nil)
        var videoFile = PFFile(name: "video.mp4", data: videoData)
        
        var videoObject = PFObject(className: "video")
        videoObject["video"] = videoFile
        videoObject["recipient"] = "qwe"
        videoObject.saveInBackground()
        
        //videoFile.saveInBackground()
        println("video saved")
        
        
        
        
        
        /*
        self.videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        self.videoController = [[MPMoviePlayerController alloc] init];
        
        [self.videoController setContentURL:self.videoURL];
        [self.videoController.view setFrame:CGRectMake (0, 0, 320, 460)];
        [self.view addSubview:self.videoController.view];
        
        [self.videoController play];
        */
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func getVideos(){
        
        
        
        //self.player.play()
        
        var query = PFQuery(className: "video")
        query.whereKey("recipient", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println(objects.count)

                for object in objects {
                    var message:PFObject = object as PFObject
                    var videoFile:PFFile = message["video"] as PFFile
                    var videoURL = NSURL.URLWithString(videoFile.url)
                    self.player.contentURL = videoURL
                    self.player.prepareToPlay()
                    self.player.view.frame = self.view.bounds
                    self.view.addSubview(self.player.view)
                    self.player.play()
                }
            } else {

            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    

}
