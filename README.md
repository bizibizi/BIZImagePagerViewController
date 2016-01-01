# BIZImagePagerViewController

*Wait for gif presentation, it's loading...*

![alt tag](https://github.com/bizibizi/BIZImagePagerViewController/blob/master/presentation.gif)


BIZImagePagerViewController is a handy image viewer, can be used with few images ,downloaded image will be fit to screen.


# Installation

### Manually
- Copy BIZImagePagerViewController folder to your project 


# Usage

- ```#import "BIZImagePagerViewController.h"``` 
- create, setup and present ```BIZImagePagerViewController``` 
```objective-c
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
```


# Contact

Igor Bizi
- https://www.linkedin.com/in/igorbizi
- igorbizi@mail.ru


# License
 
The MIT License (MIT)

Copyright (c) 2015-present Igor Bizi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
