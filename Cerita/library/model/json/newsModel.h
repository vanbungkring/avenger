//
//  newsModel.h
//  mstock
//
//  Created by Yazid Bustomi on 10/8/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsModel : NSObject

@property(nonatomic,strong) NSString *Title;
@property(nonatomic,strong) NSString *id_post;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *categories_title;
@property(nonatomic,strong) NSString *excerpt;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *thumbnail;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
