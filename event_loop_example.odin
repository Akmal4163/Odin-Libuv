package odin

import "core:fmt"
import uv "libuv"

main :: proc () {
    loop := uv.default_loop()

    defer uv.loop_close(loop)

    fmt.println("uv default loop.....")
    uv.run(loop, uv.uv_run_mode.UV_RUN_DEFAULT)
}

