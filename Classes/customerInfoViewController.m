#import "customerInfoViewController.h"

@implementation customerInfoViewController
@synthesize infoModel;

@synthesize Name;
@synthesize AptNum;
@synthesize Street1;
@synthesize Street2;
@synthesize City;
@synthesize Telephone;
@synthesize Email1;
@synthesize ClearAllButton;

@synthesize textFieldBeingEdited;
@synthesize scrollView;
@synthesize doneButton; 
@synthesize SaveAllButton;

CartSingleton *Cart;
NSMutableArray *UITextFieldInValidity;
//==============================================================================

-(void)viewWillAppear:(BOOL)animated
{
	NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil/*self.view.window*/];
	[super viewWillAppear:animated];
	Cart = [CartSingleton getSingleton];
	
	
}
//==============================================================================

-(void)viewWillDisappear:(BOOL)animated
{
	NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardWillShowNotification 
												  object:nil];
	[super viewWillDisappear:animated];
	
}

//==============================================================================

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	textFieldBeingEdited = textField;
}
//==============================================================================
-(IBAction)textFieldDoneEditing:(id)sender
{
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	textFieldBeingEdited = NULL;
	[sender resignFirstResponder];
	if (moveViewUp) 
	   {
		[self scrollTheView:NO];
	   }
	
}
//==============================================================================
-(BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	//NSLog(@"TextField tag is, %d ", textField.tag);
	if ([self.Name isFirstResponder]) 
	   {
		[self.AptNum becomeFirstResponder];
	   }
	else if ([self.AptNum isFirstResponder]) 
	   {
		[self.Street1 becomeFirstResponder];
	   }
	else if ([self.Street1 isFirstResponder])
	   {
		[self.Street2 becomeFirstResponder];
	   }
	else if ([self.Street2 isFirstResponder])
	   {
		[self.City becomeFirstResponder];
	   }
	else if ([self.City isFirstResponder])
	   {
		[self.Telephone becomeFirstResponder];
	   }
	else if ([self.Telephone isFirstResponder])
	   {
		[self.Email1 becomeFirstResponder];
	   }
	else//([self.Email1 isFirstResponder])
	   {
		[self.Email1 resignFirstResponder];
	   }
	return YES;
}
//==============================================================================
//from iPhone for dummies
-(void)keyboardWillShow:(NSNotification *)notif
{
	
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	NSDictionary *info = [notif userInfo];
	NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	
	CGSize keyboardSize = [aValue CGRectValue].size;
	float bottomPoint = (textFieldBeingEdited.frame.origin.y + textFieldBeingEdited.frame.size.height /*+ 20*/);
	scrollAmount = keyboardSize.height - (self.view.frame.size.height- bottomPoint);
	/*
	 CGRect viewFrame = self.view.frame;
	 viewFrame.size.height += keyboardSize.height;
	 scrollView.frame = viewFrame;
	*/
	if(scrollAmount > 0)
	   {
		moveViewUp = YES;
		[self scrollTheView:YES];
	   }
	else 
	   {
		moveViewUp = NO;
	   }
	
}
//==============================================================================
-(void)scrollTheView:(BOOL)movedUp
{
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = self.view.frame;
	if(movedUp)
	   {
		rect.origin.y -=scrollAmount;
	   }
	else 
	   {
		rect.origin.y +=scrollAmount;
	   }
	self.view.frame = rect;
	[UIView commitAnimations];
}


//==============================================================================
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	
	scrollView.contentSize = self.view.frame.size;
	self.Name.delegate = self;
	self.AptNum.delegate = self;
	self.Street1.delegate = self;
	self.Street2.delegate = self;
	self.City.delegate = self;
	self.Telephone.delegate = self;
	self.Email1.delegate = self;
	
	
	textFieldBeingEdited = NULL;
	//If there is already 
	if (Cart.customerInfoObtained)
	   {
		self.Name.text = Cart.customerInfo.Name;
		self.AptNum.text = Cart.customerInfo.AptNo;
		self.Street1.text = Cart.customerInfo.Street1;
		self.Street2.text = Cart.customerInfo.Street2;
		self.City.text = Cart.customerInfo.City;
		self.Telephone.text = Cart.customerInfo.Tel;
		self.Email1.text = Cart.customerInfo.Email;		
	   }
	
	
	//[self.view setTransform:CGAffineTransformMakeTranslation(0, keyboardSize.height)];
}

