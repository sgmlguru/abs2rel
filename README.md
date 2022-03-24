# README

This contains code for converting absolute paths to relative ditto. The intended use is to fix path issues in the DITA RNG to DTD converter package that currently doesn't do proper relative paths to modules referenced from a shell (or other module).

Usage:

```XML
sg:abs2rel(path1,path2)
```

The function handles both Windows and Unix paths.
