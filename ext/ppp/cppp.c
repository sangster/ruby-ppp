#include "ruby.h"
#include "ppp.h"

static VALUE t_init( VALUE self );
static VALUE t_random_key( VALUE self );

VALUE cPpp;

void Init_Cppp()
{
    cPpp = rb_define_class( "Cppp", rb_cObject );
    rb_define_module_function( cPpp, "random_key", t_random_key, 0 );

    rb_define_method( cPpp, "initialize", t_init, 0 );
}

static VALUE t_init( VALUE self )
{
    return self;
}

static VALUE t_random_key( VALUE self )
{
    SequenceKey key;
    int i;
    char str[ 256 ], pair[ 3 ];

    GenerateRandomSequenceKey( &key );

    for( i = 0; i < SHA256_DIGEST_SIZE; ++i )
    {
        sprintf( pair, "%2.2x", key.byte[ i ] );
        strcat( str, pair );
    }

    return rb_str_new2( str );
    return Qnil;
}