//==============================================================================
-(IBAction)ClearAllButtonPressed
{
	NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	if(Cart.customerInfoObtained)
	   {  
		   [Cart.customerInfo release]; 
		   Cart.customerInfoObtained = NO;
	   }
	else
	   {
			NSLog(@"Cart.customerinfoobtained is %d", Cart.customerInfoObtained);
		}
	
	self.Name.text = @"";
	self.AptNum.text = @"";
	self.Street1.text= @"";
	self.Street2.text = @"";
	self.City.text = @"";
	self.Telephone.text = @"";
	self.Email1.text= @"";
	[self reloadInputViews];
}

//==============================================================================
-(IBAction)saveAllButtonPressed
{
	//Authenticate input ie: strings here
	NSArray *textFieldArray = [[NSArray alloc] initWithObjects:
							   self.Name.text, 
							   self.AptNum.text,
							   self.Street1.text,
							   self.Street2.text,
							   self.City.text,
							   self.Telephone.text,
							   self.Email1.text, nil];
			
	BOOL showAlert = FALSE;
	UITextFieldInValidity = [[NSMutableArray alloc] 
								   initWithObjects:
								   [NSNumber numberWithBool:FALSE], 
								   [NSNumber numberWithBool:FALSE],
								   [NSNumber numberWithBool:FALSE],
								   [NSNumber numberWithBool:FALSE],
								   [NSNumber numberWithBool:FALSE],
								   [NSNumber numberWithBool:FALSE], 
								  [NSNumber numberWithBool:FALSE], nil ];
						
	NSLog(@"TextField array count = %d",[textFieldArray count]);
	
	for (int i=0; i< [textFieldArray count]; i++)
	{
		NSString *s = [textFieldArray objectAtIndex:i];
	 	 
		switch (i)
	   {
			case 0:
		  {
		   NSString *const regularExpression = @"^([A-Za-z\\s]{1,50})$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   break;
		  }
		   case 1:
		  {
		   NSString *const regularExpression = @"^([0-9a-zA-Z\\s]{0,6})$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   
		   break;
		  }
		   case 2:
		  {
		   NSString *const regularExpression = @"^([0-9A-Za-z\\s]{0,100})$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   break;
		  }
		   case 3:
		  {
		   NSString *const regularExpression = @"^([0-9A-Za-z\\s]{0,100})$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   
		   break;
		  }
		   case 4:
		  {
		   NSString *const regularExpression = @"^([A-Za-z\\s]{1,50})$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   
		   break;
		  }
		   case 5:
		  {
		   NSString *const regularExpression = @"^([0-9]{10})$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   break;
		  }
		   case 6:
		  {
		   NSString *const regularExpression = @"^([a-zA-Z0-9])+([a-zA-Z0-9\\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\\._-]+)+$";
		   NSError *error = NULL;
		   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
																				  options:NSRegularExpressionCaseInsensitive
																					error:&error];
		   if (error) 
			  {
			   NSLog(@"error %@", error);
			  }
		   
		   NSUInteger numberOfMatches = [regex numberOfMatchesInString:s
															   options:0
																 range:NSMakeRange(0, [s length])];
		   NSLog(@"index = %d", i);
		   NSLog(@"Value of TextField = %@", s);
		   NSLog(@"Regular expression is = %@", regularExpression);
		   if (numberOfMatches <= 0)
			  {
			   NSLog(@"Failed regex test ");
			   [UITextFieldInValidity replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:TRUE]];
			   			   NSLog(@"Set false for value at index:%d", i);
			   showAlert = TRUE;
			  }
		   break;
		  }
		   default:
			break;
		}
	}
	/*
	if(showAlert)
	   {
		NSMutableString *AlertString = [[NSMutableString alloc] 
										  initWithString:@"\nThe following fields have invalid text:\n"];
		
		for (int i = 0; i< [UITextFieldInValidity count]; i++)
		{
			switch (i)
		   {
				case 0:
			  {
			   if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"Alert Message: Name has errors");
				   [AlertString appendString:@"\nName:\n-Required Field\n-Must contain alphabets only.\n"];
				  }
			   break;
			  }
			   case 1:
			  {
			   if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"UIAlert Message: AptNum has errors");
				   [AlertString appendString:@"\nApt/House Number:\n-Optional Field\n-Must be less than\n6 alphabets/numbers\n"];
				  }
			   break;
			  }
			   case 2:
			  {
			    if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"UIAlert Message: Street 1 has errors");
				   [AlertString appendString:@"\nStreet:\n-Optional Field\n-Can contain upto\n100 alphabets/numbers\n"];
				  }
			   break;
			  }
			   case 3:
			  {
			    if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"UIAlert Message: Street 2 has errors");
				   [AlertString appendString:@"\nStreet:\n-Optional Field\n-Can contain upto\n100 alphabets/numbers\n"];
				  }
			   break;
			  }
			   case 4:
			  {
			    if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"UIAlert Message: City has errors");
				   [AlertString appendString:@"\nCity:\n-Required Field\n-Can contain upto\n50 alphabets/numbers\n"];
				  }
			   break;
			  }
			   case 5:
			  {
			    if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"UIAlert Message: Tel has errors");
				   [AlertString appendString:@"\nTelephone:\n-Required Field\n-Must contain exactly 10 numbers\nno spaces or any other characters\n"];
				  }
			   break;
			  }
			   case 6:
			  {
			    if([UITextFieldInValidity objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				  {
				   NSLog(@"UIAlert Message: Email has errors");
				   [AlertString appendString:@"\nEmail:\n-Required Field\n-Can only contain\nvalid email addresses"];
				  }
			   break;
			  }
					
				default:
					break;
			}
		}
		
	   }
	*/
	if(showAlert)
	{
	 NSLog(@"Authnetication for text input failed");
	 
	 incorrectTextViewController *incorrectTextVC = [[incorrectTextViewController alloc] 
													 initWithNibName:@"incorrectTextViewController"
													 bundle: nil];
	 
	 [incorrectTextVC processtextFieldStatusArray:UITextFieldInValidity];
	 
	 [self presentModalViewController:incorrectTextVC animated:YES];
	 [incorrectTextVC release];
		
	}
	else //If passed authentication save everything and pop off the view 
	{
		
		Cart.customerInfoObtained = YES;
		infoModel = [[customerInfoModel alloc] initWithObjects:self.Name.text
														 AptNo:self.AptNum.text
													   Street1:self.Street1.text
													   Street2:self.Street2.text
														  City:self.City.text
														   Tel:self.Telephone.text
														 Email:self.Email1.text]; 
		[Cart addCustomerInfo:infoModel];
	}
	[textFieldArray release];
	   
}
//==============================================================================
-(IBAction)cancelAllButtonPressed 
{
	NSLog(@"cancel all button pressed ");
	[self dismissModalViewControllerAnimated:YES];
	
}

//==============================================================================
-(IBAction)doneButtonPressed //method used by the keyboard when done is pressed
{
	NSLog(@"Done button pressed ");
	NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
	
}
//==============================================================================
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
    
    // Release any cached data, images, etc. that aren't in use.
}
//==============================================================================
- (void)viewDidUnload 
{
    [super viewDidUnload];
		NSLog(@"%s %d %s", __FILE__, __LINE__, __FUNCTION__);
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//==============================================================================

- (void)dealloc 
{
	NSLog(@"deallocating %@",self);
	[scrollView release];
	[UITextFieldInValidity release];
    [super dealloc];
}
//==============================================================================

@end
