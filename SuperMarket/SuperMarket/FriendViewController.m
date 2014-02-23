//
//  FriendViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "FriendViewController.h"
#import "PPRevealSideViewController.h"
#import "SendRequestViewController.h"
#import "Setting.h"
#import "FriendDetailViewController.h"
#import "AcceptRequestViewController.h"
@interface FriendViewController ()

@end

@implementation FriendViewController
@synthesize myFriendTable;
@synthesize beFriendTable;
@synthesize myFriend;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self getFriendsFromOnline];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [self.btnAddNewButton setBackgroundImage:[UIImage imageNamed:@"btn_add_new_friend.png"] forState:UIControlStateNormal];
        [self.btnAddNewButton setBackgroundImage:[UIImage imageNamed:@"btn_add_new_friend.png"] forState:UIControlStateHighlighted];
        [self.btnAddNewButton setBackgroundImage:[UIImage imageNamed:@"btn_add_new_friend.png"] forState:UIControlStateSelected];
        [self.imgRequest setImage:[UIImage imageNamed:@"title_friend_request.png"]];
        [self.imgFriends setImage:[UIImage imageNamed:@"title_my_friends.png"]];
        
    }
    else{
        [self.btnAddNewButton setBackgroundImage:[UIImage imageNamed:@"arab_add_new_friend.png"] forState:UIControlStateNormal];
        [self.btnAddNewButton setBackgroundImage:[UIImage imageNamed:@"arab_add_new_friend.png"] forState:UIControlStateHighlighted];
        [self.btnAddNewButton setBackgroundImage:[UIImage imageNamed:@"arab_add_new_friend.png"] forState:UIControlStateSelected];
        [self.imgRequest setImage:[UIImage imageNamed:@"arabtitle_friend_request.png"]];
        [self.imgFriends setImage:[UIImage imageNamed:@"arabtitle_my_friends.png"]];
        
    }
    [beFriendTable setBackgroundColor:[UIColor clearColor]];
    UIImageView *imgView = [[UIImageView alloc]init];
    [beFriendTable setBackgroundView:imgView];
    [beFriendTable setSeparatorColor:[UIColor grayColor]];
    
    [myFriendTable setBackgroundColor:[UIColor clearColor]];
    UIImageView *imgView1 = [[UIImageView alloc]init];
    [myFriendTable setBackgroundView:imgView1];
    [myFriendTable setSeparatorColor:[UIColor grayColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddNewFriend:(id)sender {
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must log in to manage friend list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }
        else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء تسجيل الدخول لادارة قائمة الاصدقاء" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
  /*  else{
    if ([[Setting sharedInstance].customer.UserType isEqualToString:@"0"]){*/
        if (![self.viewName isEqualToString:@"sendrequest"]) {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SendRequestViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"SendRequestView"];
            [self.prevView.navigationController pushViewController:VC animated:YES];
  
        }

        [self.revealSideViewController popViewControllerAnimated:YES];
    /*}
    else{
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"The social user can't manage friend list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
    }
    }*/
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (_tableView == beFriendTable) {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"beFriendCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"beFriendCell"];
        UILabel *lb_pendingFriend = (UILabel*)[cell viewWithTag:101];
        FriendObject *obj = [[Setting sharedInstance].arrayPendingFriends objectAtIndex:indexPath.row];
        lb_pendingFriend.text = obj.friendName;
    }
    else if (_tableView == myFriendTable){
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"myFriendCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myFriendCell"];
        UILabel *lb_pendingFriend = (UILabel*)[cell viewWithTag:102];
        FriendObject *obj = [[Setting sharedInstance].arrayRealFriends objectAtIndex:indexPath.row];
        lb_pendingFriend.text = obj.friendName;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == beFriendTable){
        FriendObject *obj = [[Setting sharedInstance].arrayPendingFriends objectAtIndex:indexPath.row];

            if (![self.viewName isEqualToString:@"acceptrequest"]) {
                UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AcceptRequestViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AcceptRequestView"];

                VC.obj = obj;
                [self.prevView.navigationController pushViewController:VC animated:YES];
                
            }
            else{
                AcceptRequestViewController *VC = (AcceptRequestViewController*)self.prevView;
                VC.obj = obj;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"PopThat"
                 object:self];
            }
   
        [self.revealSideViewController popViewControllerAnimated:YES];

    }
    else if (tableView == myFriendTable){
        FriendObject *obj = [[Setting sharedInstance].arrayRealFriends objectAtIndex:indexPath.row];
        if (![self.viewName isEqualToString:@"detail"]) {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FriendDetailViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendDetailView"];
            
            VC.obj = obj;
            [self.prevView.navigationController pushViewController:VC animated:YES];
            
        }
        else{
            FriendDetailViewController *VC = (FriendDetailViewController*)self.prevView;
            VC.obj = obj;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PopThis"
             object:self];
        }
        
        [self.revealSideViewController popViewControllerAnimated:YES];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == beFriendTable)
        return [Setting sharedInstance].arrayPendingFriends.count;
    if (tableView == myFriendTable)
        return [Setting sharedInstance].arrayRealFriends.count;
    
    return 0;
    
}
- (void)getFriendsFromOnline{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FriendGetList xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<Language>%d</Language>\n"
                             "</FriendGetList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID intValue], myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendGetList"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/FriendGetList" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
	{
		webData = [[NSMutableData alloc]init];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"response XML = %@\n", theXML);
    
    xmlParser = Nil;
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FriendGetListResult"]){
        [[Setting sharedInstance].arrayPendingFriends removeAllObjects];
        [[Setting sharedInstance].arrayRealFriends removeAllObjects];
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FriendListResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
        myFriend = [[FriendObject alloc]init];
    }
    
    if ([elementName isEqualToString:@"FriendID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FriendName"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Mobile"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"City"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Email"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"IsPendingRequest"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( recordResults )
	{
		[soapResults appendString: string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""])
            errEncounter = TRUE;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"FriendGetListResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Getting friend list is failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"فشل في الوصول الي قائمة الأصدقاء" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
                
            }
            return;
        }
        else{
            [beFriendTable reloadData];
            [myFriendTable reloadData];
        }
	}
    
    if ([elementName isEqualToString:@"FriendListResult"])
    {
        if (myFriend.isPending == TRUE)
            [[Setting sharedInstance].arrayPendingFriends addObject:myFriend];
        else
            [[Setting sharedInstance].arrayRealFriends addObject:myFriend];
        myFriend = nil;
        recordResults = FALSE;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendID"]){
        recordResults = FALSE;
        myFriend.friendID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendName"]){
        recordResults = FALSE;
        myFriend.friendName = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"City"]){
        recordResults = FALSE;
        myFriend.friendCity = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Mobile"]){
        recordResults = FALSE;
        myFriend.friendMobile = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Email"]){
        recordResults = FALSE;
        myFriend.friendEmail = soapResults;
        soapResults = nil;
    }
    
    if ([elementName isEqualToString:@"IsPendingRequest"]){
        recordResults = FALSE;
        if ([soapResults isEqualToString:@"true"])
            myFriend.isPending = TRUE;
        else
            myFriend.isPending = FALSE;
        soapResults = nil;
    }
}
@end
