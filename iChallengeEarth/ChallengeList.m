

#import "ChallengeList.h"
#import "Challenge.h"
#import "AchievmentDescription.h"
#import "Image.h"


@implementation ChallengeList
@synthesize items;

-(void)loadChallengeImages{
    for (Challenge *c in items) {
        [c.achievmentDesc.image loadImage];
    }
}

@end
