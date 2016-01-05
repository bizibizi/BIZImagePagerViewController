//
//  ViewController.m
//  Example
//
//  Created by IgorBizi@mail.ru on 12/16/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "ViewController.h"
#import "BIZImagePagerViewController.h"


@interface ViewController ()
@end


@implementation ViewController


- (IBAction)showImages:(id)sender
{
    NSArray *dataSource = @[ [NSURL URLWithString:@"http://img.xcitefun.net/users/2011/05/248721,xcitefun-wide-wallpaper004.jpg"],
                             [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/3/38/Tampa_FL_Sulphur_Springs_Tower_tall_pano01.jpg"],
                             [NSURL URLWithString:@"http://www.planwallpaper.com/static/images/beautiful-sunset-images-196063.jpg"],
                             [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/3/38/Tampa_FL_Sulphur_Springs_Tower_tall_pano01.jpg"]];
    
    BIZImagePagerViewController *imagePagerViewController = [[BIZImagePagerViewController alloc]initFromNib];
    imagePagerViewController.dataSource = dataSource;
    [self presentViewController:imagePagerViewController animated:YES completion:nil];
}


@end
