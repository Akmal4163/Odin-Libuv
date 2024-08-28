package odin

import "core:fmt"
import uv"libuv"

counter: i64 = 0

wait_for_a_while::proc "cdecl" (handle: ^uv.uv_idle_t) {

    counter += 1
    if(counter >= 10e6) {
        uv.idle_stop(handle)
    }
}

main::proc() {
    
    idler: uv.uv_idle_t
    uv.idle_init(uv.default_loop(), &idler)
    uv.idle_start(&idler, wait_for_a_while)

    defer uv.loop_close(uv.default_loop())

    fmt.println("Idling...\n")
    uv.run(uv.default_loop(), uv.uv_run_mode.UV_RUN_DEFAULT)
}