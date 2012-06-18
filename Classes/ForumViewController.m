
//  ForumViewController.m
//  cocoachin3
//
//  Created by 国良 on 12-5-23.
//  Copyright 2012 CocoaChina.com. All rights reserved.
//


#import "ForumViewController.h"
#import "FirstViewController.h"
	
	@implementation ForumViewController
	@synthesize twitterDic,twitterDic2;
	@synthesize parserObjects,parserObjects2;
	@synthesize currentText;
	@synthesize currentElementName;
	
	@synthesize naviBar;
	@synthesize content,nowFid;
#define FONT_SIZE 18.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
	- (void)viewDidLoad {
		[super viewDidLoad];
		UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
		temporaryBarButtonItem.title = @"返回";
		self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
		[temporaryBarButtonItem release];
		//[self setTitle:@"cocoachina论坛 板块"];
		
		NSString* app_key = @"36820518";
		NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
		NSString* myMethod=@"cocoachina.bbs.forums.get"; 
		
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
		NSURLRequest* request = [NSURLRequest requestWithURL:url];
		NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
		flag = 1;
		[connect start];
		
		//forumTable.separatorColor = [UIColor grayColor];
		//forumTable.backgroundColor = [UIColor grayColor];
		
		forumTable.backgroundColor = [UIColor clearColor];
		forumTable.opaque = NO;
		forumTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForumBack.png"]];
		 		
 		self.naviBar.barStyle = UIBarStyleBlackTranslucent;
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
		[super viewDidLoad];
		NSString* app_key = @"36820518";
		NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
		NSString* myPage=@"1";
		NSLog(@"the parserObjectss is %@", [parserObjects description]);
		NSString* myFid=[[parserObjects objectAtIndex:indexPath.row] objectForKey:@"fid"];
		self.nowFid = myFid;
		
		NSString* myMethod=@"cocoachina.bbs.topics.list"; 
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
		NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
		
		NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
		[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
		
		NSString* mysign = [NSString stringWithFormat: @"%@app_key%@fid%@method%@page%@timestamp%@%@",app_secret,app_key,myFid,myMethod,myPage,currentDateStrInit,app_secret];
		const char *cStr = [mysign UTF8String]; 
		unsigned char result[32]; 
		CC_MD5( cStr, strlen(cStr), result ); 
		NSMutableString *md5sign = [NSMutableString string];
		for(int i=0;i<16;i++)
		{
			[md5sign appendFormat:@"%02X",result[i]];
		}
		
		NSString* myUrl = @"http://api.cocoachina.com/?page=%@&fid=%@&timestamp=%@&app_key=%@&method=%@&sign=%@";
		myUrl = [NSString stringWithFormat:myUrl,myPage,myFid,currentDateStr,app_key,myMethod,md5sign];
		NSURL* url = [NSURL URLWithString:myUrl];
		NSLog(@"myUrl[%@]", myUrl);
		NSURLRequest* request = [NSURLRequest requestWithURL:url];
		NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
		flag = 2;
		[connect start];
	}
	
	- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return 62;
	}
	
	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
		//	NSString* counts = [parserObjects count];
		if (parserObjects && flag == 1) {
			return [parserObjects count];
		}
		return 0;
	}
	
