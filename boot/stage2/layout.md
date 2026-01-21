# TRBLOS

## Disk Layout (TRBL-OS)

### Sector 0

- Stage1 (512 bytes)

### Sector 1

- Stage2 REAL (real mode loader)

### Sector 2

- Stage2 PM (protected mode code)

### Notes

- Stage1 loads sector 1 → 0x1000
- Stage2 REAL loads sector 2 → 0x2000
- Stage2 REAL jumps to PM explicity.

## STAGE2 CONTRACT

### Stage1

- Loads sector 1 → 0x1000
- Jumps to 0x0000:0x1000

### Stage2 REAL

- Runs in real mode
- Enables A20
- Loads GDT
- Switches to protected mode
- Far jump to stage2_pm

### Stage2 PM

- Assumes:
  - Protected mode active
  - CS = 0x08
  - Flat memory model
- Responsible for:
  - Stack
  - Segments
  - Next stages (kernel)
