#import "customTableCell2.h"

@implementation customTableCell2

@synthesize itemName;
@synthesize itemPrice;
@synthesize sides;
@synthesize ViewForBackground;
@synthesize indexPathForCell;
@synthesize leftSides;
@synthesize Total;
@synthesize TotalEditable;
@synthesize dollarTop;
@synthesize dollarMid;
@synthesize dollarLow;

//==============================================================================
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
	 
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
    [itemName release];
	[itemPrice release];
	[sides release];
	[leftSides release];
	[Total release];
	[TotalEditable release];
	[ViewForBackground release];
	[indexPathForCell release];
	[dollarTop release];
	[dollarMid release];
	[dollarLow release];
	
	[super dealloc];
}


@end
