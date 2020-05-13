#!/usr/bin/env python3

import sys
import dbus
import argparse


parser = argparse.ArgumentParser()
parser.add_argument(
    '-t',
    '--trunclen',
    type=int,
    metavar='trunclen'
)
parser.add_argument(
    '-f',
    '--format',
    type=str,
    metavar='custom format',
    dest='custom_format'
)

args = parser.parse_args()

# Default parameters
output = '{artist}: {song}'
trunclen = 25

# parameters can be overwritten by args
if args.trunclen is not None:
    trunclen = args.trunclen
if args.custom_format is not None:
    output = args.custom_format

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        'org.mpris.MediaPlayer2.spotify',
        '/org/mpris/MediaPlayer2'
    )

    spotify_properties = dbus.Interface(
        spotify_bus,
        'org.freedesktop.DBus.Properties'
    )

    metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

    artist = metadata['xesam:artist'][0]
    song = metadata['xesam:title']

    if len(song) > trunclen:
        song = song[0:trunclen]
        song += '...' 
        if ('(' in song) and (')' not in song):
            song += ')'
    
    # Python3 uses UTF-8 by default. 
    if sys.version_info.major == 3:
        output = output.format(artist=artist, song=song)
        print(output)
        with open("/home/fratajcz/.config/polybar/scripts/spotify/oldsong", 'w') as f:
            f.write(output);


except Exception:
    with open("/home/fratajcz/.config/polybar/scripts/spotify/oldsong", 'r') as f:
        print(f.readline())

