// main.rs

#![no_std]
#![no_main]

mod vga_buffer;
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}


#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {

    use core::fmt::Write;
    vga_buffer::WRITER.lock().write_str("Hello World!").unwrap();

    loop{}

}