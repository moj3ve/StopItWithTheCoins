

static BOOL isEnabled;
static BOOL isCommentHighlightHidden;
static BOOL isSearchCoinButtonHidden;
static BOOL isUserDrawerPremiumHidden;
static BOOL isGildingButtonHidden;


/* ---- User Drawer Premium Cells ---- */


@interface BaseTableView : UITableView
@end

@interface UserDrawerViewController
@property(strong, nonatomic) BaseTableView *actionsTableView;
@end

%hook UserDrawerViewController

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2{
	
	if (arg1 == [self actionsTableView]){
		
		id cell = %orig;
		NSString *cellText = [cell detailTextLabel].text;
		
		if (isUserDrawerPremiumHidden){
			if ([cellText isEqualToString:NSLocalizedString(@"userDrawer.menu.premiumSubTitle",nil)] || [cellText isEqualToString:NSLocalizedString(@"userDrawer.menu.coinsSubTitle",nil)]){
				[cell detailTextLabel].text = nil;
			}
		}
		
		return cell;
		
	} else {
		return %orig;
	}
}

- (NSMutableArray *)availableUserActions{
	NSMutableArray *orig = %orig;
	
	if (isUserDrawerPremiumHidden){
		[orig removeObject:@6];
		[orig removeObject:@7];
	}
	
	return orig;
} 

%end


/* ---- Post and Comment Gilding Buttons ---- */


%hook CommentTreeCommandBarNode

- (id)awardButtonNode{
	return isGildingButtonHidden ? nil : %orig;
}

- (void)setAwardButtonNode:(id)arg1{
	%orig(isGildingButtonHidden ? nil : arg1);
}

%end

%hook FeedPostCommentBarNode

- (id)awardButtonNode{
	return isGildingButtonHidden ? nil : %orig;
}

- (void)setAwardButtonNode:(id)arg1{
	%orig(isGildingButtonHidden ? nil : arg1);
}

%end


/* ---- Search Bar Coins Button ---- */


@interface AwardedCommentHighlightNode : UIView
@end

%hook MainTabBarController

- (void)addCoinSaleButton{
	if (!isSearchCoinButtonHidden){
		%orig;
	}
}

%end

%hook CoinSaleEntryContainer

- (void)showSaleBadge:(BOOL) arg1{
	if (!isSearchCoinButtonHidden){
		%orig;
	}
}

- (id)coinSaleButton{
	return isSearchCoinButtonHidden ? nil : %orig;
}

- (id)init{
	return isSearchCoinButtonHidden ? nil : %orig;
}

- (id)initWithFrame:(CGRect) arg1{
	return isSearchCoinButtonHidden ? nil : %orig;
}

+ (CGFloat)coinIconSize{
	return isSearchCoinButtonHidden ? 0 : %orig;
}

%end


/* ---- Awarded Comments Highlight ---- */


%hook RoundedHighlightView

- (id)highlightColor{
	return isCommentHighlightHidden ? [UIColor colorWithRed:0 green:0 blue:0 alpha:0] : %orig;
}

- (void)setHighlightColor:(id) arg1{
	%orig(isCommentHighlightHidden ? [UIColor colorWithRed:0 green:0 blue:0 alpha:0] : arg1);
}

%end

%hook AwardedCommentHighlightNode

- (void)layoutSubviews{
	%orig;
	
	if (isCommentHighlightHidden){
		[self setHidden:YES];
	}
}

%end

%hook CommentTreeContentNode

- (void)createHighlightNode{
	if (!isCommentHighlightHidden){
		%orig;
	}
}

- (id)roundedHighlightNode{
	return isCommentHighlightHidden ? nil : %orig;
}

- (void)updateAwardsHighlight{
	if (!isCommentHighlightHidden){
		%orig;
	}
}

%end

%hook CommentTreeNodeOptions

- (BOOL)shouldHighlightBackground{
	return isCommentHighlightHidden ? NO : %orig;
}

- (void)setShouldHighlightBackground:(BOOL)arg1{
	%orig(isCommentHighlightHidden ? NO : arg1);
}

- (BOOL)shouldHighlightBasedOnAwards{
	return isCommentHighlightHidden ? NO : %orig;
}

- (void)setShouldHighlightBasedOnAwards:(BOOL)arg1{
	%orig(isCommentHighlightHidden ? NO : arg1);
}
%end


/* ---- Setup ---- */


static void loadPrefs(){
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lint.stopitwiththecoins.prefs.plist"];
	
	if (prefs){
		
		if ([prefs objectForKey:@"isEnabled"] != nil){
			isEnabled = [[prefs objectForKey:@"isEnabled"] boolValue];
		} else {
			isEnabled = YES;
		}
		
		if ([prefs objectForKey:@"isCommentHighlightHidden"] != nil){
			isCommentHighlightHidden = [[prefs objectForKey:@"isCommentHighlightHidden"] boolValue];
		} else {
			isCommentHighlightHidden = YES;
		}
		
		if ([prefs objectForKey:@"isSearchCoinButtonHidden"] != nil){
			isSearchCoinButtonHidden = [[prefs objectForKey:@"isSearchCoinButtonHidden"] boolValue];
		} else {
			isSearchCoinButtonHidden = YES;
		}
		
		if ([prefs objectForKey:@"isUserDrawerPremiumHidden"] != nil){
			isUserDrawerPremiumHidden = [[prefs objectForKey:@"isUserDrawerPremiumHidden"] boolValue];
		} else {
			isUserDrawerPremiumHidden = YES;
		}
		
		if ([prefs objectForKey:@"isGildingButtonHidden"] != nil){
			isGildingButtonHidden = [[prefs objectForKey:@"isGildingButtonHidden"] boolValue];
		} else {
			isGildingButtonHidden = YES;
		}
		
	} else {
		isEnabled = YES;
		isCommentHighlightHidden = YES;
		isSearchCoinButtonHidden = YES;
		isUserDrawerPremiumHidden = YES;
		isGildingButtonHidden = YES;
	}	
}


%ctor{
	loadPrefs();
	
	if (isEnabled){
		%init(RoundedHighlightView = objc_getClass("Reddit.RoundedHighlightView"), AwardedCommentHighlightNode = objc_getClass("_TtCC6Reddit27AwardedCommentHighlightNode13HighlightView"), CoinSaleEntryContainer = objc_getClass("Reddit.CoinSaleEntryContainer"));
	}
}