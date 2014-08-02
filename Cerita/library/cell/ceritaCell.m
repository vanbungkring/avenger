//
//  ceritaCell.m
//  Cerita
//
//  Created by Yazid Bustomi on 10/12/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import "ceritaCell.h"

@implementation ceritaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		self.container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
		self.container.backgroundColor = [UIColor whiteColor];
		self.container.layer.borderColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1].CGColor;
        // Initialization code
		self.title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 20)];
		self.title.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
		self.title.numberOfLines = 1;
		self.title.lineBreakMode = NSLineBreakByTruncatingTail;
		self.title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        
        // Initialization code
        self.tag_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 50, 15)];
        self.tag_label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        self.tag_label.numberOfLines = 1;
        self.tag_label.layer.borderWidth =1;
        self.tag_label.layer.masksToBounds = YES;
        self.tag_label.layer.borderColor = [UIColor clearColor].CGColor;
        self.tag_label.layer.cornerRadius = 3;
        self.tag_label.textColor = [UIColor whiteColor];
        self.tag_label.lineBreakMode = NSLineBreakByTruncatingTail;
        self.tag_label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
        self.tag_label.textAlignment = NSTextAlignmentJustified;
        
        // Initialization code
        self.relative_time = [[UILabel alloc]init];
        self.relative_time.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        self.relative_time.numberOfLines = 1;
        self.relative_time.lineBreakMode = NSLineBreakByTruncatingTail;
        self.relative_time.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        self.relative_time.textAlignment = NSTextAlignmentJustified;

		self.excerpt = [[UILabel alloc]initWithFrame:CGRectMake(10, 57, 300, 20)];
		self.excerpt.textColor = [UIColor darkGrayColor];
		self.excerpt.numberOfLines = 3;
		self.excerpt.lineBreakMode = NSLineBreakByWordWrapping;
		self.excerpt.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
		
		self.thumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 240)];
		self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
		self.thumbnail.layer.borderColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1].CGColor;

		self.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 210, 40, 40)];
		self.avatar.backgroundColor = [UIColor lightGrayColor];
		self.avatar.layer.cornerRadius = 40/2;
		self.avatar.layer.masksToBounds = YES;
		
		self.share = [UIButton buttonWithType:UIButtonTypeCustom];
		self.share.frame = CGRectMake(self.container.frame.size.width - 39, 255, 40, 40);
		[self.share setBackgroundImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
        
        self.thumbnail.clipsToBounds = YES;
//		//[self.container addSubview:self.thumbnail];
        [self.contentView addSubview:self.title];
//		[self.container addSubview:self.share];
////		/[self.container addSubview:self.avatar];
        [self.contentView addSubview:self.excerpt];
        [self.contentView addSubview:self.tag_label];
         [self.contentView addSubview:self.relative_time];
        
		//[self.contentView addSubview:self.container];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
