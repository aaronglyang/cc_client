//
//  ContentViewController.h
//  cocoachin3
//
//  Created by 国良 on 12-5-22.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//
//#import <Cocoa/Cocoa.h>
#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
<NSXMLParserDelegate> {
	UINavigationBar *naviBar;
 
	UILabel * topicTitle;
	NSString * tid;
	NSString * myTitle;
	int flag;
	UITableView *replyTable;
	NSMutableArray* parserObjects;
	UILabel *content;
	NSString * testFlag;
	int page ;
	UIButton * moreButton;
	NSMutableData* tmpMutableData;
	NSMutableDictionary* twitterDic;
	NSString* currentText;
	NSString* currentElementName;
}

@property(nonatomic, retain) NSMutableDictionary* twitterDic;
@property (nonatomic, retain) UINavigationBar *naviBar;
@property (nonatomic,retain) IBOutlet UILabel	*content;
@property (nonatomic,retain) IBOutlet UILabel *topicTitle;
 @property(nonatomic,retain) IBOutlet UITableView *replyTable;
@property(nonatomic,retain) NSString *tid;
@property(nonatomic,retain) NSString *myTitle;
@property(nonatomic,retain) NSString *testFlag;
@property (nonatomic, retain) IBOutlet UIButton * moreButton;
@property(nonatomic, retain) NSString* currentElementName;
@property(nonatomic, retain) NSString* currentText;
@property(nonatomic, retain) NSMutableArray* parserObjects;

//- (IBAction)reTopic:(id)sender;
- (IBAction)moreReply:(id)sender;
@end


