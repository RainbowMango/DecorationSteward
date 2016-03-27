//
//  CommentTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/3/20.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import InfiniteCollectionView

class CommentTableViewController: UITableViewController {
    @IBOutlet weak var collectionView: InfiniteCollectionView!
    
    var reviewItems = Array<String>() //评论项目，由前面controller传入

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        设置InfiniteCollectionView
        必须制定单个cell的宽度
        */
        collectionView.infiniteDataSource = self
        collectionView.infiniteDelegate   = self
        collectionView.cellWidth          = 80

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     发布评价
     
     - parameter sender: 触发事件的view
     */
    @IBAction func publishComments(sender: AnyObject) {
        print("发布评价")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StarReviewCell", forIndexPath: indexPath) as! StarReviewTableViewCell

        cell.configure(reviewItems[indexPath.row])

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentTableViewController: InfiniteCollectionViewDataSource, InfiniteCollectionViewDelegate {
    
    func numberOfItems(collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: NSIndexPath, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCollectionViewCell.identifier, forIndexPath: dequeueIndexPath) as! ImageCollectionViewCell
        if(indexPath.row % 2 == 0) {
            cell.configure("camera")
        }
        else{
            cell.configure("userDefaultAvatar")
        }
        
        return cell
    }
    
    func didSelectCellAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        print("selected index: \(indexPath.row)")
    }
}
