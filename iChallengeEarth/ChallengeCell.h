#import <UIKit/UIKit.h>


@interface ChallengeCell : UITableViewCell 
{
	IBOutlet UILabel *challengeTitle;
	IBOutlet UILabel *challengeCategorie;
	IBOutlet UIImageView *challengeDifficulty;
    IBOutlet UIImageView *challengeImage;
}

@property (nonatomic,strong) UILabel *challengeTitle;
@property (nonatomic,strong) UILabel *challengeCategorie;
@property (nonatomic,strong) UIImageView *challengeDifficulty;
@property (nonatomic,strong) UIImageView *challengeImage;

@end
