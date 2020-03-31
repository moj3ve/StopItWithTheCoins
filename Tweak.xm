
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

%ctor{

	%init(_ungrouped, CoinSaleEntryContainer = objc_getClass("Reddit.CoinSaleEntryContainer"));

}