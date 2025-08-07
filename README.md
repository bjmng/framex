# framex
Frame eXtension for the VLC Media Player.

## About
A lightweight, yet powerful lua script that adds frame handling to
the VLC Media Player. It is capable of automatically detecting the
frame rate and time and calculating the current frame. Further it
provides additional playback controls.

## Language Support
To change the extension language beforehand, edit the line
`local i18n = { language = "en" }`. Supported languages are:
`"en"`, `"de"`.

> [!IMPORTANT]
> The extension language has to match the interface language.

## Installation
Copy the file `framex.lua` into following directory:

| OS      | Directory |
|---------|-----------|
| Windows |           |
| Linux   |           |
| OSX     |           |

If the directory does not exist, create it first. To take effect,
restart VLC.

> [!TIP]
> You could symlink the file into the directory.

