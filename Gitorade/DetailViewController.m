//
//  DetailViewController.m
//  Gitorade
//
//  Created by Andrea Mazzini on 02/12/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

@end
