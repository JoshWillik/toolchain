#! /usr/bin/env python3
import sys
import re
import json

KEY_REGEX = re.compile( '((?:[A-Z]|^[a-z])[^A-Z]*)' )

def get_input():
    input_string = ''
    if sys.stdin.isatty():
        return None
    for line in sys.stdin.readlines():
        input_string += line
    return input_string

def generate_exports( data ):
    exports = []
    for key, value in data.items():
        new_key = bashify_key( key, KEY_REGEX )
        exports.append((new_key, value))
    return exports

def format_exports( exports ):
    new_pairs = [ 'export ' + a + '="' + stringify_value(b) + '"' for a, b in exports ]
    return new_pairs

def bashify_key( key, regex ):
    return '_'.join( [ x.upper() for x in regex.findall( key ) ] )

def stringify_value( value ):
    if value is True:
        return 'true'
    if value is False:
        return 'false'
    return str( value )

def main():
    rawJson = get_input()
    if rawJson is None:
        return print( '# No exports have been created' )

    try:
        data = json.loads( rawJson )
    except Exception as e:
        print( e )
        return print( '# There was an error parsing the provided json' )

    exports = generate_exports( data )
    print( "\n".join( format_exports( exports ) ) )

if __name__ == '__main__': main()
