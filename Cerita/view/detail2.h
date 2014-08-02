//
//  detail2.h
//  Cerita
//
//  Created by Yazid Bustomi on 10/27/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detail2 :UIViewController<UIWebViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
	UIWebView *localView;
	NSString *contents;
	NSString *title;
	NSString *author;
	NSString *time;
	NSString *url_content;
	UIActivityIndicatorView *spinner;
}

@end
