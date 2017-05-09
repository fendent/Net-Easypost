requires "HTTP::Tiny" => "0.054";
requires "Hash::Merge::Simple" => "0.051";
requires "IO::Socket::SSL" => "1.962";
requires "JSON::MaybeXS" => "1.003009";
requires "Mojolicious" => "4.66";
requires "Moo" => "1.004002";
requires "Types::Standard" => "0.040";
requires "perl" => "5.014";

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};
