//
//  netra.h
//  Cerita
//
//  Created by Yazid Bustomi on 10/12/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface netra : NSObject
extern NSString* const ApiBaseUrl;
@property (nonatomic, retain) NSString *newsT;
@property (nonatomic, retain) NSString *newsC;
@property (nonatomic, retain) NSString *page;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableArray *array;

+(netra *) sharedInstance;
+(NSString *) getNewsTitle;
+(NSString *) getContent;
+(void) setNewsTitle:(NSString *)setNewsTitle;
+(void) setNewsContent:(NSString *)newsContent;
+(void) setList:(NSString *)list;
+(void) setPage:(NSString *)page;
+(void) setUrl:(NSString *)url;
+(NSString *) getPage;
+(NSString *) getUrl;
+(NSMutableArray *) getList;
@end
