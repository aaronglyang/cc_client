//
//  NewTopicViewController.m
//  cocoachin3
//
//  Created by 国良 on 12-6-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NewTopicViewController.h"
#import "ContentViewController.h"
#import "IssueViewController.h"
//#import "DemoTableHeaderView.h"
//#import "DemoTableFooterView.h"

@implementation NewTopicViewController
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
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	
	flag = 1;
	
	tipicTable.backgroundColor = [UIColor clearColor];
	tipicTable.opaque = NO;
	tipicTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForumBack.png"]];
	self.naviBar.barStyle = UIBarStyleBlackTranslucent;
	[self getTopic];
	
}

-(void) getTopic{
	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	NSString* myMethod=@"cocoachina.bbs.topics.new"; 
	
 	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
	
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@method%@timestamp%@%@",app_secret,app_key,myMethod,currentDateStrInit,app_secret];
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?timestamp=%@&app_key=%@&method=%@&sign=%@";
  	myUrl = [NSString stringWithFormat:myUrl,currentDateStr,app_key,myMethod,md5sign];
 	NSURL* url = [NSURL URLWithString:myUrl];
	NSLog(@"最新帖子：myUrl[%@]", myUrl);
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
 	[connect start];
}
- (void)refreshTable{
 
	flag = 1;
	[self getTopic];
 	NSLog(@"table is refreshing ...."); 
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

 	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	NSString* myMethod=@"cocoachina.bbs.topic.view";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
	NSString *tid = [[self.MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"tid"];
	self.tempTid = tid;
//	NSLog(tid);
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@method%@tid%@timestamp%@%@",app_secret,app_key,myMethod,tid,currentDateStrInit,app_secret];
 	
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?tid=%@&timestamp=%@&app_key=%@&method=%@&sign=%@";
 	myUrl = [NSString stringWithFormat:myUrl,tid,currentDateStr,app_key,myMethod,md5sign];
	NSURL* url = [NSURL URLWithString:myUrl];
	NSLog(@"第一个:[%@]",myUrl);
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
	self.content = @"test";
	self.subject = @"test";
	flag = 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 62;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (self.MyParserObjects) {
		return [self.MyParserObjects count];
	}
	
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	cell.accessoryType = UITableViewCellAccessoryNone;
	UIImageView *asyncImage;
	UILabel *titleLabel;
	UITextView *abstractTextView;
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 210, 18)];
	titleLabel.text = [[self.MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"subject"];
	titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
	titleLabel.tag = 1;
	titleLabel.backgroundColor =[UIColor clearColor];
	abstractTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 28, 300, 25)];
	[abstractTextView setDelegate:self];
	//	[textView becomeFirstResponder];
	abstractTextView.font = [UIFont fontWithName:@"Arial" size:14];
	abstractTextView.editable = NO;
	abstractTextView.scrollEnabled = NO;
	abstractTextView.backgroundColor=[UIColor clearColor];
	//	abstractTextView.text = @"As you navigate deeper into the iPhone......";
	NSString *topicAuthor = [[self.MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"author"];
	NSString *topicPostdate = [[self.MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"postdate"];
	abstractTextView.text = [NSString stringWithFormat:@"作者:%@      发布时间:%@",topicAuthor,topicPostdate];
	//abstractTextView.text =@"test";
	abstractTextView.tag = 2;
	abstractTextView.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
	
	UILabel* repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 10.0f, 30.0f, 30.0f)];
	repliesLabel.text = [[self.MyParserObjects objectAtIndex:indexPath.row] objectForKey:@"replies"];
	repliesLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
	repliesLabel.tag = 1;
	repliesLabel.backgroundColor =[UIColor clearColor];
	repliesLabel.textColor =[UIColor colorWithRed:100.0f/255.0f green:160.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
	
	[cell.contentView addSubview:repliesLabel];
	[cell.contentView addSubview:titleLabel];
	[cell.contentView addSubview:abstractTextView];
	
	UIImageView *subview = [[UIImageView alloc] initWithFrame:   CGRectMake(250.0f, 10.0f, 30.0f, 30.0f)];
	[subview setImage:[UIImage imageNamed:@"repleNum.png"]];		
	subview.backgroundColor = [UIColor clearColor];
	[cell addSubview:subview];
	
	[titleLabel release];
	[abstractTextView release];
  
    cell.selectedTextColor = [UIColor whiteColor];
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForumLine.png"]];
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
		NSLog(@"没有去掉myStr[%@]",str);
		NSString * myStr = [self flattenHTML:str];
		NSLog(@"去掉myStr[%@]",myStr);
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
	if (flag==1) {
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
//			NSLog(self.content);
		}
		if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ])
		{
			[ self.twitterDic2 setObject : self.currentText forKey :elementName];
		}
	}
	
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	int errorid  =	[parseError code];
	NSLog(@"到了这里错误提示[%d]", errorid);    
}


-(void )parserDidEndDocument:(NSXMLParser *)parser// 得到的解析结果
{	
	if (flag==1 ) {
		NSLog(@"self.mypar【%@】",self.MyParserObjects);
		[tipicTable reloadData];
	}else{
		ContentViewController *contentViewController = [[ContentViewController alloc] init];
		contentViewController.tid = self.tempTid;
		//contentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		//[self presentModalViewController:contentViewController animated:YES];
  		[self.navigationController pushViewController:contentViewController animated:YES];
		
		//contentViewController.topicTitle.text = self.subject;
 		contentViewController.parserObjects = self.MyParserObjects2;
		//NSLog(@"content: %@",self.content);
 		[contentViewController.replyTable reloadData];
		[contentViewController release]; 
 	}
}

-(NSMutableString *)flattenHTML:(NSMutableString *)html{   
    NSScanner *theScanner;   
    NSMutableString *text = nil;       
    theScanner = [NSScanner scannerWithString:html];       
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [html length])];   
	html = [html stringByReplacingOccurrencesOfString:@"&lt;" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [html length])];   

	html = [html stringByReplacingOccurrencesOfString:@"/&gt;" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [html length])];   
    html = [html stringByReplacingOccurrencesOfString:@"br" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [html length])];   

 
    while ([theScanner isAtEnd] == NO) {   
        [theScanner scanUpToString:@"<br/>" intoString:NULL];  
       // [theScanner scanUpToString:@"&lt;" intoString:NULL]; 
//		[theScanner scanUpToString:@"/&gt;" intoString:NULL]; 
//		 [theScanner scanUpToString:@"br" intoString:NULL]; 
       // [theScanner scanUpToString:@">" intoString:&text];  &lt;br /&gt       
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@" "];   
    }   
    return html;   
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
	
	//[twitterDic2 release];
	//[MyParserObjects2 release];
	[testFlag release];
	[nowFid release];
	[moreButton release];
	[super dealloc];
}
@end
 
