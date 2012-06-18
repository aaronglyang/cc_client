#import "ContentViewController.h"
#import "ReplyViewController.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ContentViewController
@synthesize content,topicTitle;
@synthesize naviBar;
@synthesize replyTable,testFlag;
@synthesize tid,parserObjects,moreButton,myTitle;
@synthesize currentText;
@synthesize currentElementName,twitterDic;
 
#define FONT_SIZE 18.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.content setLineBreakMode:UILineBreakModeWordWrap];
	[self.content setMinimumFontSize:FONT_SIZE];
	[self.content setNumberOfLines:0];
	[self.content setFont:[UIFont systemFontOfSize:FONT_SIZE]];
	[self.content setTag:1];
	
//	[[self.content layer] setBorderWidth:2.0f];
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
//	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" 
//																   style:UIBarButtonItemStyleBordered 
//																  target:self 
//																  action:@selector(back)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"回复" 
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(reply)] autorelease];
	
	[self.topicTitle setLineBreakMode:UILineBreakModeWordWrap];
	[self.topicTitle setMinimumFontSize:FONT_SIZE];
	[self.topicTitle setNumberOfLines:0];
    page = 2;
	//self.moreButton.titleLabel.text = @"更多回复···";
	[self.moreButton setTitle:@"更多回复···" forState:UIControlStateNormal];
	
	replyTable.backgroundColor = [UIColor clearColor];
	replyTable.opaque = NO;
	replyTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForumBack.png"]];

}



- (void) reply{
	ReplyViewController *replyViewController = [[ReplyViewController alloc] init];
	replyViewController.tid = self.tid;
	
	replyViewController.topicTitle = [[parserObjects objectAtIndex:0] objectForKey:@"subject"];
	//replyViewController.reTitle.text = reTitle;
	[self.navigationController pushViewController:replyViewController animated:YES];

	[replyViewController release];
}

- (void) back {
 	[self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *subject = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"subject"];
	NSString *contents =  [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"content"];
	NSString *author = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"author"];
	NSString *replyTime = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"postdate"];
	
	NSString *text;
 
	text = [NSString stringWithFormat:@"%@\n%@\n回复于：%@\n",contents,author,replyTime];
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH -(CELL_CONTENT_MARGIN *2), 20000.0f);
	
	CGFloat Height = [contents sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(300, 200) lineBreakMode:UILineBreakModeWordWrap].height;

//	CGSize size =[text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGFloat height = MAX(Height , 50.0f);
	
	if (indexPath.row ==0) {
		return height +90 +(CELL_CONTENT_MARGIN *2);
	}
	return height +20 +(CELL_CONTENT_MARGIN *2);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
	if (parserObjects) {		
		int countNum = [parserObjects count];
 		return countNum;
	}
    return 2;
}

