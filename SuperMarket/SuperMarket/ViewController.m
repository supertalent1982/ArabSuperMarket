//
//  ViewController.m
//  SuperMarket
//
//  Created by phoenix on 10/30/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"
#import "Setting.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize responseType;
@synthesize areaObj;
@synthesize cityObj;
@synthesize measureObj;
@synthesize mainObj;
@synthesize subObj;
@synthesize responseNum;
@synthesize arrayRequest;
@synthesize arrayResponse;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    responseType = @"";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    self.navigationController.navigationBarHidden = YES;
    
    if(!success) {
        
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Q8SupermarketDB.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    responseNum = 0;
    self.btnArab.hidden = YES;
    self.btnEnglish.hidden = YES;
    NSMutableArray *reqestArray = [[NSMutableArray alloc]init];
    arrayRequest = [[NSMutableArray alloc]init];
    arrayResponse = [[NSMutableArray alloc]init];
    //--- Area Get All request ---
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<AreaGetAll xmlns=\"http://tempuri.org/\" />\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    [reqestArray addObject:soapMessage];
    
    //--- City Get All request ---
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   "<soap:Body>\n"
                   "<CityGetAll xmlns=\"http://tempuri.org/\" />\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"
                   ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    [reqestArray addObject:soapMessage];
    
    //--- MainCategory Get All request ---
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   "<soap:Body>\n"
                   "<MainCategoryGetAll xmlns=\"http://tempuri.org/\" />\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"
                   ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    [reqestArray addObject:soapMessage];
    
    
    //--- SubCategory Get All request ---
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   "<soap:Body>\n"
                   "<SubCategoryGetAll xmlns=\"http://tempuri.org/\" />\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"
                   ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    [reqestArray addObject:soapMessage];
    
    //--- Measures Get All request ---
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   "<soap:Body>\n"
                   "<MeasuresGetAll xmlns=\"http://tempuri.org/\" />\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"
                   ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    [reqestArray addObject:soapMessage];
    
    
    for (int i = 0; i < reqestArray.count; i++){
        NSMutableURLRequest *theRequest;
        NSString *msgLength;
        NSString *soapStr = [reqestArray objectAtIndex:i];
        if (i == 0){
            
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=AreaGetAll"];
        theRequest = [NSMutableURLRequest requestWithURL:url];
        msgLength = [NSString stringWithFormat:@"%d", [soapStr length]];
	
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/AreaGetAll" forHTTPHeaderField:@"SOAPAction"];
        }
        else if (i == 1){
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CityGetAll"];
            theRequest = [NSMutableURLRequest requestWithURL:url];
            msgLength = [NSString stringWithFormat:@"%d", [soapStr length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/CityGetAll" forHTTPHeaderField:@"SOAPAction"];
            
        }else if (i == 2){
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MainCategoryGetAll"];
            theRequest = [NSMutableURLRequest requestWithURL:url];
            msgLength = [NSString stringWithFormat:@"%d", [soapStr length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/MainCategoryGetAll" forHTTPHeaderField:@"SOAPAction"];
            
        }else if (i == 3){
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=SubCategoryGetAll"];
            theRequest = [NSMutableURLRequest requestWithURL:url];
            msgLength = [NSString stringWithFormat:@"%d", [soapStr length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/SubCategoryGetAll" forHTTPHeaderField:@"SOAPAction"];
            
        }else if (i == 4){
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=MeasuresGetAll"];
            theRequest = [NSMutableURLRequest requestWithURL:url];
            msgLength = [NSString stringWithFormat:@"%d", [soapStr length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/MeasuresGetAll" forHTTPHeaderField:@"SOAPAction"];
            
        }
            [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [soapStr dataUsingEncoding:NSUTF8StringEncoding]];
            
        [arrayRequest addObject:theRequest];
        
    }
    responseNum = 0;
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:[arrayRequest objectAtIndex:0] delegate:self];
    if( theConnection )
    {
        webData = [[NSMutableData alloc]init];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}
- (NSString *) getDBPath {
    
    
    
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"Q8SupermarketDB.db"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnArab:(id)sender {
    [Setting sharedInstance].myLanguage = @"Arab";
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"TabBarView"];
    
    [Setting sharedInstance].tabBarController = tabVC;
    [[Setting sharedInstance] customizeTabBar];
    [self.navigationController pushViewController:tabVC animated:YES];
}

- (IBAction)onBtnEnglish:(id)sender {
    [Setting sharedInstance].myLanguage = @"En";
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"TabBarView"];
    
    [Setting sharedInstance].tabBarController = tabVC;
    [[Setting sharedInstance] customizeTabBar];
    [self.navigationController pushViewController:tabVC animated:YES];
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
    [arrayResponse addObject:xmlParser];
    responseNum++;
    if (responseNum < 5){
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:[arrayRequest objectAtIndex:responseNum] delegate:self];
    if( theConnection )
    {
        webData = [[NSMutableData alloc]init];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
        
    }
    NSLog(@"responseNum ====== %d", responseNum);
    if (responseNum == 5) {
        responseNum = 0;
        for (int i = 0; i < 5; i++) {
            NSXMLParser *xmlParse = [arrayResponse objectAtIndex:i];
            [xmlParse setDelegate: self];
            [xmlParse setShouldResolveExternalEntities: YES];
            [xmlParse parse];
        }
    }

}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"AreaGetAllResult"])
    {
        [Setting sharedInstance].Areas = [[NSMutableArray alloc]init];
        responseType = @"area";
        
    }
    if ([elementName isEqualToString:@"MainCategoryGetAllResult"])
    {
        [Setting sharedInstance].MainCategories = [[NSMutableArray alloc]init];
        responseType = @"main";
    }
    if ([elementName isEqualToString:@"CityGetAllResult"])
    {
        [Setting sharedInstance].Cities = [[NSMutableArray alloc]init];
        responseType = @"city";
    }
    if ([elementName isEqualToString:@"MeasuresGetAllResult"])
    {
        [Setting sharedInstance].arrayMeasures = [[NSMutableArray alloc]init];
        responseType = @"measure";
    }
    if ([elementName isEqualToString:@"SubCategoryGetAllResult"])
    {
        [Setting sharedInstance].SubCategories = [[NSMutableArray alloc]init];
        responseType = @"sub";
    }
    
    if ([responseType isEqualToString:@"area"]) {
        if ([elementName isEqualToString:@"AreaResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            if (!areaObj)
                areaObj = [[Area alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"StateID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"AreaNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"AreaNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    if ([responseType isEqualToString:@"main"]) {
        if ([elementName isEqualToString:@"MainCategoryResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            if (!mainObj)
                mainObj = [[MainCategory alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"CatNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"CatNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    if ([responseType isEqualToString:@"city"]) {
        if ([elementName isEqualToString:@"CityResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            if (!cityObj)
                cityObj = [[State alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"StateNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"StateNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    if ([responseType isEqualToString:@"measure"]) {
        if ([elementName isEqualToString:@"MeasureResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            if (!measureObj)
                measureObj = [[Measures alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"MeasureNameAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"MeasureNameEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
    }
    if ([responseType isEqualToString:@"sub"]) {
        if ([elementName isEqualToString:@"SubCategoryResult"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            if (!subObj)
                subObj = [[SubCategory alloc]init];
        }
        if ([elementName isEqualToString:@"ID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"MainCatID"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"SubCatAr"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"SubCatEn"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"CatMeasures"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
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

    if ([responseType isEqualToString:@"area"]){
        if( [elementName isEqualToString:@"AreaGetAllResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            responseType = @"";
            responseNum++;
            if (responseNum == 5) {
                self.btnArab.hidden = NO;
                self.btnEnglish.hidden = NO;
            }
        }
        if( [elementName isEqualToString:@"AreaResult"])
        {
            recordResults = FALSE;
            [[Setting sharedInstance].Areas addObject:areaObj];
            soapResults = nil;
            areaObj = nil;
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            areaObj.areaID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateID"])
        {
            recordResults = FALSE;
            areaObj.areaStateID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AreaNameAr"])
        {
            recordResults = FALSE;
            areaObj.areaNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"AreaNameEn"])
        {
            recordResults = FALSE;
            areaObj.areaNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            areaObj.sort = soapResults;
            soapResults = nil;
        }
    }
    if ([responseType isEqualToString:@"main"]){
        if( [elementName isEqualToString:@"MainCategoryGetAllResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            responseType = @"";
            responseNum++;
            if (responseNum == 5) {
                self.btnArab.hidden = NO;
                self.btnEnglish.hidden = NO;
            }
        }
        if( [elementName isEqualToString:@"MainCategoryResult"])
        {
            recordResults = FALSE;
            [[Setting sharedInstance].MainCategories addObject:mainObj];
            soapResults = nil;
            mainObj = nil;
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            mainObj.mainCatID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CatNameAr"])
        {
            recordResults = FALSE;
            mainObj.mainCatNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CatNameEn"])
        {
            recordResults = FALSE;
            mainObj.mainCatNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            mainObj.sort = soapResults;
            soapResults = nil;
        }
    }
    if ([responseType isEqualToString:@"city"]){
        if( [elementName isEqualToString:@"CityGetAllResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            responseType = @"";
            responseNum++;
            if (responseNum == 5) {
                self.btnArab.hidden = NO;
                self.btnEnglish.hidden = NO;
            }
        }
        if( [elementName isEqualToString:@"CityResult"])
        {
            recordResults = FALSE;
            [[Setting sharedInstance].Cities addObject:cityObj];
            soapResults = nil;
            cityObj = nil;
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            cityObj.stateID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateNameAr"])
        {
            recordResults = FALSE;
            cityObj.stateNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"StateNameEn"])
        {
            recordResults = FALSE;
            cityObj.stateNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            cityObj.sort = soapResults;
            soapResults = nil;
        }
    }
    if ([responseType isEqualToString:@"measure"]){
        if( [elementName isEqualToString:@"MeasuresGetAllResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            responseType = @"";
            responseNum++;
            if (responseNum == 5) {
                self.btnArab.hidden = NO;
                self.btnEnglish.hidden = NO;
            }
        }
        if( [elementName isEqualToString:@"MeasureResult"])
        {
            recordResults = FALSE;
            [[Setting sharedInstance].arrayMeasures addObject:measureObj];
            soapResults = nil;
            measureObj = nil;
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            measureObj.measureID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"MeasureNameAr"])
        {
            recordResults = FALSE;
            measureObj.measureNameAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"MeasureNameEn"])
        {
            recordResults = FALSE;
            measureObj.measureNameEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            measureObj.sort = soapResults;
            soapResults = nil;
        }
    }
    if ([responseType isEqualToString:@"sub"]){
        if( [elementName isEqualToString:@"SubCategoryGetAllResult"])
        {
            recordResults = FALSE;
            soapResults = nil;
            responseType = @"";
            responseNum++;
            if (responseNum == 5) {
                self.btnArab.hidden = NO;
                self.btnEnglish.hidden = NO;
            }
        }
        if( [elementName isEqualToString:@"SubCategoryResult"])
        {
            recordResults = FALSE;
            [[Setting sharedInstance].SubCategories addObject:subObj];
            soapResults = nil;
            subObj = nil;
        }
        if ([elementName isEqualToString:@"ID"])
        {
            recordResults = FALSE;
            subObj.subCatID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"MainCatID"])
        {
            recordResults = FALSE;
            subObj.mainCatID = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"SubCatAr"])
        {
            recordResults = FALSE;
            subObj.subCatAr = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"SubCatEn"])
        {
            recordResults = FALSE;
            subObj.subCatEn = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"CatMeasures"])
        {
            recordResults = FALSE;
            subObj.subCatMeasures = soapResults;
            soapResults = nil;
        }
        if ([elementName isEqualToString:@"Sort"])
        {
            recordResults = FALSE;
            subObj.sort = soapResults;
            soapResults = nil;
        }
    }
    
 }
@end
