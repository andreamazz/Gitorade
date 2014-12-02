//
//  ViewController.m
//  Gitorade
//
//  Created by Andrea Mazzini on 02/12/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "ViewController.h"
#import <STHTTPRequest.h>
#import <FAKFontAwesome.h>
#import "DetailViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textField.layer setBorderWidth:2];
    [self.textField.layer setBorderColor:[UIColor colorWithRed:0.420 green:0.588 blue:0.780 alpha:1.000].CGColor];
    
    [self.tableView setAlpha:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString *action = [self.data[indexPath.row][@"type"] stringByReplacingOccurrencesOfString:@"Event" withString:@""];
    NSString *repoName = self.data[indexPath.row][@"repository"][@"name"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@", action, repoName];
    
    FAKIcon *icon = [FAKFontAwesome githubAltIconWithSize:32];
    [icon setAttributes:@{ NSForegroundColorAttributeName: [self colorForEvent:action] }];
    
    cell.imageView.image = [icon imageWithSize:(CGSize){ 32, 32 } ];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.activityIndicator startAnimating];
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"http://github.com/%@.json", textField.text]];
    r.completionDataBlock = ^(NSDictionary *headers, NSData *body) {
        self.data = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:nil];
        [self.tableView setAlpha:1];
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    };
    
    r.errorBlock = ^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Something went wrong!" delegate:nil cancelButtonTitle:@"Ok.. I gues" otherButtonTitles:nil] show];
        [self.activityIndicator stopAnimating];
        NSLog(@"Something's wrong!!!");
    };
    
    [r startAsynchronous];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger index = [self.tableView indexPathForCell:sender].row;
    [(DetailViewController *)segue.destinationViewController setUrlString:self.data[index][@"url"]];
    [segue.destinationViewController setTitle:self.data[index][@"repository"][@"name"]];
}

- (UIColor *)colorForEvent:(NSString *)eventType
{
    if ([eventType rangeOfString:@"Watch"].location != NSNotFound) {
        return UIColorFromRGB(0x417505);
    }
    if ([eventType rangeOfString:@"Push"].location != NSNotFound) {
        return UIColorFromRGB(0x3367A3);
    }
    if ([eventType rangeOfString:@"Pull"].location != NSNotFound) {
        return UIColorFromRGB(0xF5A623);
    }
    if ([eventType rangeOfString:@"Issue"].location != NSNotFound) {
        return UIColorFromRGB(0xE06431);
    }
    if ([eventType rangeOfString:@"Fork"].location != NSNotFound) {
        return UIColorFromRGB(0x7ED321);
    }
    if ([eventType rangeOfString:@"Create"].location != NSNotFound) {
        return UIColorFromRGB(0xD0021B);
    }
    return UIColorFromRGB(0x111111);
}

@end
