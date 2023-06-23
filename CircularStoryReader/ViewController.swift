//
//  ViewController.swift
//  CircularStoryReader
//
//  Created by Akshay Kumar on 31/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Cell Outlets
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    
    //MARK: Define Array
//    var userArray = ["pic","pic","pic","pic","pic"]
    var userArray = [StoryModel]()
    var storyArray = [StoryArray]()
    var indicators: [StorySegmentIndicator] = []
    
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCell()
        
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        
        
        storyArray.append(StoryArray(storyImage: "pic", seenType: 1))
        storyArray.append(StoryArray(storyImage: "pic", seenType: 0))
        storyArray.append(StoryArray(storyImage: "pic", seenType: 0))
        storyArray.append(StoryArray(storyImage: "pic", seenType: 0))
        storyArray.append(StoryArray(storyImage: "pic", seenType: 0))
        
        
        if storyArray.count > 0 {
            userArray.append(StoryModel.init(imageURL: "pic", userStoryArray: storyArray))
            userArray.append(StoryModel.init(imageURL: "pic", userStoryArray: storyArray))
            userArray.append(StoryModel.init(imageURL: "pic", userStoryArray: storyArray))
            userArray.append(StoryModel.init(imageURL: "pic", userStoryArray: storyArray))
        }
        else {
            // Do Something here...
        }
    }
    
    
    //MARK: RegisterCollectionView Cell
    func registerCollectionViewCell(){
        storyCollectionView.register(UINib(nibName: "StoryCVC", bundle: nil), forCellWithReuseIdentifier: "StoryCVC")
    }
    
}


//MARK: CollectionView Deleagte & DataSource Methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76, height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let storyCount = userArray[indexPath.row].userStoryArray.count

        var settings = StorySegmentIndicatorSettings()
        settings.segmentBorderType = .round
        settings.segmentWidth = 2
        settings.segmentsCount = storyCount
        
        let segment = StorySegmentIndicator(frame: CGRect(x: 0, y: 0, width: 76, height: 76))
        segment.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        segment.settings = settings
        segment.settings.defaultSegmentColor = UIColor(red: 255.0/255, green: 71.0/255, blue: 32.0/255, alpha: 1)
        
        let stories = userArray[indexPath.row].userStoryArray
        segment.drawStaticSegments(stories: stories)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCVC", for: indexPath) as? StoryCVC else {
            return UICollectionViewCell()
        }
        
        cell.colorView.subviews.forEach { $0.removeFromSuperview() } // Remove any existing subviews from the colorView
        
        cell.colorView.addSubview(segment)
        
        return cell
    }
}
