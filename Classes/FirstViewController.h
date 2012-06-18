//
//  FirstViewController.h
//  cocoachin3
//
//  Created by 国良 on 12-5-22.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "STableViewController.h"

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {
	NSMutableDictionary* twitterDic;
	NSMutableArray* MyParserObjects;
	NSMutableDictionary* twitterDic2;
	NSMutableArray* MyParserObjects2;
	NSMutableString* currentText;
	NSString* currentElementName;
	
	NSString *content;
	NSString *subject;
	IBOutlet UITableView* tipicTable;
	
	UINavigationBar *naviBar;
    NSMutableData* tmpMutableData;
	UILabel *myLabel;
	int flag;
	NSString * testFlag;
	int page ;
	NSString * tempTid;
	NSString * nowFid;
	UIButton * moreButton;
}

@property(nonatomic, retain) NSString* currentElementName;
@property(nonatomic, retain) NSMutableString* currentText;
@property(nonatomic, retain) NSString* content;
@property(nonatomic, retain) NSString* nowFid;
@property(nonatomic, retain) NSString* subject;
@property(nonatomic, retain) NSString* tempTid;
@property(nonatomic, retain) NSString* testFlag;

@property(nonatomic, retain) NSMutableArray* MyParserObjects;
@property(nonatomic, retain) NSMutableDictionary* twitterDic;
@property(nonatomic, retain) NSMutableArray* MyParserObjects2;
@property(nonatomic, retain) NSMutableDictionary* twitterDic2;

@property (nonatomic, retain) IBOutlet UIButton * moreButton;
@property (nonatomic, retain) IBOutlet UILabel *myLabel;
@property (nonatomic, retain) IBOutlet UINavigationBar *naviBar;
@property (nonatomic, retain) IBOutlet UITableView* tipicTable;

- (IBAction)moreTopic:(id)sender;
- (NSString *) createRandomValue;
@end

