package Net::Easypost::Resource;

use Moo::Role;

use Carp qw(croak);
use Net::Easypost::Request;

# all Net::Easypost::Resource objects must implement clone and serialize
requires qw(serialize clone);

has id => (
   is => 'rwp',
);

has 'operation' => (
   is      => 'ro',
   builder => 1,
);

has 'role' => (
   is      => 'ro',
   builder => 1,
);

has 'fieldnames' => (
   is      => 'ro',
   builder => 1,
);

has 'requester' => (
   is      => 'ro',
   default => sub { Net::Easypost::Request->new },
);

1;

__END__ 

=pod 

=head1 NAME 

Net::Easypost::Resource

=head1 SYNOPSIS

=head1 ATTRIBUTES

=over 4 

=item id

A unique field that represent this Object to Easypost

=item endpoint

base API operation endpoint for this Object

=item role

Role of this object: address, shipment, parcel, etc...

=item fieldnames

attributes of this Object in the Easypost API

=item requester

HTTP client to make GET & POST requests

=back 

=cut 
