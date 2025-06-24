# ChatRewind

Remember that stream you watched some time ago and absolutely loved? Someone probably archived it, and it's somewhere in YouTube. But one essential part of it is *gone forever* now. **The chat.**

Twitch stores streams for *up to 2 weeks* for non-partners and *3 months* for partners. Recently, a limit was put on highlights as well by the *absolutely tiny, unsustainable* company that is Amazon.

**I want to _end this up_.** If we archive a stream, not only the video must be archived but the full thing, chat included. ChatRewind is a _—by the moment—_ Mac-only app that aims to make Twitch chat archive and playback easy.

> [!WARNING]
> THIS AIN'T EVEN A BETA. I'm just publishing this to have something here. THIS IS VERY WIP. Bugs, crashes, overall incompleteness… That's the definition of this app. I just started it some days ago as a side project at the time of writing this. Please, be patient.

## Features

* Play back locally downloaded chat logs.
* Natively compatible with 7TV emotes.
* Feels native to macOS.
* [COMING SOON] Download chat logs directly from the app.
* Also in Spanish.

## Known Issues

* The chat desyncs after some time as the internal clock doesn't count time correctly for some reason (it's a f\*\*\*ing clock, that's the only reason for its existence).

## FAQ

### Where do I get the chat logs?

ChatRewind uses CSV files, following a similar format to what [twitchchatdownloader.com](https://www.twitchchatdownloader.com) uses. Just bear in mind that the files that tool provides are sometimes not correctly formatted, and you may need to open them in Excel or something like that and manually fix some stuff for it to work. It's an OK approach until I add direct downloading to the app.

### Why Mac-only?

It's what I know how to work with. I may make a Windows version in the future, especially if Microsoft makes Windows development not suck a\*\* like it did the last time I tried it.

#### But web apps exist!

I personally hate web apps. And I made this for me. I'm sorry if it doesn't work for you.

### 7TV doesn't work

First, if you built the app yourself, you may need to add your Twitch API credentials to the Secrets file.

```
// ./Secrets.xcconfig

TWITCH_CLIENT_ID = y0urc1i3ntid
TWITCH_CLIENT_SECRET = y0urcl1ent5ecr3t
```

Second, you may need to add a header row at the start of the file like this one:

```
meta,stream_name=My Stream Name,channel_name=MyChannel
```
