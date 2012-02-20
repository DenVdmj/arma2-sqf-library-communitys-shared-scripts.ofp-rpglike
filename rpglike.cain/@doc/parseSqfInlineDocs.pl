
my $sqfFileContent;
{
    local *hndlOutFile;
    open(hndlOutFile, "init.sqf") or die;
    read(hndlOutFile, $sqfFileContent, -s hndlOutFile) or die;
    close(hndlOutFile);
};

print "\n---sqf---\n";

while ( $sqfFileContent =~ m<\n//(\s+)?(?:(?:Функция|function)\s+)?((func\w+).*?)\n\s*\3\s*\=\s*{>gcis ) {
    my $padding = $1;
    my $text = $2;
    $text =~ s{\n//$padding?}{\n}g;
    $text =~ s{(//|\s)+$}{}g;
    my $textFunction = $text =~ /[а-яА-Я]/ ? "Функция" : "Function";
    print "$textFunction $text\n\n" . "-" x 80 . "\n";
};

print "-" x 80 . "\n";

{
    local *hndlOutFile;
    open(hndlOutFile, "init.sqf") or die;
    read(hndlOutFile, $sqfFileContent, -s hndlOutFile) or die;
    close(hndlOutFile);
};

#print $sqfFileContent;

while ( $sqfFileContent =~ m<\n/\*\n*(\s+)?(?:(?:Функция|function)\s+)?((func\w+).*?)\n\*/\s*\3\s*\=\s*{>gcis ) {
    my $padding = $1;
    my $text = $2;
    $text =~ s{\n$padding}{\n}g;
    $text =~ s{\s+$}{}g;
    my $textFunction = $text =~ /[а-яА-Я]/ ? "Функция" : "Function";
    print "$textFunction $text\n\n" . "-" x 80 . "\n";
};

