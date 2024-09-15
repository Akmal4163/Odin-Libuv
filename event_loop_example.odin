package main

import "core:fmt"
import uv "libuv"

main :: proc () {
    loop := uv.default_loop()

    defer uv.loop_close(loop)

    fmt.println("uv default loop.....")
    uv.run(loop, uv.run_mode.RUN_DEFAULT)
}

