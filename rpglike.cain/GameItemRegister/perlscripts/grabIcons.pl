use strict;

use ARMA::Config::Parser;
use Data::Dumper;

my $gameConfig = ARMA::Config::Parser->new();

$gameConfig->parse(shift);

my $OFPIcons = {
    CfgWeapons => {},
    CfgVehicles => {},
};

#print Dumper( $gameConfig->class()->{"CfgWeapons"} );

$gameConfig->class()->{"CfgWeapons"}->forClasses(sub{
    my $class = $_[0];
    return unless $class->prop();
    my $className = $class->name();
    my $picture = $class->prop()->{"picture"};
    my $uiPicture = $class->prop()->{"uiPicture"};
    $picture = $picture->value() if $picture;
    $uiPicture = $uiPicture->value() if $uiPicture;

    return unless $uiPicture || $picture;

    $OFPIcons->{"CfgWeapons"}->{$className} = {
        picture => $picture,
        uiPicture => $uiPicture,
    };
});

print Dumper($OFPIcons);

#$gameConfig->print_tree();
