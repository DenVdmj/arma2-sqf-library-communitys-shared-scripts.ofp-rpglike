strict;
require "all_icons.pl";

open insqf, "../registry.sqf";
open incsv, "../../stringtable.csv";

my %prices;
my %categories;
my %prices_range = (
    W => [500, 14000],
    M => [30, 140],
    V => [500, 200000],
    T => [20, 300]
);

my $category;
for my $line (<insqf>) {
    if ($line =~ /^\s*"(\w+)"/) {
        $category = $1;
        next;
    };
    if ($line =~ /^\s*\["(\w+)"\s*,\s*(\d+)(\s*,\s*(".*?"))?\]/) {
        $prices{$category.":".$1} = $2;
        next;
    };
};

for my $line (<incsv>) {
    for my $category (keys %prices_range) {
        my ($low, $up) = @{$prices_range{$category}};
        my ($price) = $low + abs int rand( $up - $low );
        my ($name) = $line =~ /^STR:\@$category\:(\w+)/;
        $name ne '' && (
            push( @{$categories{$category}}, { name => $name, price => $prices{$category.":".$name} || $price } )
        );
    };
};

close insqf;
close incsv;
open out, "+>../registry.sqf";
my @output;

my %icons = (
   "M" => \%mags,
   "W" => \%weaps,
   "V" => \%vehs,
);

use Data::Dumper;

print Dumper(%icons);

for my $category (keys %categories) {
    push(@output, qq("$category"));
    for my $item (@{$categories{$category}}) {
        my $name = $item->{name};
        my $lcname = lc $name;
        my $ico = %icons->{$category}->{$lcname} || "clear_empty.paa";
        push(@output, qq(\["$name", $item->{price}, "$ico"\]));
    };
};

print out join(",\n", @output);








