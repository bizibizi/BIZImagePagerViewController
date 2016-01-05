//
//  BIZImagePagerViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/9/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "BIZImagePagerViewController.h"
#import "BIZImageViewController.h"


#define k_DURATION_hideViewWithDismissVC 1
#define k_DURATION_fullScreen 0.3
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface BIZImagePagerViewController () <UIScrollViewDelegate, BIZImageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViewControllers;
@property (nonatomic) NSUInteger indexOfImagePage;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic) BOOL activeFullScreenMode;
@end


@implementation BIZImagePagerViewController


#pragma mark - Getters/Setters


- (NSMutableArray *)imageViewControllers
{
    if (!_imageViewControllers) {
        _imageViewControllers = [[NSMutableArray alloc]init];
    }
    return _imageViewControllers;
}

// * Get close button from first VC, add it to the top of scrollView, handle its events
- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = ((BIZImageViewController *)self.imageViewControllers[self.indexOfImagePage]).closeButton;
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
    }
    return _closeButton;
}


#pragma mark - LifeCycle


- (instancetype)initFromNib
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    [self createImagePages];
    
    self.scrollView.delegate = self;
    self.indexOfImagePage = 0;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.closeButton.layer.hidden = NO;
}
#warning add 'start with index'

// * Creates views
- (void)createImagePages
{
    for (NSUInteger i = 0; i < self.dataSource.count; i++)
    {
        NSURL *url = self.dataSource[i];
        
        BIZImageViewController *imageViewController = [[BIZImageViewController alloc] initFromNib];
        imageViewController.delegate = self;
        imageViewController.imageURL = url;
        [self.scrollView insertSubview:imageViewController.view atIndex:self.imageViewControllers.count];
        [self.imageViewControllers addObject:imageViewController];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateImagePages];
    // * Update subviews
    [self.view layoutIfNeeded];
}

// * Update frames
- (void)updateImagePages
{
    CGFloat w = ScreenWidth;
    CGFloat h = ScreenHeight;
    for (NSUInteger i = 0; i < self.imageViewControllers.count; i++)
    {
        UIView *view = ((BIZImageViewController *)self.imageViewControllers[i]).view;
        view.frame = CGRectMake(i * w, 0, w, h);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.dataSource.count * w, h);
}


#pragma mark - UIScrollViewDelegate


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // * Zooming in imageView of ImageViewController
    return ((BIZImageViewController *)self.imageViewControllers[self.indexOfImagePage]).imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // * Update index of ImagePage
    if (scrollView.contentOffset.x == 0) {
        self.indexOfImagePage = 0;
    } else {
        self.indexOfImagePage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}


#pragma mark - Events


- (void)closeButtonAction:(UIButton *)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    // * Hide view with animation
    [UIView transitionWithView:self.scrollView
                      duration:k_DURATION_hideViewWithDismissVC
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.scrollView.alpha = 0;
                    } completion:nil];
}


#pragma mark - ImageViewControllerDelegate


- (void)singleTapGestureRecognizerEvent:(UITapGestureRecognizer *)gesture
{
    [self changeFullScreenMode];
}

//! Switch background colors, close button appearance
- (void)changeFullScreenMode
{
    self.activeFullScreenMode = !self.activeFullScreenMode;
    
    self.closeButton.layer.hidden = self.activeFullScreenMode;
    UIColor *destinationColor = self.activeFullScreenMode? [UIColor blackColor] : [UIColor lightGrayColor];
    [UIView animateWithDuration:k_DURATION_fullScreen
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         for (BIZImageViewController *imageViewController in self.imageViewControllers)
                         {
                             imageViewController.imageView.backgroundColor = destinationColor;
                             imageViewController.view.backgroundColor = destinationColor;
                         }
                         self.view.backgroundColor = destinationColor;
                     } completion:nil];
}


@end
