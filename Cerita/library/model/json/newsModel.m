//
//  newsModel.m
//  mstock
//
//  Created by Yazid Bustomi on 10/8/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import "newsModel.h"

@implementation newsModel
-(id)initWithDictionary:(NSDictionary *)dictionary{
	
	self=[super init];
	if(self){
		self.id_post=[dictionary objectForKey:@"id"];
		self.Title=[[dictionary objectForKey:@"title"]stripHtml];
		self.date=[dictionary objectForKey:@"date"];
        self.categories_title=[[[dictionary objectForKey:@"categories"]objectAtIndex:0] objectForKey:@"title"];
		//self.excerpt=[[dictionary objectForKey:@"author"]objectForKey:@"name"];
		self.excerpt=[[dictionary objectForKey:@"excerpt"]stripHtml];
		self.content=[dictionary objectForKey:@"content"];
		self.url =[dictionary objectForKey:@"url"];
		if([[dictionary objectForKey:@"attachments"]count]!=0){
		//	NSLog(@"-->%@",[[[dictionary objectForKey:@"attachments"]objectAtIndex:0]objectForKey:@"url"]);
			self.thumbnail =[[[dictionary objectForKey:@"attachments"]objectAtIndex:0]objectForKey:@"url"];
		}
		//self.thumbnail=[[[dictionary objectForKey:@"attachments"]objectAtIndex:0]objectForKey:@"url"];
	}
	return self;
}

@end
