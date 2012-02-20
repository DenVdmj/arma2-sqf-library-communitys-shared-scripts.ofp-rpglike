
open insqf, "register.sqf";
open incsv, "../stringtable.csv";

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
    print "123";
    if ($line =~ /^\s*"(\w+)"/) {
        print "2";
        $category = $1;
        next;
    };
    if ($line =~ /^\s*\["(\w+)"\s*,\s*(\d+)(\s*,\s*(".*?"))?\]/) {
        print "1";
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
open out, "+>register.sqf";
my @output;

for my $category (keys %categories) {
    push(@output, qq("$category"));
    for my $item (@{$categories{$category}}) {
        push(@output, qq(\["$item->{name}", $item->{price}\]));
    };
};

print out join(",\n", @output);
