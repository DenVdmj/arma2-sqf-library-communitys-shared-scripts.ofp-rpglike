require 'std.pl';

my $sourcefilename = shift;
my $targetfilename = shift;
my $text = readfile($sourcefilename);


$text =~ s{^(\s*)(\w+)\s*=\s*"([\d\s\(\)\.\*\/\+\-]+)"\s*;\s*$}{
    cnvLine($&, $1, $2, $3);
}egim;

writefile($targetfilename, $text);


sub cnvLine {
    my ($oldline, $indent, $propname, $strvalue) = @_;
    return $oldline if $propname =~ /(startDate|format\w)/;
    $strvalue =~ s/\s+//g;
    $newline1 = qq($indent$propname = "$strvalue";);
    my $result = eval($strvalue);
    unless (defined $result) {
        print "\n>> Error: $@ <$newline1>\n";
    };

    my $newline2 = qq($indent$propname = $result;);

    my $newline = defined $result ? $newline1 : $newline2;
    print qq(\n--replace--\n$oldline\n$newline1\n$newline2);

    return $newline;
}