//
//  cerita_CategoryViewController.m
//  Cerita
//
//  Created by Yazid Bustomi on 10/27/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import "cerita_CategoryViewController.h"
#import "detailViewController.h"
@interface cerita_CategoryViewController ()

@end

@implementation cerita_CategoryViewController
BOOL reloads = 0;
BOOL firsts = 1;
NSInteger last_index;
CGPoint lastOffset;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		details = [[detailViewController alloc]init];
		detail = [[detail2 alloc]init];
		news_array = [[NSMutableArray alloc]init];
		self.view.backgroundColor = [UIColor lightGrayColor];
		cerita = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-65)];
		cerita.separatorInset = UIEdgeInsetsZero;
		cerita.backgroundColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
		cerita.delegate = self;
		cerita.separatorColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
		cerita.dataSource = self;
		//cerita.hidden = YES;
		
		refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
		[cerita addSubview:refreshControl];
		//animate uitableviewcell
		
		
		
		CATransform3D transform = CATransform3DIdentity;
		transform.m34 = -1.0/200.0;
		transform = CATransform3DRotate(transform, 45.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
		_initialTransformation = transform;
		_shownIndexes = [NSMutableSet set];
		
		self.transitionManager = [[TransitionManager alloc]init];
		
		[self.view addSubview:cerita];
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.center = CGPointMake(160, 240);
		spinner.hidesWhenStopped = YES;
		[spinner startAnimating];
		[self.view addSubview:spinner];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
	[self fetchCerita];
	self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
	UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
	[share setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
	UIEdgeInsets buttonEdges = UIEdgeInsetsMake(0, -10, 0, -10);
	[share setImageEdgeInsets:buttonEdges];
	[share addTarget:self action:@selector(openLeft) forControlEvents:UIControlEventTouchUpInside];
	[share setFrame:CGRectMake(0, 0, 40, 40)];
	[[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:share]];
	
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	
	firsts = YES;
	cerita.tableFooterView = [[UIView alloc] init];
	
}

-(void)openLeft{
	[beetlebox openRight];
}

-(void)fetchCerita{
	self.view.userInteractionEnabled = NO;
	NSString *url=[NSString stringWithFormat:@"%@api/?json=get_category_posts&id=%@&page=%@",ApiBaseUrl,[netra getContent],[netra getPage]];
    NSLog(@"url->%@",url);
	NSString *escaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *URL = [NSURL URLWithString:escaped];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(reloads==1){
			[news_array removeAllObjects];
		}
		total_page  =[[responseObject objectForKey:@"pages"]integerValue];
		if([[responseObject objectForKey:@"posts"] count]!=0){
			
			for(id news_objects in [responseObject objectForKey:@"posts"]){
				newsModel *object=[[newsModel alloc] initWithDictionary:news_objects];
				if(![news_array containsObject:object]){
					[news_array addObject:object];
				}
				
				
			}
			self.view.userInteractionEnabled = YES;
			[ProgressHUD dismiss];
			[self reloadData];
			[spinner stopAnimating];
			[cerita setUserInteractionEnabled:YES];
			if (reloads==1) {
				reloads=0;
				[refreshControl endRefreshing];
			}
		}
		else{
			[cerita setUserInteractionEnabled:YES];
			[self loadingCell].hidden =YES;
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (reloads==1) {
			reloads=0;
			[netra setPage:@"1"];
			[news_array removeAllObjects];
		}
		[cerita setUserInteractionEnabled:YES];
		[ProgressHUD showError:@"Error"];
	}];
	
	[[NSOperationQueue mainQueue] addOperation:op];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	cell.backgroundColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
	if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
		
    }
	
}
- (void)reloadData
{
    [cerita reloadData];
    
}
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(current_page<total_page){
		
		return [news_array count]+1;
	}
	
	return [news_array count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	newsModel  *object_draw = [news_array objectAtIndex:indexPath.row];
	[netra setUrl:object_draw.url];
	[netra setNewsTitle:object_draw.id_post];
	[netra setNewsContent:object_draw.content];
	[self.navigationController pushViewController:detail animated:YES];
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *) loadingCell{
	
	UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.center=cell.center;
	[cell addSubview:activityIndicator];
	[activityIndicator startAnimating];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[activityIndicator startAnimating];
	return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row<news_array.count){
		return [self beritaCellRow:indexPath];
	}
	else{
		return [self loadingCell];
	}
	
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==news_array.count){
        return 44;
    }
    else{
        return 110;
    }
}
-(UITableViewCell *)beritaCellRow:(NSIndexPath *)indexPath{
    newsModel  *object_draw = [news_array objectAtIndex:indexPath.row];
    static NSString *cells = @"CeritaCell";
    ceritaCell *cell = [[ceritaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cells];
    if(cell ==Nil){
        cell = [[ceritaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cells];
    }
    
    cell.title.text = [[object_draw.Title lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                   withString:[[[object_draw.Title lowercaseString] substringToIndex:1] capitalizedString]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //green [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]
    if([object_draw.categories_title isEqualToString:@"Puisi"]){
        cell.tag_label.layer.borderColor = [UIColor colorWithRed:0.408 green:0.686 blue:0.012 alpha:1].CGColor;
        cell.tag_label.textColor = [UIColor colorWithRed:0.408 green:0.686 blue:0.012 alpha:1];
    }
    else if([object_draw.categories_title isEqualToString:@"Cerpen"]){
        cell.tag_label.layer.borderColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1].CGColor;
        cell.tag_label.textColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
    }
    else if([object_draw.categories_title isEqualToString:@"Sajak"]){
        cell.tag_label.layer.borderColor = [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:1].CGColor;
        cell.tag_label.textColor = [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:1];
    }
    else{
        cell.tag_label.layer.borderColor = [UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1].CGColor;
        cell.tag_label.textColor = [UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    NSDate *date = [formatter dateFromString:object_draw.date];
    [formatter setDateFormat:@"dd,MMMM yyyy"];
    
    cell.relative_time.text=[formatter stringFromDate:date];
    
    cell.tag_label.text = [NSString stringWithFormat:@" %@ ",object_draw.categories_title];
    [cell.tag_label sizeToFit];
    cell.excerpt.text = object_draw.excerpt;
    [cell.excerpt sizeToFit];
    
    cell.share.tag = indexPath.row;
    
    CGSize textSize = [[cell.tag_label text] sizeWithAttributes:@{NSFontAttributeName:[cell.tag_label font]}];
    
    CGFloat strikeWidth = textSize.width;
    
    cell.relative_time.frame =CGRectMake(strikeWidth+15, 35, 50, 15);
    [cell.relative_time sizeToFit];
    [cell.share addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.thumbnail setImageWithURL:[NSURL URLWithString:object_draw.thumbnail] placeholderImage:[UIImage imageNamed:@"avatar"]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	firsts=1;
}
///pagination here
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if  (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
		[netra setPage:[NSString stringWithFormat:@"%d",[[netra getPage]intValue] +1]];
		[self fetchCerita];
		return;
	}
	
}
- (void)scrollViewWillBeginScroll :(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y < lastOffset.y) {
		[[[self navigationController] navigationBar] setHidden:YES];
	} else{
		// unhide
	}
}

////refresh table;
- (void)statTodoSomething {
	self.view.userInteractionEnabled = NO;
	reloads =1;
	[netra setPage:@"1"];
	[self fetchCerita];
	workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];
}
- (void)refreshTriggered {
    [self statTodoSomething];
}
- (void)onAllworkDoneTimer {
	
	[self reloadData];
}

- (void)showActionSheet:(id)sender //Define method to show action sheet
{
	last_index = [sender tag];
	NSString *actionSheetTitle = @"How would you like to share this article?"; //Action Sheet Title
    NSString *other1 = @"Facebook Share";
    NSString *other2 = @"Twitter Share";
	NSString *other3 = @"Email";
	NSString *other4 = @"Copy to Clipboard";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:cancelTitle
											   destructiveButtonTitle:Nil
													otherButtonTitles:other1, other2,other3,other4, nil];
    
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Facebook Share"]) {
        [self facebookShare];
    }
    if ([buttonTitle isEqualToString:@"Twitter Share"]) {
        [self twitterShare];
    }
	if ([buttonTitle isEqualToString:@"Copy to Clipboard"]) {
        [self copytoClipboard];
    }
	if ([buttonTitle isEqualToString:@"Email"]) {
        [self email];
    }
	
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)email{
	//NSString *emailTitle = @"TakitaApp";
    // Email Content
	newsModel  *object_draw = [news_array objectAtIndex:last_index];
    NSString *messageBody = object_draw.Title;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
	
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
	
    mc.mailComposeDelegate = self;
	[[mc navigationBar] setTintColor:[UIColor blackColor]];
	mc.title = object_draw.Title;
	NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue" size:14], NSFontAttributeName, nil]];
    [mc setSubject:messageBody];
    [mc setMessageBody:[NSString stringWithFormat:@"<b>%@</b></br><p><a href=%@>%@</a></p>",object_draw.Title,object_draw.url,object_draw.url] isHTML:YES];
    [mc setToRecipients:toRecipents];
	
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
	
}

-(void)twitterShare{
	
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
		newsModel  *object_draw = [news_array objectAtIndex:last_index];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@ via Cerita Iphone App",object_draw.Title]];
		[controller addURL:[NSURL URLWithString:object_draw.url]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
	else{
		
		UIAlertView *myalertView = [[UIAlertView alloc]initWithTitle:@"Twitter"
															 message:@"There's no Twitter Account, please setting it first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[myalertView show];
	}
}
-(void)facebookShare{
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        newsModel  *object_draw = [news_array objectAtIndex:last_index];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
		[controller setInitialText:[NSString stringWithFormat:@"%@ via Cerita Iphone App",object_draw.Title]];
		[controller addURL:[NSURL URLWithString:object_draw.url]];
        [self presentViewController:controller animated:YES completion:Nil];
		[controller setCompletionHandler:^(SLComposeViewControllerResult result){
			
		}];
        
    }
	else{
		
		UIAlertView *myalertView = [[UIAlertView alloc]initWithTitle:@"Facebook"
															 message:@"There's no Facebook Account, please setting it first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[myalertView show];
	}
	
}

-(void)copytoClipboard{
	newsModel  *object_draw = [news_array objectAtIndex:last_index];
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:object_draw.url];
}
@end
