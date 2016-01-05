//
//  AttachmentViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/3/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "BIZImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"


#define k_DELAY_hideStatusBar 0.5
#define k_DURATION_imageAppearence 0.7


@interface BIZImageViewController () <UIScrollViewDelegate>
// * Interface
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
// * ImageView Constaints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_constraintBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_constraintLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_constraintTrailing;
// * Check changes of zoom
@property (nonatomic) CGFloat lastZoomScale;
@end


@implementation BIZImageViewController


#pragma mark - LifeCycle


- (instancetype)initFromNib
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self downloadImageWithURL:imageURL];
}

- (void)downloadImageWithURL:(NSURL *)url
{
    if (url)
    {
        [[SDWebImageManager sharedManager]
         downloadImageWithURL:url
         options:SDWebImageHighPriority
         progress:0
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             
             if (finished) {
                 if (!error && image && [imageURL isEqual:url]) {
                     self.image = image;
                 } else {
                     NSLog(@"Error: setImageURL");
                 }
             }
         }];
    }
}

- (void)setImage:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.imageView.image = image;
    self.imageView.alpha = 0;
    [self updateZoom];
    
    // * Assign image with animation
    [UIView transitionWithView:self.imageView
                      duration:k_DURATION_imageAppearence
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveLinear
                    animations: ^{
                        self.imageView.alpha = 1;
                    } completion:^(BOOL finished) {
                        
                        if ([self.delegate respondsToSelector:@selector(imageDidLoaded)]) {
                            [self.delegate imageDidLoaded];
                        }
                    }];
}

// * Do not use image directly
- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setup
{
    self.activityIndicator.color = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 20;
    
    if (![UIApplication sharedApplication].statusBarHidden) {
        [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:k_DELAY_hideStatusBar];
    }
    
    // * Gestures
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    [self.view addSubview:self.closeButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self downloadImageWithURL:self.imageURL];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // * Update for ios7
    [self.view layoutIfNeeded];
    
    [self updateZoom];
    [self updateImageViewConstaints];
}


#pragma mark - UIScrollViewDelegate


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateImageViewConstaints];
}


#pragma mark - Events


// * Zoom to show as much image as possible unless image is smaller than screen
- (void)updateZoom
{
    CGFloat minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                          self.view.bounds.size.height / self.imageView.image.size.height);
    
    if (minZoom > 1) {
        minZoom = 1;
    }
    
    self.scrollView.minimumZoomScale = minZoom;
    
    // * Force scrollViewDidZoom fire if zoom did not change
    if (minZoom == self.lastZoomScale) {
        minZoom += 0.000001;
    }
    
    self.lastZoomScale = self.scrollView.zoomScale = minZoom;
}

// * Call after zoom scale is changed
- (void)updateImageViewConstaints
{
    CGFloat imageViewWidth = self.imageView.image.size.width;
    CGFloat imageViewHeight = self.imageView.image.size.height;
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    
    // * Center image if it is smaller than screen
    CGFloat hPadding = (viewWidth - self.scrollView.zoomScale * imageViewWidth) / 2;
    if (hPadding < 0) {
        hPadding = 0;
    }
    CGFloat vPadding = (viewHeight - self.scrollView.zoomScale * imageViewHeight) / 2;
    if (vPadding < 0) {
        vPadding = 0;
    }
    
    // * Stick ImageView to scrollView bounds
    self.imageView_constraintBottom.constant = vPadding;
    self.imageView_constraintTop.constant = vPadding;
    self.imageView_constraintLeading.constant = hPadding;
    self.imageView_constraintTrailing.constant = hPadding;
    
    // * Makes zoom out animation smooth and starting from the right point not from (0, 0)
    [self.view layoutIfNeeded];
}

- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer *)gesture
{
    // * Zoom in / Zoom out to tap point
    CGFloat newScale = self.scrollView.zoomScale * 4.0;
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    center = [self.imageView convertPoint:center fromView:self.view];

    CGFloat w = self.imageView.frame.size.width / scale;
    CGFloat h = self.imageView.frame.size.height / scale;
    CGFloat x = center.x - w /2;
    CGFloat y = center.y - h /2;
    
    return (CGRect){x,y,w,h};
}

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(singleTapGestureRecognizerEvent:)]) {
        [self.delegate singleTapGestureRecognizerEvent:gesture];
    }
}

- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (IBAction)closeButtonAction:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
