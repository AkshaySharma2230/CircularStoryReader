//
//  StoryModel.swift
//  CircularStoryReader
//
//  Created by Akshay Kumar on 07/06/23.
//

import Foundation


struct StoryModel {
    var imageURL: String?
    var userStoryArray: [StoryArray]
    
    init(imageURL: String? = nil, userStoryArray: [StoryArray]) {
        self.imageURL = imageURL
        self.userStoryArray = userStoryArray
    }
}
                         

struct StoryArray {
    var storyImage: String?
    var seenType: Int?
 
    init(storyImage: String? = nil, seenType: Int? = nil) {
        self.storyImage = storyImage
        self.seenType = seenType
    }
}
