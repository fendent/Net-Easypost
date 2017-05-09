package Net::Easypost::Request;

use Moo;

use Carp qw(croak);
use HTTP::Tiny;
use JSON::MaybeXS qw(decode_json);

has 'user_agent' => (
    is      => 'ro',
    default => sub { HTTP::Tiny->new( agent => 'Net-Easypost ' ) },
);

has 'endpoint' => (
    is      => 'ro',
    default => 'api.easypost.com/v2',
);

sub post {
    my ($self, $operation, $params) = @_;

    my $http_response = $self->user_agent->post_form(
       $self->_build_url($operation), $params,
    );

    unless ( $http_response->{success} ) {
        my ($err, $code) = map { $http_response->{$_} } qw(reason response);
        croak $code
           ? "FATAL: " . $self->endpoint . $operation . " returned $code: '$err'"
           : "FATAL: " . $self->endpoint . $operation . " returned '$err'";
    }

    return decode_json $http_response->{content};
}

sub get {
    my ($self, $endpoint) = @_;

    $endpoint = $self->_build_url($endpoint)
        unless $endpoint =~ m/https?/;

    my $http_response = $self->user_agent->get( $endpoint );
    return lc $http_response->{headers}->{'content-type'} =~ m|^\Qapplication/json\E|
       ? decode_json $http_response->{content}
       : $http_response->{content};
}

sub _build_url {
    my ($self, $operation) = @_;

    return 'https://' . $ENV{EASYPOST_API_KEY} . ':@' . $self->endpoint . $operation
        if exists $ENV{EASYPOST_API_KEY};

    croak 'Cannot find API key in access_code attribute of Net::Easypost'
        . ' or in an environment variable name EASYPOST_API_KEY';
}

1;

__END__

=pod

=head1 NAME

Net::Easypost::Request

=head1 SYNOPSIS

Net::Easypost::Request->new

=head1 ATTRIBUTES

=over 4

=item user_agent

A user agent attribute. Defaults to L<Mojo::UserAgent>.

=item endpoint

The Easypost service endpoint. Defaults to 'https://api.easypost.com/v2'

=back

=head1 METHODS

=over 4

=item _build_url

Given an operation, constructs a valid Easypost URL using the specified
EASYPOST_API_KEY

=item post

This method uses the C<user_agent> attribute to generate a form post request. It takes
an endpoint URI fragment and the parameters to be sent.  It returns JSON deserialized
into Perl structures.

=item get

This method uses the C<user_agent> attribute to generate a GET request to an endpoint. It
takes a complete endpoint URI as its input and returns a L<Mojo::Message::Response>
object.

=back

=cut
