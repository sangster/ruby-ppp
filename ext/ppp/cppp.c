#include "ruby.h"
#include "ppp.h"

static VALUE t_init( VALUE self );
static VALUE t_random_key( VALUE self );
static VALUE t_key_from_string( VALUE self, VALUE str );
static VALUE t_get_passcodes( VALUE self, VALUE v_key, VALUE v_offset, VALUE v_count, VALUE v_length, VALUE v_alphabet );

VALUE cPpp;

void Init_Cppp()
{
    cPpp = rb_define_class( "Cppp", rb_cObject );
    rb_define_module_function( cPpp, "random_key", t_random_key, 0 );
    rb_define_module_function( cPpp, "key_from_string", t_key_from_string, 1 );
    rb_define_module_function( cPpp, "passcodes", t_get_passcodes, 5 );
}

static VALUE key_to_string( SequenceKey * sequenceKey )
{
    int i;
    char str[ 70 ], pair[ 3 ];
    bzero( str, sizeof(str) );

    for( i = 0; i < SHA256_DIGEST_SIZE; ++i )
    {
        sprintf( pair, "%2.2x", sequenceKey->byte[ i ] );
        strcat( str, pair );
    }

    return rb_str_new2( str );
}

static VALUE t_random_key( VALUE self )
{
    SequenceKey key;
    GenerateRandomSequenceKey( &key );
    return key_to_string( &key );
}

static VALUE t_key_from_string( VALUE self, VALUE str )
{
    SequenceKey key;

    GenerateSequenceKeyFromString( StringValueCStr( str ), &key );
    return key_to_string( &key );
}

static VALUE t_get_passcodes( VALUE self, VALUE v_key, VALUE v_offset, VALUE v_count, VALUE v_length, VALUE v_alphabet )
{
    SequenceKey key;
    ConvertHexToKey( StringValueCStr( v_key ), &key );

    int offset = FIX2INT( v_offset );
    int count = FIX2INT( v_count );
    int length = FIX2INT( v_length );

    char *alphabet = StringValueCStr( v_alphabet );

    OneTwoEight firstPasscode;
    firstPasscode.sixtyfour.low = offset;
    firstPasscode.sixtyfour.high = 0;

    char * pcl = RetrievePasscodes( firstPasscode, count, &key, alphabet, length );
    char * to_free = pcl;

    VALUE arr = rb_ary_new();

    int i;
    for( i = 0; i < count; ++i )
    {
        rb_ary_push( arr, rb_str_new( pcl, length ) );
        pcl += length + 1;
    }

    free( to_free );

    return arr;
}
