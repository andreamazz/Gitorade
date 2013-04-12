//
//  CTViewController.m
//  Gitorade
//
//  Created by Andrea on 11/04/13.
//  Copyright (c) 2013 Centec. All rights reserved.
//

#import "CTViewController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "CTUserCell.h"
#import "CTDetailViewController.h"


@interface CTViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* data;

@property (strong, nonatomic) NSDictionary* points;


@end

@implementation CTViewController

- (NSDictionary*)points
{
	if (_points == nil) {
		_points = @{
					@"CommitCommentEvent": @(2),
					@"CreateEvent" : @(1),
					@"DeleteEvent" : @(1),
					@"DownloadEvent" : @(1),
					@"FollowEvent" : @(1),
					@"ForkEvent" : @(1),
					@"ForkApplyEvent" : @(1),
					@"GistEvent" : @(1),
					@"GollumEvent" : @(1),
					@"IssueCommentEvent" : @(2),
					@"IssuesEvent" : @(3),
					@"MemberEvent" : @(1),
					@"PublicEvent" : @(1),
					@"PullRequestEvent" : @(4),
					@"PullRequestReviewCommentEvent" : @(2),
					@"PushEvent" : @(3),
					@"TeamAddEvent" : @(1),
					@"WatchEvent" : @(1)
			  };
	}
	return _points;
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];

	NSString* stringURL = [NSString stringWithFormat:@"https://github.com/%@.json", searchBar.text];
	
	NSURL *url = [NSURL URLWithString:stringURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *operation =
	[AFJSONRequestOperation JSONRequestOperationWithRequest:request
													success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
	{
		// Temporanely store users' data
		NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
		// Get generic user data
		if ([JSON count] > 0) {
			item[@"username"] = JSON[0][@"actor"];
			item[@"avatar"] = JSON[0][@"actor_attributes"][@"gravatar_id"];
		}
		
		int count = 0;
		
		NSMutableArray* types = [[NSMutableArray alloc] init];
		for (NSDictionary* dict in JSON) {
			[types addObject:dict[@"type"]];
			// Add up all the points given an event
			count += [self.points[dict[@"type"]] intValue];
		}
		
		item[@"points"] = @(count);
		item[@"types"] = types;
		
		[self.data addObject:item];
		[self.tableView reloadData];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		// TODO: messaggio errore
	}];
	[operation start];
}

- (NSMutableArray*)data
{
	if (_data == nil) {
		_data = [[NSMutableArray alloc] init];
	}
	return _data;
}

#pragma mark - Table view delegation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Returns the number of users
	return [self.data count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Returns the cell data
	CTUserCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CTUserCell"];
	
	if (cell == nil) {
		cell = [[CTUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CTUserCell"];
	}
		
	cell.labelUser.text = self.data[indexPath.row][@"username"];
	
	cell.labelPoints.text = [NSString stringWithFormat:@"%d", [self.data[indexPath.row][@"points"] intValue]];
	
	NSString* avatarURL = [NSString stringWithFormat:@"https://secure.gravatar.com/avatar/%@", self.data[indexPath.row][@"avatar"]];
	NSURL * url = [NSURL URLWithString:avatarURL];
	
	// Load the avatar asynchronously
	[cell.imageAvatar setImageWithURL:url];
	
	
	return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath* path = [self.tableView indexPathForSelectedRow];
	[(CTDetailViewController*)segue.destinationViewController setData:self.data[path.row]];
}








@end
