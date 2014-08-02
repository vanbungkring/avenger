//
//  detailViewController.m
//  Cerita
//
//  Created by Yazid Bustomi on 10/12/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.view.backgroundColor = [UIColor whiteColor];
		
		localView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64)];
		localView.delegate = self;
		
		[self.view addSubview:localView];
    }
    return self;
}

- (void)viewDidLoad
{
	
	self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [super viewDidLoad];
	UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
	UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    swipe2.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
	 [self.view addGestureRecognizer:swipe2];

	// Do any additional setup after loading the view.
}
- (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets;
	
    if (IS_OS_7_OR_LATER){
        if ([self isLeftButton]) {
            insets = UIEdgeInsetsMake(0, 9.0f, 0, 0);
        } else {
            insets = UIEdgeInsetsMake(0, 0, 0, 9.0f);
        }
    }else{
        insets = UIEdgeInsetsZero;
    }
	
    return insets;
}

- (BOOL)isLeftButton {
    return self.view.frame.origin.x < (self.view.frame.size.width / 2);
}
-(void)viewWillAppear:(BOOL)animated{
	

	[super viewWillAppear:animated];
	[beetlebox disableSwipe];
	[ProgressHUD show:@"Loading Content"];
	/*
	UIImage *backButtonImage = [UIImage imageNamed:@"back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 20, 20);
	
    [backButton addTarget:self
                   action:@selector(popViewController)
         forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	backBarButtonItem.imageInsets = UIEdgeInsetsMake(-20, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
	*/
	localView.dataDetectorTypes = UIDataDetectorTypeNone;
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(showActionSheet:)];
	self.navigationItem.rightBarButtonItem = anotherButton;
	_content = [NSString stringWithFormat:@"<html> \n"
						 "<head> \n"
						 "<meta name=\"viewport\" content=\"width=320, user-scalable=no initial-scale=1.0\" />"
						 "<style type=\"text/css\">"
						 "* {"
						 "-webkit-touch-callout: none;"
						 "-webkit-user-select: none;" /* Disable selection/copy in UIWebView */
						 "}"
						 "body {background:#fff;font-family:\"HelveticaNeue-Light\";}"
						 "p {color:#666; font-size:16px; text-align:left; margin-bottom:20px;}"
						 ".entry-title{ height:18px}"
						 ".wp-caption-text{ max-width:300px; font-size:10px;} "
						 ".wp-caption p{ font-size:10px;}"
						 "a{color: #690; text-decoration: none;}"
						 "h2{color:#666; font-size:16px;font:HelveticaNeue-Bold}"
						 "img{ width:300px; height:auto;}"
						 ".gig-share-button{ display:none}"
				         ".news-title{font:HelveticaNeue-CondensedBold; size:16px}"
						 "</style>"
						 
						 "</head> \n"
						 "<body\"><h2>%@</h2>%@</body> \n"
						 "</html>",[netra getNewsTitle],[netra getContent]];
	[localView reload];
	[localView loadHTMLString:_content baseURL:nil];
	[ProgressHUD showSuccess:@"Selesai"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
	
}
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
	
    return YES;
}
- (void)dismiss{
    [beetlebox enableSwipe];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)showActionSheet:(id)sender //Define method to show action sheet
{
    NSString *actionSheetTitle = @"Share to Social Media"; //Action Sheet Title
    NSString *other1 = @"Facebook Share";
    NSString *other2 = @"Twitter Share";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:Nil
											   destructiveButtonTitle:cancelTitle
													otherButtonTitles:other1, other2, nil];
    
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
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)twitterShare{
	if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@ via Cerita Iphone App",[netra getNewsTitle]]];
		[controller addURL:[NSURL URLWithString:[netra getUrl]]];
        
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
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@ via Cerita Iphone App",[netra getNewsTitle]]];
        [controller addURL:[NSURL URLWithString:[netra getUrl]]];
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
	
}
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	[beetlebox enableSwipe];
	_content = @"";
}
-(void)viewDidDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	[beetlebox enableSwipe];
	_content = @"";
}
@end
