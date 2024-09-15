package main

import "core:fmt"
import uv"libuv"

counter: i64 = 0

wait_for_a_while::proc "cdecl" (handle: ^uv.idle_t) {

    counter += 1
    if(counter >= 10e6) {
        uv.idle_stop(handle)
    }
}

main::proc() {
    
    idler: uv.idle_t
    uv.idle_init(uv.default_loop(), &idler)
    uv.idle_start(&idler, wait_for_a_while)

    defer uv.loop_close(uv.default_loop())

    fmt.println("Idling...\n")
<<<<<<< HEAD
    uv.run(uv.default_loop(), uv.run_mode.RUN_DEFAULT)
}
=======
    uv.run(uv.default_loop(), uv.uv_run_mode.UV_RUN_DEFAULT)
}
>>>>>>> 2fa9f92b4aa0ebb296ab762eabc5b16b8215cb57
