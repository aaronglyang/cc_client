//
//  FirstViewController.m
//  cocoachina
//
//  Created by 国良 on 12-5-19.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//

#import "FirstViewController.h"
#import "ContentViewController.h"
#import "IssueViewController.h"
//#import "DemoTableHeaderView.h"
//#import "DemoTableFooterView.h"

@implementation FirstViewController
@synthesize twitterDic;
@synthesize MyParserObjects;
@synthesize twitterDic2;
@synthesize MyParserObjects2;
@synthesize currentText;
@synthesize currentElementName;
@synthesize myLabel;
@synthesize naviBar,moreButton;
@synthesize content,subject;
@synthesize tipicTable;
@synthesize tempTid,nowFid,testFlag;

static NSString *kCellIdentifier = @"MyIdentifier";

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	 [temporaryBarButtonItem release];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"发帖" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																action:@selector(issue)] autorelease];
	tipicTable.backgroundColor = [UIColor clearColor];
	tipicTable.opaque = NO;
	tipicTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForumBack.png"]];
	
	flag = 1;
	page = 2;
}

-(void) issue {
	IssueViewController *issueViewController = [[IssueViewController alloc] init];
	//issueViewController.tid = self.tempTid
	issueViewController.fid = self.nowFid;
	//issueViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	//[self presentModalViewController:issueViewController animated:YES];
	[self.navigationController pushViewController:issueViewController animated:YES];

	[issueViewController release];
} 

- (void) back {
 	[self.navigationController popViewControllerAnimated:YES];
 }
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == [MyParserObjects count]) {
		[self moreTopic:nil];
		return;
	}
 	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	NSString* myMethod=@"cocoachina.bbs.topic.view";
	NSString* myPage = @"1";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
	NSString *tid = [[MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"tid"];
	self.tempTid = tid;
	NSLog(@"tid[%@]", tid);
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@method%@page%@tid%@timestamp%@%@",app_secret,app_key,myMethod,myPage,tid,currentDateStrInit,app_secret];
 	
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?page=%@&tid=%@&timestamp=%@&app_key=%@&method=%@&sign=%@";
 	myUrl = [NSString stringWithFormat:myUrl,myPage,tid,currentDateStr,app_key,myMethod,md5sign];
	NSURL* url = [NSURL URLWithString:myUrl];
	NSLog(@"文章详细:[%@]",myUrl);
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
	self.content = @"test";
	self.subject = @"test";
	flag = 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (MyParserObjects) {
		return [MyParserObjects count]+1;
	}

	return 1;
}
     
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
/*	UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

 	if (indexPath.row == [MyParserObjects count]) {
		cell.textLabel.text = @"获取更多。。。";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blueColor];
	}else {
		if (MyParserObjects) {	
			cell.textLabel.text = [[MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"subject"];
		}else {
			cell.textLabel.text = @"cocoachina论坛板块222";
		}
	}
*/
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];

	if (indexPath.row == [MyParserObjects count]) {
		cell.textLabel.text = @"获取更多。。。";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blueColor];
	}else {
		UIImageView *asyncImage;
		UILabel *titleLabel;
		UITextView *abstractTextView;
 
		cell.accessoryType = UITableViewCellAccessoryNone;	
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 210, 18)];
		titleLabel.text = [[MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"subject"];
		titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
		titleLabel.tag = 1;
		titleLabel.backgroundColor=[UIColor clearColor];
		
		abstractTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 28, 300, 25)];
		[abstractTextView setDelegate:self];
		//	[textView becomeFirstResponder];
		abstractTextView.font = [UIFont fontWithName:@"Arial" size:14];

		abstractTextView.editable = NO;
		abstractTextView.scrollEnabled = NO;
 		NSString *topicAuthor = [[MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"author"];
		NSString *topicPostdate = [[MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"postdate"];
		abstractTextView.text = [NSString stringWithFormat:@"作者:%@        发布时间:%@",topicAuthor,topicPostdate];
 		abstractTextView.tag = 2;
		abstractTextView.backgroundColor=[UIColor clearColor];
		abstractTextView.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
 		 UIImageView *subview = [[UIImageView alloc] initWithFrame:   CGRectMake(250.0f, 10.0f, 30.0f, 30.0f)];
		 [subview setImage:[UIImage imageNamed:@"repleNum.png"]];	
	
		UILabel* repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 10.0f, 30.0f, 30.0f)];
		repliesLabel.text = [[self.MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"replies"];
		repliesLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
		repliesLabel.tag = 1;
		repliesLabel.backgroundColor =[UIColor clearColor];
		repliesLabel.textColor =[UIColor colorWithRed:100.0f/255.0f green:160.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
		[cell addSubview:repliesLabel];
		[cell addSubview:subview];
		[cell.contentView addSubview:titleLabel];
		[cell.contentView addSubview:abstractTextView];
		
		[titleLabel release];
		[abstractTextView release];
		cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForumLine.png"]];

	}

	return cell;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (!tmpMutableData) {
        tmpMutableData =  [[NSMutableData alloc] initWithData:data]; //[NSMutableData dataWithData:data];
    } else {
        [tmpMutableData appendData:data];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (0 < [tmpMutableData length]) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);  
		NSString* str = [[NSString alloc] initWithData:tmpMutableData encoding:enc];
		[tmpMutableData release];
        tmpMutableData = nil;
		NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser* parser = [NSXMLParser alloc];
        [parser initWithData:postData];
        [parser setDelegate:self];
        [parser parse];
        [parser release];
    }
}
#pragma mark NSXMLParserDelegate--->
- (void )parserDidStartDocument:(NSXMLParser *)parser
{
	if (flag==1 && ![self.testFlag isEqualToString :@"2" ]) {
		self.twitterDic = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
		self.MyParserObjects = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
	}else {
		self.twitterDic2 = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
		self.MyParserObjects2 = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
	}

}

