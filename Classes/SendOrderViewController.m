#import "SendOrderViewController.h"

@implementation SendOrderViewController

@synthesize sendOrderBackGroundImg;
@synthesize sendOrderTopImage;
@synthesize sendOrderBottomImage;
@synthesize leftLabel;
@synthesize rightLabel;
@synthesize doneButton;
@synthesize receivedData;

//==============================================================================
-(IBAction)DoneButtonpressed
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CartSent"
														object:self];
	[self dismissModalViewControllerAnimated:YES];	
}
//==============================================================================
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSError *error;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *promoImgDocPath = [rootPath stringByAppendingPathComponent:@"sendOrderBanner1.png"];
	if (![fileManager fileExistsAtPath:promoImgDocPath]) 
	   {
		NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"sendOrderBanner1" ofType:@"png"];
		[fileManager copyItemAtPath:plistBundlePath toPath:promoImgDocPath error:&error]; 
		if(![fileManager fileExistsAtPath:promoImgDocPath])
		   {
			NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
		   }
	   }
	self.sendOrderTopImage.image =[UIImage imageWithContentsOfFile:promoImgDocPath];
	if (!self.sendOrderTopImage.image) 
	   {
		NSLog(@"Error setting top image in Sendorderview controller");
	   }
	
	rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	promoImgDocPath = [rootPath stringByAppendingPathComponent:@"sendOrderBanner2.png"];
	if (![fileManager fileExistsAtPath:promoImgDocPath]) 
	   {
		NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"sendOrderBanner2" ofType:@"png"];
		[fileManager copyItemAtPath:plistBundlePath toPath:promoImgDocPath error:&error]; 
		if(![fileManager fileExistsAtPath:promoImgDocPath])
		   {
			NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
		   }
	   }
	self.sendOrderBottomImage.image =[UIImage imageWithContentsOfFile:promoImgDocPath];
	if (!self.sendOrderBottomImage.image) 
	   {
		NSLog(@"Error setting bottom image");
	   }

	CartSingleton *Cart = [CartSingleton getSingleton];
	//this will save the serialized cart in the documents folder in the folrm of a propertyList
	[Cart serializeCart];
	
	//now need to transport the propertyList to the webserver
	//first step is get the serialized propertylist from the documents folder
	NSString *pathToSerializedCart = [rootPath stringByAppendingPathComponent:@"serializedCart.plist"];
	NSString *shoppingCartString;
	NSData *serializedData;
	if (![fileManager fileExistsAtPath:pathToSerializedCart])
	   {
		NSLog(@"ERROR:\nCouldnt find serialized cart in documents folder.");
		return;
	   }
	 
	
		serializedData = [NSData dataWithContentsOfFile:pathToSerializedCart];
		shoppingCartString = [[NSString alloc] initWithData:serializedData
															encoding:NSUTF8StringEncoding];
		NSLog(@"%@", shoppingCartString);
		[shoppingCartString release];
	
	
		//==========================================================================
	NSString *urlString = @"http://bitmobilecomputing.com/welcome.php";
	//NSString *urlString = @"http://iphone.zcentric.com/test-upload.php";
	//view the file here http://iphone.zcentric.com/uploads/serializedData.xml
	NSString *filename = @"serializedData";
	NSMutableURLRequest * request= [[[NSMutableURLRequest alloc] init] autorelease];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	NSMutableData *postbody = [NSMutableData data];
	
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.xml\"\r\n", filename] 
						  dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[NSData dataWithData:serializedData]];
	[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:postbody];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request 
											   returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] 
							  initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",returnString);
	[returnString release];
}
//==============================================================================
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"From ReceivedResponse");
	[self.receivedData setLength:0];
}

//==============================================================================
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"From ReceiveData");
	if(self.receivedData == nil)
	   {
		self.receivedData = [[NSMutableData alloc] initWithLength:2048];
	   }
	[self.receivedData appendData:data];
	
}

//==============================================================================
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{	
    NSLog(@"Connection failed! Error - %@ ",
          [error localizedDescription]);
}

//==============================================================================
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"%d bytes of data", [receivedData length]);
		[receivedData release];
	[connection release];
}

//==============================================================================
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//==============================================================================
- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//==============================================================================

- (void)dealloc 
{
    [super dealloc];
}


@end
