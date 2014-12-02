//
//  AppDelegate.m
//  Gitorade
//
//  Created by Andrea Mazzini on 02/12/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.420 green:0.588 blue:0.780 alpha:1.000]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Futura" size:18],
                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    return YES;
}


@end
