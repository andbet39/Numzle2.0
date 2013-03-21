//
//  RootViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 23/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"


@interface RootViewController : UIPageViewController<UIPageViewControllerDataSource>


- (IBAction)goback:(id)sender;
@end
