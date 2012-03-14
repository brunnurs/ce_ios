
@interface ChallengeList : NSObject 
{
    NSArray *items;
}

@property (nonatomic,strong) NSArray *items;

-(void)loadChallengeImages;

@end
