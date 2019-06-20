# dubloons

## Structure

1. API socket
2. Listener to Discord bot

## Commands

### help

Aliases: ?, what can I say, what can you do, yaharr

Returns: this whole help screen

### audio

Aliases: music, beats, track, tracks

Parameters: Search String

Returns: Numbered list of results with name

Sets state: Results, type

### video

Aliases: video, videos movie, movies

Parameters: Search String

Returns: Numbered list of results with name

Sets state: Results, type

### software

Aliases: program, programme, programs, programmes

Parameters: Search String

Returns: Numbered list of results with name

Sets state: Results, type

### search

Aliases: search

Parameters: Search String

Returns: Numbered list of results with name and type

Sets state: Results

### [Number]

Only when (errors without): State has results

Aliases: download #, get #

(Self-parameter)

Returns: download ID, name of download

Side effect: gets type from ID, starts download in [state type] folder, clears results and type state, adds a notification for when the download has finished.

### downloads

Aliases: list, !, status, progress

Parameter: download ID (optional)

Returns: [{download ID, name, percentage completion}]

### stop

Parameter: download ID (required)

Side effect: stops download with ID

### start

Parameter: download ID (required)

Side effect: starts download with ID

### remove

Parameter: download ID (required)

Side effect: removes files from download with ID

### settings

Aliases: show, set with no param

Returns: all settings

### set

Parameters: id, value

Side effect: set option

### get

Parameters: id

Returns: setting
