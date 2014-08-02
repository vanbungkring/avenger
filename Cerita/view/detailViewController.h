//
//  detailViewController.h
//  Cerita
//
//  Created by Yazid Bustomi on 10/12/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>{
	UIWebView *localView;
}
@property (nonatomic,copy) NSString *news_t;
@property (nonatomic,copy) NSString *content;


@end
