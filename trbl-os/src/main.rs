// main.rs

#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// Serial port COM1 (0x3F8) output
fn serial_write_byte(byte: u8) {
    unsafe {
        // Wait for transmit buffer to be empty
        loop {
            let status = core::ptr::read_volatile(0x3FD as *const u8);
            if (status & 0x20) != 0 {
                break;
            }
        }
        // Send byte
        core::ptr::write_volatile(0x3F8 as *mut u8, byte);
    }
}

fn serial_write_str(s: &str) {
    for byte in s.bytes() {
        if byte == b'\n' {
            serial_write_byte(b'\r');
        }
        serial_write_byte(byte);
    }
}

static HELLO: &[u8] = b"Hello World";

#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    // Write to serial port
    serial_write_str("TRBL-OS Kernel Started!\n");
    serial_write_str("Writing to VGA buffer...\n");
    
    let vga_buffer = 0xb8000 as *mut u8;

    for (i, &byte) in HELLO.iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = 0xb;
        }
    }
    
    serial_write_str("VGA buffer written successfully!\n");
    serial_write_str("Kernel halting...\n");

    loop {}
}
