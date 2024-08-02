package main

import "core:fmt"

counter: i64 = 0

wait_for_a_while::proc "cdecl" (handle: ^uv_idle_t) {

    counter += 1
    if(counter >= 10e6) {
        idle_stop(handle)
    }
}

main::proc() {
    
    idler: uv_idle_t
    idle_init(default_loop(), &idler)
    idle_start(&idler, wait_for_a_while)

    fmt.println("Idling...\n")
    run(default_loop(), uv_run_mode.UV_RUN_DEFAULT)

    loop_close(default_loop())

}