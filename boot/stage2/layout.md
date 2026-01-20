# Disk Layout (TRBL-OS)

## Sector 0

- Stage1 (512 bytes)

## Sector 1

- Stage2 REAL (real mode loader)

## Sector 2

- Stage2 PM (protected mode code)

## Notes

- Stage1 loads sector 1 → 0x1000
- Stage2 REAL loads sector 2 → 0x2000
- Stage2 REAL jumps to PM entry explicitly