#define UIAdminLabel_Tag    9999
#define FONT_SIZE 18.0f
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 	
	static NSString* reuseID = @"aCell";
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID] autorelease];
	cell.accessoryType = UITableViewCellAccessoryNone;
	UILabel* lable=[[UILabel alloc] initWithFrame:CGRectZero];
	NSString * lzName = [[parserObjects objectAtIndex:0] objectForKey:@"author"];
	if (indexPath.row == [parserObjects count]) {
		cell.textLabel.text = @"获取更多。。。";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blueColor];
		//return cell;
	}else {
		NSString *subject = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"subject"];
		NSString *contents =  [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"content"];
		NSString *author = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"author"];
		NSString *replyTime = [[parserObjects objectAtIndex:indexPath.row] objectForKey:@"postdate"];
		NSString *replyNums = [[parserObjects objectAtIndex:0] objectForKey:@"replies"];
		NSString *text;
		
		UIImageView *asyncImage;
		UILabel *titleLabel;
		UILabel *abstractTextView;
		UILabel* repliesLabel;
		UIImageView *subview;
		CGFloat Height = [contents sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(300, 200) lineBreakMode:UILineBreakModeWordWrap].height;

		if ([subject isEqualToString :@"empty"]) {
			self.moreButton.hidden=TRUE;
			cell.textLabel.text = @"暂无回复。。。";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor yellowColor];
			return cell;
		}
		if(indexPath.row == 0){
			NSLog(@"第一个");
				
			UILabel * mainTopic;
			mainTopic = [[UILabel alloc] initWithFrame:CGRectMake(5,5,60, 30)];
			mainTopic.backgroundColor = [UIColor  clearColor];
			mainTopic.text = @"主题:";
			mainTopic.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
			[cell addSubview:mainTopic];
			
			titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,5, 200,25)];
			titleLabel.backgroundColor = [UIColor  clearColor];
			titleLabel.text = subject;
 			titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
			titleLabel.textColor =[UIColor colorWithRed:82.0f/255.0f green:120.0f/255.0f blue:160.0f/255.0f alpha:1.0f];

			subview = [[UIImageView alloc] initWithFrame:   CGRectMake(260,5, 30,30)];
			[subview setImage:[UIImage imageNamed:@"repleNum.png"]];	
			
			UILabel * replyNumsLabel;
			replyNumsLabel = [[UILabel alloc] initWithFrame:CGRectMake(300,5, 30,25)];
			//replyNumsLabel.backgroundColor = [UIColor  clearColor];
			replyNumsLabel.text = replyNums;
 			replyNumsLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
			//replyNumsLabel.textColor =[UIColor colorWithRed:82.0f/255.0f green:120.0f/255.0f blue:160.0f/255.0f alpha:1.0f];			
			replyNumsLabel.textColor = [UIColor blueColor];
			[cell addSubview:replyNumsLabel];
			
			 UILabel *backLabel;
 		 	backLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f,30.0f, 330.0f,75)];
 			backLabel.backgroundColor =[UIColor colorWithRed:17.0f/255.0f green:180.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
 			[cell.contentView addSubview:backLabel];
 			
			UIImageView *LzLogoFirst;
			LzLogoFirst = [[UIImageView alloc] initWithFrame:   CGRectMake(5,40, 40,40)];
			[LzLogoFirst setImage:[UIImage imageNamed:@"LzLogo.png"]];	
			[cell  addSubview:LzLogoFirst];
			
			UILabel *authorLabel;
			authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,50,200, 30)];
			authorLabel.backgroundColor=[UIColor clearColor];
			authorLabel.text = author;
			authorLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
			authorLabel.textColor = [UIColor whiteColor];
			[cell addSubview:authorLabel];
			
			repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0f,50.0f, 50.0f, 20.0f)];
			repliesLabel.backgroundColor =[UIColor clearColor];
			repliesLabel.textColor = [UIColor whiteColor] ;
			repliesLabel.textAlignment = UITextAlignmentRight; 
			repliesLabel.text=@"楼主";
			
			UILabel *replyTimesLabel;
		 	replyTimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0f,80.0f, 150.0f, 20.0f)];
			replyTimesLabel.backgroundColor =[UIColor clearColor];
			replyTimesLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
			replyTimesLabel.text=replyTime;
			replyTimesLabel.textColor = [UIColor whiteColor] ;
			replyTimesLabel.textAlignment = UITextAlignmentRight; 
			[cell addSubview:replyTimesLabel];
			
			UILabel *LzContentLabel;
		 	LzContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f,100.0f, 320.0f,Height)];
			LzContentLabel.backgroundColor =[UIColor clearColor];
			LzContentLabel.text=contents;
 			LzContentLabel.numberOfLines = (NSInteger) (Height / 17);
			LzContentLabel.lineBreakMode = UILineBreakModeWordWrap;
			LzContentLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0f];
			[cell addSubview:LzContentLabel];
			
			[cell addSubview:repliesLabel];
			[cell addSubview:titleLabel];
 			[cell addSubview:subview];
			return cell;
 		}  
	
		if(![lzName isEqualToString:author]){
			titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 245, Height)];
			titleLabel.backgroundColor = [UIColor colorWithRed:191/255.0f green:195/255.0f blue:217/255.0f alpha:1.0f];
			
			abstractTextView = [[UILabel alloc] initWithFrame:CGRectMake(0,Height+5, 300, 30)];
			abstractTextView.backgroundColor=[UIColor clearColor];
			
			repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0f,50.0f, 100.0f, 20.0f)];
			repliesLabel.backgroundColor =[UIColor clearColor];
			
			subview = [[UIImageView alloc] initWithFrame:   CGRectMake(260.0f, 10.0f, 40.0f, 40.0f)];
			[subview setImage:[UIImage imageNamed:@"UserLogo.png"]];		

		}else {
			titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 245, Height)];
			titleLabel.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1.0f];
			
			abstractTextView = [[UILabel alloc] initWithFrame:CGRectMake(70,Height+5, 300, 30)];
			abstractTextView.backgroundColor=[UIColor clearColor];
			
			repliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,50.0f,100.0f,20.0f)];
			repliesLabel.backgroundColor =[UIColor clearColor];
			
			subview = [[UIImageView alloc] initWithFrame:   CGRectMake(10.0f, 10.0f, 40.0f, 40.0f)];
			[subview setImage:[UIImage imageNamed:@"LzLogo.png"]];		
			
		}
		titleLabel.tag = 1;
		titleLabel.text = contents;
		titleLabel.numberOfLines = (NSInteger) (Height / 14);
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0f];
		
		//[abstractTextView setDelegate:self];
		//abstractTextView.editable = NO;
		//abstractTextView.scrollEnabled = NO;
		//abstractTextView.tag = 2;
		abstractTextView.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
		abstractTextView.font = [UIFont fontWithName:@"Arial" size:14];
		abstractTextView.text = [NSString stringWithFormat:@"回复时间:%@",replyTime];
		
		
		repliesLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
		repliesLabel.text = author;
		repliesLabel.textColor =[UIColor colorWithRed:130.0f/255.0f green:160.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
		repliesLabel.tag = 1;
	  
		
		[cell.contentView addSubview:repliesLabel];
		[cell.contentView addSubview:titleLabel];
		[cell.contentView addSubview:abstractTextView];
  		[cell addSubview:subview];
		
	}
	
	return cell;
}
- (IBAction)moreReply:(id)sender{
	NSLog(@"获得更多");
	NSString* app_key = @"36820518";
	NSString* app_secret =@"345v4y54u657u4t435t35vvtdf!23EFQZ4";
	NSString* myMethod=@"cocoachina.bbs.topic.view";
	int  myPage =  page; 
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm"];
	NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
	
	NSDateFormatter *dateFormatterInit = [[NSDateFormatter alloc] init];
	[dateFormatterInit setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDateStrInit = [dateFormatterInit stringFromDate:[NSDate date]];
	NSString *myTid = self.tid;
	NSString *nowPage = [NSString stringWithFormat:@"%d",myPage];
	NSString* mysign = [NSString stringWithFormat: @"%@app_key%@method%@page%@tid%@timestamp%@%@",app_secret,app_key,myMethod,nowPage,myTid,currentDateStrInit,app_secret];
 	
	const char *cStr = [mysign UTF8String]; 
	unsigned char result[32]; 
	CC_MD5( cStr, strlen(cStr), result ); 
 	NSMutableString *md5sign = [NSMutableString string];
    for(int i=0;i<16;i++)
    {
        [md5sign appendFormat:@"%02X",result[i]];
    }
	
	NSString* myUrl = @"http://api.cocoachina.com/?page=%@&tid=%@&timestamp=%@&app_key=%@&method=%@&sign=%@";
 	myUrl = [NSString stringWithFormat:myUrl,nowPage,myTid,currentDateStr,app_key,myMethod,md5sign];
	NSURL* url = [NSURL URLWithString:myUrl];
NSLog(@"第二个:[%@]",myUrl);	
	
	page = myPage+1;
	self.testFlag = @"2";
 	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:request delegate:self];
	[connect start];
	NSLog(@"parserObjects[%@]:",self.parserObjects);
//	[self.replyTable reloadData];
//	[UIView animateWithDuration:0.3 animations:^(void) {
// 		self.replyTable.contentInset = UIEdgeInsetsZero;
// 	}];
	
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
//		NSLog(str);
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
//	if (flag==1 && ![self.testFlag isEqualToString :@"2" ]) {
//		self.twitterDic = [[ NSMutableDictionary alloc] initWithCapacity: 0 ]; // 每一条信息都用字典来存；
//		self.parserObjects = [[ NSMutableArray alloc ] init ]; //每一组信息都用数组来存，做后得到的数据就在这个数组中
//	}
	
}

