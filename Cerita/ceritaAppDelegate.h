//
//  ceritaAppDelegate.h
//  Cerita
//
//  Created by Yazid Bustomi on 10/12/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ceritaAppDelegate : UIResponder <UIApplicationDelegate>
{
	UINavigationController *navigation;
	MMDrawerController *drawerController;
	UILabel *navLabel;
	UIView *main_center;
	NSString *last_string;
	NSString *last_category;
}
- (void)setCenter:(NSString *)center title:(NSString *)title cat:(NSString *)categorys;
@property (strong, nonatomic) UIWindow *window;
-(void)disableSwipe;
-(void)enableSwipe;
-(void)openRight;
@end