- (void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if (flag==1) {
 		if ([elementName isEqualToString :@"topic" ]) // 找节点进行解析
		{
			NSMutableDictionary *newNode = [[ NSMutableDictionary alloc ] initWithCapacity : 0 ];
			[self.MyParserObjects addObject :newNode];
			self.twitterDic = newNode;
			self.currentElementName = @"topic";
 		}
	}else { 
  		if ([elementName isEqualToString :@"topic" ] ) {
			NSMutableDictionary *newNode = [[ NSMutableDictionary alloc ] initWithCapacity : 0 ];
			[self.MyParserObjects2 addObject :newNode];
			self.twitterDic2 = newNode;
			self.currentElementName = @"topic";
		}
	}
}

- (void )parser:(NSXMLParser *)parser foundCharacters:(NSMutableString *)string{
	self.currentText = [[ NSMutableString alloc] initWithString:string];
	//NSLog(@" contont %@",self.currentText);
}

- (void )parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
		if (flag==1) {
			if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ])
			{
				[ self.twitterDic setObject : self.currentText forKey :elementName];
			}
		}else {
			if([self.content isEqualToString :@"test"] && [elementName isEqualToString:@"content"]){
				self.content = self.currentText;
//				NSLog(self.content);
			}
			if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ])
			{
				[ self.twitterDic2 setObject : self.currentText forKey :elementName];
			}
		}

}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//	NSLog(@"到了这里  错误提示");
//	int errorid  =	[parseError code];
}

- (NSString *) createRandomValue
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	return [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:[NSDate date]],
			[NSNumber numberWithInt:rand()]];
}

-(void )parserDidEndDocument:(NSXMLParser *)parser// 得到的解析结果
{	
	if (flag==1 ) {
		[tipicTable reloadData];
	}else{
		ContentViewController *contentViewController = [[ContentViewController alloc] init];
		contentViewController.tid = self.tempTid;
// 		contentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		//[self presentModalViewController:contentViewController animated:YES];
  		[self.navigationController pushViewController:contentViewController animated:YES];
		
		//contentViewController.topicTitle.text = self.subject;
 		contentViewController.parserObjects = self.MyParserObjects2;
		//NSLog(@"content: %@",self.content);
 		[contentViewController.replyTable reloadData];
		[contentViewController release]; 
 	}
}
- (IBAction)moreTopic:(id)sender{
	self.testFlag = @"2";
	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	int  myPage =  page; 
	NSString* myFid=self.nowFid;
	NSString* myMethod=@"cocoachina.bbs.topics.list"; 
 	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
	NSString *nowPage = [NSString stringWithFormat:@"%d",myPage];
 	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@fid%@method%@page%@timestamp%@%@",app_secret,app_key,myFid,myMethod,nowPage,currentDateStrInit,app_secret];
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?page=%@&fid=%@&timestamp=%@&app_key=%@&method=%@&sign=%@";
  	myUrl = [NSString stringWithFormat:myUrl,nowPage,myFid,currentDateStr,app_key,myMethod,md5sign];
 	NSURL* url = [NSURL URLWithString:myUrl];
	NSLog(@"url [%@]",myUrl);
 	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
	page = myPage+1;
	flag=1;
 	[self.tipicTable reloadData];
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.tipicTable.contentInset = UIEdgeInsetsZero;
	}];
	
}

- (void)dealloc {
	[tipicTable release];
	[twitterDic release];
	[MyParserObjects release];
	[currentText release];
	[currentElementName release];
	[myLabel release];
	[tempTid release];
	[naviBar release];
	[content release];
	[subject release];
	
	[MyParserObjects2 release];
	[MyParserObjects2 release];
	[moreButton release];
	[nowFid release];
	[testFlag release];
	[super dealloc];
}
@end
