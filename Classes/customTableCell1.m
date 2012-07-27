#import "customTableCell1.h"

@implementation customTableCell1
@synthesize locationLabel;
@synthesize ItemPrice;
@synthesize CityName;
@synthesize AddToCartBtn;
@synthesize AddSidesToCartBtn;
@synthesize parentTableVC;
@synthesize indexPathForCell;
@synthesize ItemCategory;
@synthesize ItemDescription;
@synthesize ItemMisc;
@synthesize sidesButton;
@synthesize isSelected;
@synthesize thumbImage;
@synthesize foodItemLabel;
@synthesize dollar;
//==============================================================================
-(IBAction) addCartButtonClicked: (UIButton*)addBtn
{
	NSLog(@"CustomCell sending to parentViewController = %@", self.parentTableVC);
	NSLog(@"CustomCell sending indexpath = %@", self.indexPathForCell);
	[parentTableVC customCellAddButnClicked: self.indexPathForCell withTag:addBtn.tag];	
}
//==============================================================================
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
       	 
	 [AddToCartBtn addTarget:self.parentTableVC
					  action:@selector(customCellAddButnClicked:)
			forControlEvents: UIControlEventTouchUpInside];
	  
    }
    return self;
}
//==============================================================================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}
//==============================================================================

- (void)dealloc 
{
	[locationLabel release];
	[ItemPrice release];
	[CityName release];
	[AddToCartBtn release];
	[AddSidesToCartBtn release];
	
	[indexPathForCell release];
	[ItemCategory release];
	[ItemDescription release];
	[ItemMisc release];
	[sidesButton release];
	
	[thumbImage release];
	[foodItemLabel release];
	[dollar release];

    [super dealloc];
}




@end
