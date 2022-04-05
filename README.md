## ippm

Simple bash script to handle Lenovo Ideapad 5 Pro 
14ACN06 performance mode via ACPI.

Note that `acpi_call` kernel module should be installed.

### Usage

```bash
# ippm [set/get] [cm/rc/perf] [num]
```

#### Conservation mode

```bash
# ippm get cm
0
# ippm set cm [0/1]
```

#### Rapid charge

Is not compatible with conservation mode and vice versa.

```bash
# ippm get rc
1
# ippm set rc [0/1]
```

#### Performance mode

One of:

- `0` - performance
- `1` - power save
- `2` - intelligence cooling

```bash
# ippm get perf
2
# ippm set perf [0/1/2]
```

#### polybar

`polybar-ippm.sh` script can be used with polybar as follows:

```ini
[module/ippm]
type = custom/ipc

; Define the command to be executed when the hook is triggered
; Available tokens:
;   %pid% (id of the parent polybar process)
hook-0 = polybar-ippm

; Hook to execute on launch. The index is 1-based and using
; the example below (2) `whoami` would be executed on launch.
; If 0 is specified, no hook is run on launch
; Default: 0
initial = 1

; Mouse actions
; Available tokens:
;   %pid% (id of the parent polybar process)
click-left = polybar-ippm next
```