- (void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
  		if ([elementName isEqualToString :@"topic" ]) // 找节点进行解析
		{
			NSMutableDictionary *newNode = [[ NSMutableDictionary alloc ] initWithCapacity : 0 ];
			[self.parserObjects addObject :newNode];
			self.twitterDic = newNode;
			self.currentElementName = @"topic";
 		}
	 
}

- (void )parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	self.currentText = [[ NSString alloc] initWithString:string];
}

- (void )parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
 		if (self.currentElementName && ![elementName isEqualToString :self.currentElementName ])
		{
			[ self.twitterDic setObject : self.currentText forKey :elementName];
		}
 
	
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//	NSLog(@"到了这里  错误提示");
//	int errorid  =	[parseError code];
}

-(void )parserDidEndDocument:(NSXMLParser *)parser// 得到的解析结果
{	
	int arrCount = [self.parserObjects count];
	
	NSString *subject = [[parserObjects objectAtIndex:arrCount-1] objectForKey:@"subject"];

	if (![subject isEqualToString :@"empty"]) {
		[replyTable reloadData];
	}else {
		[self.moreButton setTitle:@"没有更多···" forState:UIControlStateNormal];

	}

}


- (void)dealloc {
    [super dealloc];
	[content release];
	[naviBar release];
 	[tid release];
	[topicTitle release];
	[parserObjects release];
	[currentElementName release];
	[twitterDic release];
	[testFlag release];
	[replyTable release];
	[moreButton release];
	[currentText release];
 	[topicTitle release];
 
 }
 
@end
 