
extern "C" int main() {
    const  short color = 0x0200;
    const short color_b = 0x4000;
    const char* hello = "Hello cpp world!";

    short* vga_adress =  (short*)0xb8000;

    for (int i = 0; i < 16; i++) {
        vga_adress[i+80] = color | hello[i] | color_b;
    }

    return 0;
}
