//
//  detail2.m
//  Cerita
//
//  Created by Yazid Bustomi on 10/27/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import "detail2.h"

@interface detail2 ()

@end
NSString *link_;
@implementation detail2
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.view.backgroundColor = [UIColor whiteColor];
		localView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64)];
		localView.hidden =YES;
		localView.delegate = self;
		
		[self.view addSubview:localView];
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinner.center = CGPointMake(160, 240);
		spinner.hidesWhenStopped = YES;

		[self.view addSubview:spinner];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
		self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
	
	UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
	[share setImage:[UIImage imageNamed:@"share_"] forState:UIControlStateNormal];
	UIEdgeInsets buttonEdges = UIEdgeInsetsMake(0, 5, 0, -10);
	[share setImageEdgeInsets:buttonEdges];
	[share addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
	[share setFrame:CGRectMake(0, 0, 40, 40)];
	[[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:share]];

	// Do any additional setup after loading the view.
}

-(void)fetchCerita{

	
	NSString *url=[NSString stringWithFormat:@"%@?json=get_post&id=%@",ApiBaseUrl,[netra getNewsTitle]];
	NSLog(@"url->%@",url);
	NSString *escaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *URL = [NSURL URLWithString:escaped];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response->%@",responseObject);
		
		title = [[[responseObject objectForKey:@"post"]objectForKey:@"title"]stripHtml];
		contents = [[responseObject objectForKey:@"post"]objectForKey:@"content"];
		author = [[[responseObject objectForKey:@"post"]objectForKey:@"author"]objectForKey:@"name"];
		url_content = [[responseObject objectForKey:@"post"]objectForKey:@"url"];
		
		NSArray* foo = [[[responseObject objectForKey:@"post"]objectForKey:@"date"] componentsSeparatedByString: @" "];
		NSString* day = [foo objectAtIndex: 0];
		
		// Convert string to date object
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy-MM-dd"];
		NSDate *date = [dateFormat dateFromString:[foo objectAtIndex: 0]];
		
		// Convert date object to desired output format
		[dateFormat setDateFormat:@"MMMM d, YYYY"];
		day = [dateFormat stringFromDate:date];
		time  = day;
		[self draw];
		NSLog(@"fetchCerita");
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[[NSOperationQueue mainQueue] addOperation:op];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];

	[spinner stopAnimating];
	localView.hidden =NO;
	
	NSLog(@"Finish");
	
}
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
		UIAlertView *alert = [[UIAlertView alloc] init];
		[alert setTitle:@"Open Safari?"];
		//[alert setMessage:@"Are you sure to open this url?"];
		[alert setDelegate:self];
		[alert addButtonWithTitle:@"Yes"];
		[alert addButtonWithTitle:@"No"];
		[alert show];
		link_ = [NSString stringWithFormat:@"%@",[inRequest URL]];
		NSLog(@"shouldStartLoadWithRequest");
        return NO;
    }
	
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link_]];
		// Yes, do something
	}
	else if (buttonIndex == 1)
	{
		// No
	}
}
-(void)viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];
	[spinner startAnimating];
	title=@"";
	author=@"";
	time=@"";
	contents=@"";
	[self fetchCerita];
	[beetlebox disableSwipe];


}
-(void)draw{
	
	NSString *content =[NSString stringWithFormat:@"<html> \n"
						"<head> \n"
						"<meta name=\"viewport\" content=\"width=320, user-scalable=no initial-scale=1.0\" />"
						"<style type=\"text/css\">"
						"html{background:#ffffff}"
						"* {"
						"-webkit-touch-callout: none;"
						"-webkit-user-select: none;" /* Disable selection/copy in UIWebView */
						"}"
						"embed{ width :300px}"
						"#player{ width: 300px;}"
						"body {background:#fff;font-family:Helvetica Neue;}"
						"p {color:#333; font-size:1.1em; text-align:left; margin-bottom:30px; line-height:1.45; letter-spacing:normal;}"
						".wp-caption-text{ max-width:300px; font-size:10px;} "
						".wp-caption p{ font-size:10px;}"
						"iframe{ width:300px;}"
						"a{color: #44add1; text-decoration: none;}"
						"img{ width:320px; height:auto; margin-left:-8px;}"
						".gig-share-button{ display:none}"
						"h1 {color:#333333; font-size:19px;}"
						".author{ background:url('author@2x.png') no-repeat 0 -3px; background-size:16px 16px;background-position:left; height:20px; padding-left:30px;}"
						".time{ margin-top:3px; margin-buttom:3px; background:url('time@2x.png') no-repeat 0 -3px; background-size:16px 16px;background-position:left; height:20px; padding-left:30px;}"
						"</style>"
						"</head> \n"
						"<body\"><h1>%@</h1><div class=\"author\">%@</div><div class=\"time\">%@</div>%@</body> \n"
						"</html>",title,author,time,contents];

	[localView loadHTMLString:content baseURL:[[NSBundle mainBundle] bundleURL]];
	NSLog(@"draw");

}
- (void)showActionSheet:(id)sender //Define method to show action sheet
{
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
-(void)twitterShare{
	NSLog(@"title-->%@",title);
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [controller setInitialText:title];
		[controller addURL:[NSURL URLWithString:url_content]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
	else{
		
		UIAlertView *myalertView = [[UIAlertView alloc]initWithTitle:@"Twitter"
															 message:@"There's no Twitter Account, please setting it first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[myalertView show];
	}
}
-(void)facebookShare{
		NSLog(@"title-->%@",title);
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
		[controller setInitialText:[NSString stringWithFormat:@"%@ via Cerita for iPhone",title]];
		[controller addURL:[NSURL URLWithString:url_content]];
        
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
-(void)email{
	//NSString *emailTitle = @"TakitaApp";
    // Email Content
    NSString *messageBody = title;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
   
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];

    mc.mailComposeDelegate = self;
		 [[mc navigationBar] setTintColor:[UIColor blackColor]];
	mc.title = title;
	NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue" size:14], NSFontAttributeName, nil]];
    [mc setSubject:messageBody];
    [mc setMessageBody:[NSString stringWithFormat:@"<b>%@</b></br><p><a href=%@>%@</a></p></br></br> via Cerita for iPhone",title,url_content,url_content] isHTML:YES];
    [mc setToRecipients:toRecipents];
	
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
	
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
-(void)copytoClipboard{
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:url_content];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[beetlebox enableSwipe];
	[spinner stopAnimating];
	[localView stopLoading];
	localView.hidden =YES;
}


@end
