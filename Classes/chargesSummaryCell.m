#import "chargesSummaryCell.h"

@implementation chargesSummaryCell

@synthesize view;
@synthesize leftLabel;
@synthesize rightLabel;
@synthesize addButton;
@synthesize parentTableVC;
@synthesize indexPathForCell;
@synthesize dollarSign;
@synthesize LocationLabel;

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
        // Initialization code.
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
	[view release];
	[leftLabel release];
	[rightLabel release];
	[addButton release];
	[indexPathForCell release];
	[dollarSign release];
	
    [super dealloc];
}


@end
