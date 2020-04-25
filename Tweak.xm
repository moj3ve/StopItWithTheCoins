
@interface AwardedCommentHighlightNode
 : UIView
@end

%hook MainTabBarController

-(void) addCoinSaleButton{}

%end

%hook CoinSaleEntryContainer

-(void) showSaleBadge:(BOOL) arg1{}

-(id) coinSaleButton{
	return nil;
}

-(id) init{
	return nil;
}

-(id) initWithFrame:(CGRect) arg1{
	return nil;
}

+(CGFloat) coinIconSize{
	return 0;
}

%end

%hook RoundedHighlightView

-(id) highlightColor{
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

-(void) setHighlightColor:(id) arg1{
	%orig([UIColor colorWithRed:0 green:0 blue:0 alpha:0]);
}

%end

%hook AwardedCommentHighlightNode

-(void) layoutSubviews{
	%orig;

	[self setHidden:YES];
}

%end

%ctor{
	%init(RoundedHighlightView = objc_getClass("Reddit.RoundedHighlightView"), AwardedCommentHighlightNode = objc_getClass("_TtCC6Reddit27AwardedCommentHighlightNode13HighlightView"), CoinSaleEntryContainer = objc_getClass("Reddit.CoinSaleEntryContainer"))
}