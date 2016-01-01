//
//  AttachmentViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/3/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIkit.h>


@protocol BIZImageViewControllerDelegate <NSObject>
@optional
// * Notifies about single tap
- (void)singleTapGestureRecognizerEvent:(UITapGestureRecognizer *)gesture;
// * Notifies then image loaded from URL
- (void)imageDidLoaded;
@end


// * Class define ImageView that connected with screen edges. It have 4 hidden buttons in the corners.
// * 2 taps on imageView area makes zoom in/zoom out in it, image connected to screen bounds in zoom
// * 1 tap calls FullScreen mode
@interface BIZImageViewController : UIViewController
- (instancetype)initFromNib;
// * URL for download
@property (nonatomic, strong) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id <BIZImageViewControllerDelegate> delegate;
// * For subclasses
- (void)setup;
@property (nonatomic, strong) UIImage *image; // * Do not use synthesize as not use it directly
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
