//
//  BIZImagePagerViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/9/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIkit.h>


// * Class defines VC of pages as BIZImageViewController views with capabilities of BIZImageViewController, pages scrollable in horizontal direction
@interface BIZImagePagerViewController : UIViewController
- (instancetype)initFromNib;
@property (nonatomic, strong) NSArray *dataSource; // of NSURL
@end
