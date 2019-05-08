Format description
==================

Offset | Length      | Type    | Value
-------|-------------|---------|----------------------
0      | 0x13        | string  | `UVWIN SPECSCAN FILE`
0x14   | 0x8 .. 0xf? | string  | column name, ANSI
0x61   | 0xd .. 0xf? | string  | user name
0x258  | 0x14?       | string  | previous file name, ANSI
0x365  | 0x16?       | string  | measurement type, ANSI
0x3a5  | 0xf?        | string  | device serial number
0x400  | 0x2         | integer | number of wavelength-value pairs
0x405  | 0x8 * 2 * n | double  | wavelength-value pair