#define UIAdminLabel_Tag    9999
	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		static NSString* reuseID = @"aCell";
		UILabel* lable =[[UILabel alloc] initWithFrame:CGRectMake(70,28, 300, 13)];
		
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[cell addSubview:lable];
		lable.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
		lable.textColor =[UIColor colorWithRed:71.0f/255.0f green:167.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
		lable.backgroundColor = [UIColor clearColor];
		//lable.textAlignment = UITextAlignmentRight;
		lable.tag = UIAdminLabel_Tag;
		[lable release];
		
		
		
		NSString* text = @"";
		NSString* descStr = @"";
		NSString* forumadminStr = @"";
		UIImage* image = nil;
		if(parserObjects){
			NSDictionary* tDict = [parserObjects objectAtIndex:indexPath.row];
			if (0 < [tDict count]) {
				NSString *forumName = [tDict objectForKey:@"name"];
				text = forumName;
				descStr = [tDict objectForKey:@"descrip"];
				
				NSString* tStr = [tDict objectForKey:@"fupadmin"];
				
				if ([tStr hasPrefix:@","]) {
					tStr = [tStr substringFromIndex:1];
				}
				if ([tStr hasSuffix:@","]) {
					tStr = [tStr substringToIndex:[tStr length] - 1];
				}
				forumadminStr = [NSString stringWithFormat:@"版主: %@", tStr];
				NSString *forumImage = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"logo"];
				image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:forumImage]]];
				if (!image) {
					image = [UIImage imageNamed:@"11.png"];
				}
			}
		}
		
		UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,0.0f, 250.0f, 30.0f)];
		labelTitle.backgroundColor = [UIColor clearColor];
		
		//labelTitle.font = [UIFont systemFontOfSize:18];
		labelTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
		[cell addSubview:labelTitle];
		labelTitle.text = text;
		[labelTitle release];
		
		UILabel *labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(70.0f,40.0f, 250.0f, 20.0f)];
		labelDesc.backgroundColor = [UIColor clearColor];
		labelDesc.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
		[cell addSubview:labelDesc];
		labelDesc.text = descStr;
		[labelDesc release];
		labelDesc.textColor = [UIColor darkGrayColor];
		
		
		//cell.textLabel.text = text;
		//cell.detailTextLabel.text = descStr;
		cell.imageView.image = image;
		lable.text = forumadminStr;
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
			[tmpMutableData release];
			
			//NSArray *Array = [NSArray arrayWithObjects:str2, astr, nil];
			
			//Save
			NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
			NSString *filename = [Path stringByAppendingPathComponent:@"test"];
			[NSKeyedArchiver archiveRootObject:str toFile:filename];
			
			//load
			NSString *str2 = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
			NSLog(@"str2: %@",str2);
			
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
		if(flag == 1){
			self.twitterDic = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
			self.parserObjects = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
		}else {
			self.twitterDic2 = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
			self.parserObjects2 = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
		}
	}
	
	
	
	- (void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
	{
		if (flag ==1) {
			if ([elementName isEqualToString :@"forum" ]) // 找节点进行解析
			{
				NSMutableDictionary *newNode = [[ NSMutableDictionary alloc ] initWithCapacity : 0 ];
				[self.parserObjects addObject :newNode];
				self.twitterDic = newNode;
				self.currentElementName = @"forum";
			}	
		}else {
			if ([elementName isEqualToString :@"topic" ]) // 找节点进行解析
			{
				NSMutableDictionary *newNode = [[ NSMutableDictionary alloc ] initWithCapacity : 0 ];
				[self.parserObjects2 addObject :newNode];
				self.twitterDic2 = newNode;
				self.currentElementName = @"topic";
			}
		}
		
	}
	
	- (void )parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		self.currentText = [[ NSString alloc] initWithString:string];
	}
	- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
		NSLog(@"cData:%@",[NSString stringWithUTF8String:[CDATABlock bytes]]); 
	}
	- (void )parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
		if ([self.currentText isEqualToString:@">"]) {	
			[self.parserObjects removeObject:self.twitterDic];
			return;
		}	
		if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ] && flag ==1 )
		{	
			[ self.twitterDic setObject : self.currentText forKey :elementName];
		}
		if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ] && flag ==2 )
		{	
			[ self.twitterDic2 setObject : self.currentText forKey :elementName];
		}
	}
	- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
		//	int errorid  =	[parseError code];
	}
	
	-(void )parserDidEndDocument:(NSXMLParser *)parser// 得到的解析结果
	{  		
		if (flag == 1) {
			[forumTable reloadData];
		}else {
			FirstViewController *firstViewController = [[FirstViewController alloc] init];
			firstViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			//[self presentModalViewController:firstViewController animated:YES];
			[self.navigationController pushViewController:firstViewController animated:YES];
			firstViewController.MyParserObjects = self.parserObjects2;
			firstViewController.nowFid = self.nowFid;
			[firstViewController.tipicTable reloadData];
			[firstViewController release]; 
		}
	}
	
	- (void)dealloc {
		[twitterDic release];
		[parserObjects release];
		[currentText release];
		[currentElementName release];
		[naviBar release];
		
		[content release];
		[nowFid release];
		//[parserObjects2 release];
		//[twitterDic2 release];
		[super dealloc];
	}
	@end
