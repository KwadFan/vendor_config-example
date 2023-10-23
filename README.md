# vendor_config-example

"Hello World" for vendor_config module MainsailOS buildchain

The name of your repo doesnt matter, but it should be "cloned" inside

```bash
~/printer_data/config
```

So, for manual testing and/or developing do

```bash
cd ~/printer_data/config
git clone https://github.com/KwadFan/vendor_config-example
```

this will ensure you can easily reach contents from within mainsail (or fluidd) ...

Again, this is only an "Hello World" Repo. It actually builds the `linux-host-mcu` (the one who is used for Input Shaper and a ADXL on connected to your pi) and
Also the firmware for a `BTT SKR pico V1.0` will be compiled.
If that is done it will copy the output file to the appropriate folder.

The directory structure is also up to you but my thought was here, it should really describe what it contains, this will be easier for 'non-techsave' users ...

---

This is only part of a "Hello vendor_config" example,
write down what ever you want to tell the user ...
