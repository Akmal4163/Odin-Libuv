package libuv

import "core:fmt"

main::proc() {

    loop: ^uv_loop_t = default_loop()

    defer loop_close(loop)
    //defer free(loop)
    
    loop_init(loop)

    fmt.printf("Running default loop")
    run(loop, uv_run_mode.UV_RUN_DEFAULT)
    //uv_loop_close(loop)


}