//
//  CTDetailViewController.m
//  Gitorade
//
//  Created by Andrea on 11/04/13.
//  Copyright (c) 2013 Centec. All rights reserved.
//

#import "CTDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface CTDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CTDetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
		
	NSString* avatarURL = [NSString stringWithFormat:@"https://secure.gravatar.com/avatar/%@?s=%d", self.data[@"avatar"], 400];
	NSURL * url = [NSURL URLWithString:avatarURL];
	[self.imageAvatar setImageWithURL:url];
	
	[self setTitle:self.data[@"username"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.data[@"types"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"typeCell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
	}
	
	cell.textLabel.text = self.data[@"types"][indexPath.row];
		
	return cell;
}




@end
