package main

import "core:c"
import "core:os"
import "core:sys/windows"

foreign import libuv "libuv.lib"
foreign import uv "uv.lib"

buf_t :: struct {
    base: cstring,
    len: windows.ULONG,
}
lib_t :: struct {
    handle: windows.HMODULE,
    errmsg: cstring,
}
key_t :: struct {
    tls_index: windows.DWORD,
}
when ODIN_ARCH == .amd64 {
    rwlock_t :: struct {
        read_write_lock_: windows.SRWLOCK,
        /* TODO: retained for ABI compatibility; remove me in v2.x */
        padding_: [72]cstring,
    }
} else {
    rwlock_t :: struct {
        read_write_lock_: windows.SRWLOCK,
        /* TODO: retained for ABI compatibility; remove me in v2.x */
        padding_: [44]cstring,
    }
}

cond_t :: struct #raw_union {
    cond_var: windows.CONDITION_VARIABLE,
    /* TODO: retained for ABI compatibility; remove me in v2.x. */
    unused_: struct #packed {
        waiters_count: c.uint,
        waiters_count_lock: windows.CRITICAL_SECTION,
        signal_event: windows.HANDLE,
        broadcast_event: windows.HANDLE,
    },
}
// see: https://github.com/libuv/libuv/blob/5d1ccc12c48099d720bb39f7430c480a52953039/include/uv/win.h#L284
barrier_t :: struct {
    threshold: c.uint,
    uv_in: c.uint,
    mutex: mutex_t,
    /* TODO: in v2 make this a cond_t, without unused_ */
    cond: windows.CONDITION_VARIABLE,
    uv_out: c.uint,
}

addrinfo     :: distinct windows.ADDRINFOA
file         :: distinct c.int
os_sock_t    :: distinct windows.SOCKET
os_fd_t      :: distinct windows.HANDLE
pid_t        :: distinct c.int
uid_t        :: distinct u8
gid_t        :: distinct u8
thread_t     :: distinct windows.HANDLE
mutex_t      :: distinct windows.CRITICAL_SECTION
sem_t        :: distinct windows.HANDLE

timeval_t :: struct {
    tv_sec: c.long,
    tv_usec: c.long,
}

timeval64_t :: struct {
    tv_sec: c.int64_t,
    tv_usec: c.int32_t,
}

timespec64_t :: struct {
    tv_sec: c.int64_t,
    tv_nsec: c.int32_t,
}

clock_id :: enum c.int {
    CLOCK_MONOTONIC,
    CLOCK_REALTIME
}
    
rusage_t :: struct {
    ru_utime: timeval_t, /* user CPU time used */
    ru_stime: timeval_t, /* system CPU time used */
    ru_maxrss: c.uint64_t, /* maximum resident set size */
    ru_ixrss: c.uint64_t, /* integral shared memory size (X) */
    ru_idrss: c.uint64_t, /* integral unshared data size (X) */
    ru_isrss: c.uint64_t, /* integral unshared stack size (X) */
    ru_minflt: c.uint64_t, /* page reclaims (soft page faults) (X) */
    ru_majflt: c.uint64_t, /* page faults (hard page faults) */
    ru_nswap: c.uint64_t, /* swaps (X) */
    ru_inblock: c.uint64_t, /* block input operations */
    ru_oublock: c.uint64_t, /* block output operations */
    ru_msgsnd: c.uint64_t, /* IPC messages sent (X) */
    ru_msgrcv: c.uint64_t, /* IPC messages received (X) */
    ru_nsignals: c.uint64_t, /* signals received (X) */
    ru_nvcsw: c.uint64_t, /* voluntary context switches (X) */
    ru_nivcsw: c.uint64_t, /* involuntary context switches (X) */
}

cpu_times_s :: struct  {
    user: c.uint64_t, /* milliseconds */
    nice: c.uint64_t, /* milliseconds */
    sys: c.uint64_t, /* milliseconds */
    idle: c.uint64_t, /* milliseconds */
    irq: c.uint64_t, /* milliseconds */
}

cpu_info_s :: struct  {
    model: cstring,
    speed: c.int,
    cpu_times: cpu_times_s,
} 

interface_address_s :: struct  {
    name: cstring,
    phys_addr: [6]c.char,
    is_internal: c.int,
    address: struct #raw_union {
        address4: windows.sockaddr_in,
        address6: windows.sockaddr_in6,
    },
    netmask: struct #raw_union {
        netmask4: windows.sockaddr_in,
        netmask6: windows.sockaddr_in6,
    },
}

passwd_s :: struct {
    username: cstring,
    uid: c.long,
    gid: c.long,
    shell: cstring,
    homedir: cstring,
}

utsname_s :: struct {
    sysname: [256]c.char,
    release: [256]c.char,
    version: [256]c.char,
    machine: [256]c.char,
}

env_item_s :: struct {
    name: cstring,
    value: cstring,
}

run_mode :: enum c.int {
    RUN_DEFAULT = 0,
    RUN_ONCE,
    RUN_NOWAIT,
}

handle_type :: enum c.int {
    UNKNOWN_HANDLE = 0,
    ASYNC,
    CHECK,
    FS_EVENT,
    FS_POLL,
    HANDLE,
    IDLE,
    NAMED_PIPE,
    POLL,
    PREPARE,
    PROCESS,
    STREAM,
    TCP,
    TIMER,
    TTY,
    UDP,
    SIGNAL,
    FILE,
    HANDLE_TYPE_MAX
}

req_type :: enum c.int {
    UNKNOWN_REQ = 0,
    REQ,
    CONNECT,
    WRITE,
    SHUTDOWN,
    UDP_SEND,
    FS,
    WORK,
    GETADDRINFO,
    GETNAMEINFO,
    REQ_TYPE_MAX,
}

poll_event :: enum c.int {
    READABLE = 1,
    WRITABLE = 2,
    DISCONNECT = 4,
    PRIORITIZED = 8
}

process_flags :: enum c.int {
    PROCESS_SETUID = (1 << 0),
    PROCESS_SETGID = (1 << 1),
    PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 << 2),
    PROCESS_DETACHED = (1 << 3),
    PROCESS_WINDOWS_HIDE = (1 << 4),
    PROCESS_WINDOWS_HIDE_CONSOLE = (1 << 5),
    PROCESS_WINDOWS_HIDE_GUI = (1 << 6)
}

stdio_flags :: enum c.int {
    IGNORE         = 0x00,
    CREATE_PIPE    = 0x01,
    INHERIT_FD     = 0x02,
    INHERIT_STREAM = 0x04,
    READABLE_PIPE  = 0x10,
    WRITABLE_PIPE  = 0x20,
    NONBLOCK_PIPE  = 0x40,
}

tty_mode_t :: enum c.int {
    /* Initial/normal terminal mode */
    TTY_MODE_NORMAL,
    /* Raw input mode (On Windows, ENABLE_WINDOW_INPUT is also enabled) */
    TTY_MODE_RAW,
    /* Binary-safe I/O mode for IPC (Unix-only) */
    TTY_MODE_IO
}

tty_vtermstate_t :: enum c.int {
    /*
     * The console supports handling of virtual terminal sequences
     * (Windows10 new console, ConEmu)
     */
    TTY_SUPPORTED,
    /* The console cannot process virtual terminal sequences.  (Legacy
     * console)
     */
    TTY_UNSUPPORTED
}

udp_flags :: enum c.int {
    /* Disables dual stack mode. */
    UDP_IPV6ONLY = 1,
    /*
    * Indicates message was truncated because read buffer was too small. The
    * remainder was discarded by the OS. Used in uv_udp_recv_cb.
    */
    UDP_PARTIAL = 2,
    /*
    * Indicates if SO_REUSEADDR will be set when binding the handle in
    * uv_udp_bind.
    * This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
    * Unix platforms, it sets the SO_REUSEADDR flag. What that means is that
    * multiple threads or processes can bind to the same address without error
    * (provided they all set the flag) but only the last one to bind will receive
    * any traffic, in effect "stealing" the port from the previous listener.
    */
    UDP_REUSEADDR = 4,
    /*
     * Indicates that the message was received by recvmmsg, so the buffer provided
     * must not be freed by the recv_cb callback.
     */
    UDP_MMSG_CHUNK = 8,
    /*
     * Indicates that the buffer provided has been fully utilized by recvmmsg and
     * that it should now be freed by the recv_cb callback. When this flag is set
     * in uv_udp_recv_cb, nread will always be 0 and addr will always be NULL.
     */
    UDP_MMSG_FREE = 16,
    /*
     * Indicates if IP_RECVERR/IPV6_RECVERR will be set when binding the handle.
     * This sets IP_RECVERR for IPv4 and IPV6_RECVERR for IPv6 UDP sockets on
     * Linux. This stops the Linux kernel from suppressing some ICMP error messages
     * and enables full ICMP error reporting for faster failover.
     * This flag is no-op on platforms other than Linux.
     */
    UDP_LINUX_RECVERR = 32,
    /*
    * Indicates that recvmmsg should be used, if available.
    */
    UDP_RECVMMSG = 256
}

membership :: enum c.int {
    LEAVE_GROUP = 0,
    JOIN_GROUP
}

fs_event :: enum c.int {
    RENAME = 1,
    CHANGE = 2
}

fs_event_flags :: enum c.int {
    /*
    * By default, if the fs event watcher is given a directory name, we will
    * watch for all events in that directory. This flags overrides this behavior
    * and makes fs_event report only changes to the directory entry itself. This
    * flag does not affect individual files watched.
    * This flag is currently not implemented yet on any backend.
    */
    FS_EVENT_WATCH_ENTRY = 1,
    /*
    * By default uv_fs_event will try to use a kernel interface such as inotify
    * or kqueue to detect events. This may not work on remote file systems such
    * as NFS mounts. This flag makes fs_event fall back to calling stat() on a
    * regular interval.
    * This flag is currently not implemented yet on any backend.
    */
    FS_EVENT_STAT = 2,
    /*
    * By default, event watcher, when watching directory, is not registering
    * (is ignoring) changes in its subdirectories.
    * This flag will override this behaviour on platforms that support it.
    */
    FS_EVENT_RECURSIVE = 4
}

fs_type :: enum c.int {
    FS_UNKNOWN = -1,
    FS_CUSTOM,
    FS_OPEN,
    FS_CLOSE,
    FS_READ,
    FS_WRITE,
    FS_SENDFILE,
    FS_STAT,
    FS_LSTAT,
    FS_FSTAT,
    FS_FTRUNCATE,
    FS_UTIME,
    FS_FUTIME,
    FS_ACCESS,
    FS_CHMOD,
    FS_FCHMOD,
    FS_FSYNC,
    FS_FDATASYNC,
    FS_UNLINK,
    FS_RMDIR,
    FS_MKDIR,
    FS_MKDTEMP,
    FS_RENAME,
    FS_SCANDIR,
    FS_LINK,
    FS_SYMLINK,
    FS_READLINK,
    FS_CHOWN,
    FS_FCHOWN,
    FS_REALPATH,
    FS_COPYFILE,
    FS_LCHOWN,
    FS_OPENDIR,
    FS_READDIR,
    FS_CLOSEDIR,
    FS_MKSTEMP,
    FS_LUTIME,
}

NI_MAXHOST :: 1025
NI_MAXSERV :: 32

/* handle types */
loop_t           :: distinct uv_loop_s
handle_t         :: distinct uv_handle_s 
dir_t            :: distinct uv_dir_s     
stream_t         :: distinct uv_stream_s  
tcp_t            :: distinct uv_tcp_s     
udp_t            :: distinct uv_udp_s     
pipe_t           :: distinct uv_pipe_s    
tty_t            :: distinct uv_tty_s     
poll_t           :: distinct uv_poll_s    
timer_t          :: distinct uv_timer_s   
prepare_t        :: distinct uv_prepare_s 
check_t          :: distinct uv_check_s   
idle_t           :: distinct uv_idle_s    
async_t          :: distinct uv_async_s   
process_t        :: distinct uv_process_s 
fs_event_t       :: distinct uv_fs_event_s
fs_poll_t        :: distinct uv_fs_poll_s 
signal_t         :: distinct uv_signal_s

/* request types */
req_t            :: distinct uv_req_s                                 
getaddrinfo_t    :: distinct uv_getaddrinfo_s                         
getnameinfo_t    :: distinct uv_getnameinfo_s                         
shutdown_t       :: distinct uv_shutdown_s                            
write_t          :: distinct uv_write_s                               
connect_t        :: distinct uv_connect_s                             
udp_send_t       :: distinct uv_udp_send_s                            
fs_t             :: distinct uv_fs_s                                  
work_t           :: distinct uv_work_s                                
random_t         :: distinct uv_random_s 

/* None of the above. */ 
env_item_t          :: distinct env_item_s                                        
cpu_info_t          :: distinct cpu_info_s                                        
interface_address_t :: distinct interface_address_s                               
dirent_t            :: distinct uv_dirent_s                                          
passwd_t            :: distinct passwd_s                                          
utsname_t           :: distinct utsname_s                                         
statfs_t            :: distinct uv_statfs_s
process_options_t   :: distinct uv_process_options_s
thread_options_t    :: distinct uv_thread_options_s
stdio_container_t   :: distinct uv_stdio_container_s

any_handle :: union {
    async_t,
    check_t,
    fs_event_t,
    fs_poll_t,
    handle_t,
    idle_t,
    pipe_t,
    poll_t,
    prepare_t,
    process_t,
    stream_t,
    tcp_t,
    timer_t,
    tty_t,
    udp_t,
    signal_t,
}

any_req :: union {
    req_t,        
    getaddrinfo_t,
    getnameinfo_t,
    shutdown_t,   
    write_t,      
    connect_t,    
    udp_send_t,   
    fs_t,         
    work_t,       
    random_t,     
}

dirent_type_t :: enum c.int {
    DIRENT_UNKNOWN,
    DIRENT_FILE,
    DIRENT_DIR,
    DIRENT_LINK,
    DIRENT_FIFO,
    DIRENT_SOCKET,
    DIRENT_CHAR,
    DIRENT_BLOC,
}

//function pointers
alloc_cb         :: distinct proc "cdecl" (handle: ^handle_t, suggested_size: c.size_t, buf: ^buf_t)
close_cb         :: distinct proc "cdecl" (handle: ^handle_t)
walk_cb          :: distinct proc "cdecl" (handle: ^handle_t, arg: rawptr)
timer_cb         :: distinct proc "cdecl" (handle: ^timer_t)
prepare_cb       :: distinct proc "cdecl" (handle: ^prepare_t)
check_cb         :: distinct proc "cdecl" (handle: ^check_t)
idle_cb          :: distinct proc "cdecl" (handle: ^idle_t)
async_cb         :: distinct proc "cdecl" (handle: ^async_t)
poll_cb          :: distinct proc "cdecl" (handle: ^poll_t, status, events: c.int)
signal_cb        :: distinct proc "cdecl" (handle: ^signal_t, signum: c.int)
read_cb          :: distinct proc "cdecl" (stream: ^stream_t, nread: c.ssize_t, buf: ^buf_t)
exit_cb          :: distinct proc "cdecl" (process: ^process_t, exit_status: c.int64_t, term_signal: c.int)
write_cb         :: distinct proc "cdecl" (req: ^write_t, status: c.int)
connect_cb       :: distinct proc "cdecl" (req: ^connect_t, status: c.int)
shutdown_cb      :: distinct proc "cdecl" (req: ^shutdown_t, status: c.int)
connection_cb    :: distinct proc "cdecl" (server: ^stream_t, status: c.int)
udp_send_cb      :: distinct proc "cdecl" (req: ^udp_send_t, status: c.int)
udp_recv_cb      :: distinct proc "cdecl" (handle: ^udp_t, nread: c.ssize_t, buf: ^buf_t, addr: ^windows.sockaddr, flags: c.uint)
fs_event_cb      :: distinct proc "cdecl" (handle: ^fs_event_t, filename: cstring, events, status: c.int)
fs_poll_cb       :: distinct proc "cdecl" (handle: ^fs_poll_t, status: c.int, prev: ^stat_t, curr: ^stat_t)
fs_cb            :: distinct proc "cdecl" (req: ^fs_t)
work_cb          :: distinct proc "cdecl" (req: ^work_t)
after_work_cb    :: distinct proc "cdecl" (req: ^work_t, status: c.int)
getaddrinfo_cb   :: distinct proc "cdecl" (req: ^getaddrinfo_t, status: c.int, res: ^addrinfo)
getnameinfo_cb   :: distinct proc "cdecl" (req: ^getaddrinfo_t status: c.int, hostname, service: cstring)
thread_cb        :: distinct proc "cdecl" (arg: rawptr)
malloc_func      :: distinct proc "cdecl" (size: c.size_t) -> rawptr 
realloc_func     :: distinct proc "cdecl" (ptr: rawptr, size: c.size_t) -> rawptr
calloc_func      :: distinct proc "cdecl" (count, size: c.size_t) -> rawptr
free_func        :: distinct proc "cdecl" (ptr: rawptr)
random_cb        :: distinct proc "cdecl" (req: ^random_t, status: c.int, buf: rawptr, buflen: c.size_t)


uv_random_s :: struct {
    using requests: req_t,
    /* read-only */
    loop: ^loop_t,
}

metrics_t :: struct {
    loop_count: c.uint64_t,
    events: c.uint64_t,
    events_waiting: c.uint64_t,
    /* private */
    reserved: [13]^c.uint64_t ,
}

uv_stdio_container_s :: struct {
    flags: stdio_flags,
    data: struct #raw_union {
        stream: ^stream_t,
        fd: c.int,
    }
}

uv_process_options_s :: struct {
    exit_cb: exit_cb,
    file: cstring,
    args: ^cstring,
    env: ^cstring,
    cwd: cstring,
    flags: c.uint,
    stdio_count: c.int,
    stdio: ^stdio_container_t,
    uid: uid_t,
    gid: gid_t,
}

flag :: enum c.int {
    THREAD_NO_FLAGS = 0x00,
    THREAD_HAS_STACK_SIZE = 0x01,
}
uv_thread_options_s :: struct {
    flags: flag,
    stack_size: c.size_t,
}

timespec_t :: struct {
    tv_sec: c.long,
    tv_nsec: c.long,
}

stat_t :: struct {
    st_dev: c.uint64_t, 
    st_mode: c.uint64_t, 
    st_nlink: c.uint64_t, 
    st_uid: c.uint64_t, 
    st_gid: c.uint64_t, 
    st_rdev: c.uint64_t, 
    st_ino: c.uint64_t, 
    st_size: c.uint64_t, 
    st_blksize: c.uint64_t, 
    st_blocks: c.uint64_t, 
    st_flags: c.uint64_t, 
    st_gen: c.uint64_t, 
    st_atim: timespec_t, 
    st_mtim: timespec_t, 
    st_ctim : timespec_t,
    st_birthtim: timespec_t, 
}

uv_statfs_s :: struct {
    f_type: c.uint64_t,
    f_bsize: c.uint64_t,
    f_blocks: c.uint64_t,
    f_bfree: c.uint64_t,
    f_bavail: c.uint64_t,
    f_files: c.uint64_t,
    f_ffree: c.uint64_t,
    f_spare: [4]c.uint64_t,
}

uv_dirent_s :: struct {
    name: cstring,
    type: dirent_type_t, 
}

uv_dir_s :: struct {
    dirents: ^dirent_t,
    nentries: c.size_t,
}

uv_work_s :: struct {
    using request: req_t,
    loop: ^loop_t,
}

uv_getaddrinfo_s :: struct {
    using request: req_t,
    loop: ^loop_t,
    addrinfo: ^addrinfo,
}

uv_getnameinfo_s :: struct {
    using request: req_t,
    loop: ^loop_t,
    host: [NI_MAXHOST]c.char,
    service: [NI_MAXSERV]c.char,
}

uv_loop_s :: struct {
    data: rawptr,
}

uv_handle_s :: struct {
    data: rawptr,                                                                                                                    
    loop: ^loop_t,                                                        
    type: handle_type,                                                                                                           
}

uv_req_s :: struct {
    data: rawptr,
    type: req_type,
}

uv_timer_s :: struct {
    using handle: handle_t,  
}

uv_prepare_s :: struct {
    using handle: handle_t, 
}

uv_check_s :: struct {
    using handle: handle_t,                                                                                                            
}

uv_idle_s :: struct {
    using handle: handle_t,                                                                                                           
}

uv_async_s :: struct {
    using handle: handle_t,                                                                                                         
}

uv_poll_s :: struct {
    using handle: handle_t,                                                                                                   
}

uv_signal_s :: struct {
    signum: c.int,
    using handle: handle_t,                                                                                                    
}

uv_process_s :: struct {
    using handle: handle_t, 
    exit_cb: exit_cb,
    pid: c.int,                                                                                                        
}

uv_stream_s :: struct {
    using handle: handle_t,  
    write_queue_size: c.size_t,                                                    
    alloc_cb: alloc_cb,                                     
    read_cb: read_cb,
}

uv_connect_s :: struct {
    using request: req_t,
    cb: connect_cb,
    handle: ^stream_t,
}

uv_shutdown_s :: struct {
    using request: req_t,
    handle: ^stream_t,
    cb: shutdown_cb,
}

uv_write_s :: struct {
    using request: req_t,
    cb: write_cb,
    send_handle: ^stream_t,
    handle: ^stream_t,
}

uv_tcp_s :: struct {
    using stream: stream_t,
}

uv_pipe_s :: struct {
    using stream: stream_t,
    ipc: c.int,
}

uv_tty_s :: struct {
    using stream: stream_t,
}

uv_udp_s :: struct {
    using handle: handle_t,
    send_queue_size: c.size_t,
    send_queue_count: c.size_t,
}

uv_udp_send_s :: struct {
    using request: req_t,
    handle: ^udp_t,
    cb: udp_send_cb,
}

uv_fs_event_s :: struct {
    using handle: handle_t,
}

uv_fs_poll_s :: struct {
    using handle: handle_t,
}

//filesystem utilities
uv_fs_s :: struct {
    using request: req_t,
    loop: ^loop_t,
    fs_type: fs_type,
    path: cstring,
    result: c.ssize_t,
    statbuf: stat_t,
    ptr: rawptr,
}

@(default_calling_convention="c", link_prefix="uv_")
foreign uv {
    //error handling
    strerror            :: proc (err: c.int) -> cstring ---
    strerror_r          :: proc (err: c.int, buf: cstring, buflen: c.size_t) -> cstring ---
    err_name            :: proc (err: c.int) -> cstring ---
    err_name_r          :: proc (err: c.int, buf: cstring, buflen: c.size_t) -> cstring ---
    translate_sys_error :: proc (sys_errno: c.int) -> c.int ---

    //Version-checking macros and functions
    version             :: proc () -> c.uint ---
    version_string      :: proc () -> cstring ---
    
    //loop_t procedures
    loop_init           :: proc (loop: ^loop_t) -> c.int ---
    run                 :: proc (loop: ^loop_t, mode: run_mode) -> c.int ---
    loop_close          :: proc (loop: ^loop_t) -> c.int ---
    default_loop        :: proc ()                 -> ^loop_t  ---
    loop_alive          :: proc (loop: ^loop_t) -> c.int ---
    stop                :: proc (loop: ^loop_t) ---
    loop_size           :: proc ()                 -> c.size_t ---
    backend_fd          :: proc (loop: ^loop_t) -> c.int ---
    backend_timeout     :: proc (loop: ^loop_t) -> c.int ---
    now                 :: proc (loop: ^loop_t) -> c.uint64_t ---
    update_time         :: proc (loop: ^loop_t) ---
    walk                :: proc (loop: ^loop_t, walk_cb: walk_cb, arg: rawptr) ---
    loop_fork           :: proc (loop: ^loop_t) -> c.int ---
    loop_get_data       :: proc (loop: ^loop_t) -> rawptr ---
    loop_set_data       :: proc (loop: ^loop_t, data: rawptr) -> rawptr ---

    //uv_handle_t
    is_active           :: proc (handle: ^handle_t) -> c.int ---
    is_closing          :: proc (handle: ^handle_t) -> c.int ---
    close               :: proc (handle: ^handle_t, close_cb: close_cb) ---
    ref                 :: proc (handle: ^handle_t) ---
    unref               :: proc (handle: ^handle_t) ---
    has_ref             :: proc (handle: ^handle_t) -> c.int ---
    handle_size         :: proc (type: handle_type) -> c.size_t ---
    send_buffer_size    :: proc (handle: ^handle_t, value: ^c.int) -> c.int ---
    recv_buffer_size    :: proc (handle: ^handle_t, value: ^c.int) -> c.int ---
    fileno              :: proc (handle: ^handle_t, fd: ^os_fd_t) -> c.int ---
    handle_get_loop     :: proc (handle: ^handle_t) -> ^loop_t ---
    handle_get_data     :: proc (handle: ^handle_t) -> rawptr ---
    handle_set_data     :: proc (handle: ^handle_t, data: rawptr) -> rawptr ---
    handle_get_type     :: proc (handle: ^handle_t) -> handle_type ---
    handle_type_name    :: proc (type: handle_type) -> cstring ---

    //uv_req_t
    cancel              :: proc (req: ^req_t) -> c.int ---
    req_size            :: proc (type: req_type) -> c.size_t ---
    req_get_data        :: proc (req: ^req_t) -> rawptr ---
    req_set_data        :: proc (req: ^req_t, data: rawptr) -> rawptr ---
    req_get_type        :: proc (req: ^req_t) -> req_type ---
    req_type_name       :: proc (type: req_type) -> cstring ---

    //uv_timer_t
    timer_init          :: proc (loop: ^loop_t, handle: ^timer_t) -> c.int --- 
    timer_start         :: proc (handle: ^timer_t, cb: timer_cb, timeout: c.uint64_t, repeat: c.uint64_t) -> c.int --- 
    timer_stop          :: proc (handle: ^timer_t) -> c.int --- 
    timer_again         :: proc (handle: ^timer_t) -> c.int --- 
    timer_set_repeat    :: proc (handle: ^timer_t, repeat: c.uint64_t) ---
    timer_get_repeat    :: proc (handle: ^timer_t) -> c.uint64_t ---
    timer_get_due_in    :: proc (handle: ^timer_t) -> c.uint64_t ---

    //uv_prepare_t
    prepare_init        :: proc (loop: ^loop_t, prepare: ^prepare_t) -> c.int ---
    prepare_start       :: proc (prepare: ^prepare_t, cb: prepare_cb) -> c.int ---
    prepare_stop        :: proc (prepare: ^prepare_t) -> c.int ---
    
    //uv_check_t    
    check_init          :: proc (loop: ^loop_t, check: ^check_t) -> c.int ---
    check_start         :: proc (check: ^check_t, cb: check_cb) -> c.int ---
    check_stop          :: proc (check: ^check_t) -> c.int ---
        
    //uv_idle_t 
    idle_init           :: proc (loop: ^loop_t, idle: ^idle_t) -> c.int ---
    idle_start          :: proc (idle: ^idle_t, cb: idle_cb) -> c.int ---
    idle_stop           :: proc (idle: ^idle_t) -> c.int ---
    
    //uv_async_t
    async_init          :: proc (loop: ^loop_t, async: ^async_t, async_cb: async_cb) -> c.int ---
    async_send          :: proc (async: ^async_t) -> c.int ---

    //uv_poll_t
    poll_init           :: proc (loop: ^loop_t, handle: ^poll_t, fd: c.int) -> c.int ---
    poll_init_socket    :: proc (loop: ^loop_t, handle: ^poll_t, socket: os_sock_t) -> c.int ---
    poll_start          :: proc (handle: ^poll_t, events: c.int, cb: poll_cb) -> c.int ---
    poll_stop           :: proc (poll: ^poll_t) -> c.int ---

    //uv_signal_t
    signal_init         :: proc (loop: ^loop_t, signal: ^signal_t) -> c.int ---
    signal_start        :: proc (signal: ^signal_t, cb: signal_cb, signum: c.int) -> c.int ---
    signal_start_oneshot:: proc (signal: ^signal_t, cb: signal_cb, signum: c.int) -> c.int ---
    signal_stop         :: proc (signal: ^signal_t) -> c.int ---

    //uv_process_t
    disable_stdio_inheritance :: proc() ---
    spawn               :: proc (loop: ^loop_t, handle: ^process_t, options: ^process_options_t) -> c.int ---
    process_kill        :: proc (handle: ^process_t, signum: c.int) -> c.int ---
    kill                :: proc (pid: c.int, signum: c.int) -> c.int ---
    process_get_pid     :: proc (handle: ^process_t) -> pid_t ---

    //uv_stream_t
    shutdown            :: proc (req: ^shutdown_t, handle: ^stream_t, cb: shutdown_cb) -> c.int ---
    listen              :: proc (stream: ^stream_t, backlog: c.int, cb: connection_cb) -> c.int ---
    accept              :: proc (server: ^stream_t, client: ^stream_t) -> c.int ---
    read_start          :: proc (stream: ^stream_t, alloc_cb: alloc_cb, read_cb: read_cb) -> c.int ---
    read_stop           :: proc (stream: ^stream_t) -> c.int ---
    write               :: proc (req: ^write_t, handle: ^stream_t, bufs: []buf_t, nbufs: c.uint, cb: write_cb) -> c.int ---
    write2              :: proc (req: ^write_t, handle: ^stream_t, bufs: []buf_t, nbufs: c.uint, send_handle: ^stream_t, cb: write_cb) -> c.int ---
    try_write           :: proc (handle: ^stream_t, bufs: []buf_t, nbufs: c.uint) -> c.int ---
    try_write2          :: proc (handle: ^stream_t, bufs: []buf_t, nbufs: c.uint, send_handle: ^stream_t) -> c.int ---
    is_readable         :: proc (handle: ^stream_t) -> c.int ---
    is_writable         :: proc (handle: ^stream_t) -> c.int ---
    stream_set_blocking :: proc (handle: ^stream_t, blocking: c.int) -> c.int ---
    stream_get_write_queue_size :: proc (stream: ^stream_t) -> c.size_t ---

    //uv_tcp_t
    tcp_init            :: proc (loop: ^loop_t, handle: ^tcp_t) -> c.int ---
    tcp_init_ex         :: proc (loop: ^loop_t, handle: ^tcp_t, flags: c.uint) -> c.int ---
    tcp_open            :: proc (handle: ^tcp_t, sock: os_sock_t) -> c.int ---
    tcp_nodelay         :: proc (handle: ^tcp_t, enable: c.int) -> c.int ---
    tcp_keepalive       :: proc (handle: ^tcp_t, enable: c.int, delay: c.uint) -> c.int ---
    tcp_simultaneous_accepts :: proc (handle: ^tcp_t, enable: c.int) -> c.int ---
    tcp_bind            :: proc (handle: ^tcp_t, addr: ^windows.sockaddr, flags: c.uint) -> c.int ---
    tcp_getsockname     :: proc (handle: ^tcp_t, name: ^windows.sockaddr, namelen: ^c.int) -> c.int ---
    tcp_getpeername     :: proc (handle: ^tcp_t, name: ^windows.sockaddr, namelen: ^c.int) -> c.int ---
    tcp_connect         :: proc (req: ^connect_t, handle: ^tcp_t, addr: ^windows.sockaddr, cb: connect_cb) -> c.int ---
    tcp_close_reset     :: proc (handle: ^tcp_t, close_cb: close_cb) -> c.int ---
    socketpair          :: proc (protocol, type: c.int, socket_vector: [2]os_sock_t, flags0, flags1: c.int) -> c.int ---

    //uv_pipe_t
    pipe_init           :: proc (loop: ^loop_t, handle: ^pipe_t, ipc: c.int) -> c.int ---
    pipe_open           :: proc (handle: ^pipe_t, file: file) -> c.int ---
    pipe_bind           :: proc (handle: ^pipe_t, name: cstring) -> c.int ---
    pipe_bind2          :: proc (handle: ^pipe_t, name: cstring, namelen: c.size_t, flags: c.uint) -> c.int ---
    pipe_connect        :: proc (req: ^connect_t, handle: ^pipe_t, name: cstring, cb: connect_cb) ---
    pipe_connect2       :: proc (req: ^connect_t, handle: ^pipe_t, name: cstring, namelen: c.size_t, flags: c.uint, cb: connect_cb) ---
    pipe_getsockname    :: proc (handle: ^pipe_t, buffer: cstring, size: c.size_t) -> c.int ---
    pipe_getpeername    :: proc (handle: ^pipe_t, buffer: cstring, size: c.size_t) -> c.int ---
    pipe_pending_instances :: proc (handle: ^pipe_t, count: c.int) ---
    pipe_pending_count  :: proc (handle: ^pipe_t) -> c.int ---
    pipe_pending_type   :: proc (handle: ^pipe_t) -> handle_type ---
    pipe_chmod          :: proc (handle: ^pipe_t, flags: c.int) -> c.int ---
    pipe                :: proc (fds: [2]file, read_flags, write_flags: c.int) -> c.int ---

    //uv_tty_t
    tty_init            :: proc (loop: ^loop_t, handle: ^tty_t, fd: file, unused: c.int) -> c.int ---
    tty_set_mode        :: proc (handle: ^tty_t, mode: tty_mode_t) -> c.int ---
    tty_reset_mode      :: proc () -> c.int ---
    tty_get_winsize     :: proc (handle: ^tty_t, width, height: ^c.int) -> c.int ---
    tty_set_vterm_state :: proc (state: tty_vtermstate_t) ---
    tty_get_vterm_state :: proc (state: ^tty_vtermstate_t) -> c.int ---

    //uv_udp_t
    udp_init            :: proc (loop: ^loop_t, handle: ^udp_t) -> c.int ---
    udp_init_ex         :: proc (loop: ^loop_t, handle: ^udp_t, flags: c.uint) -> c.int ---
    udp_open            :: proc (handle: ^udp_t, sock: os_sock_t) -> c.int ---
    udp_bind            :: proc (handle: ^udp_t, addr: ^windows.sockaddr, flags: c.int) -> c.int ---
    udp_connect         :: proc (handle: ^udp_t, addr: ^windows.sockaddr) -> c.int ---
    udp_getpeername     :: proc (handle: ^udp_t, name: ^windows.sockaddr, namelen: ^c.int) -> c.int ---
    udp_getsockname     :: proc (handle: ^udp_t, name: ^windows.sockaddr, namelen: ^c.int) -> c.int ---
    udp_set_membership  :: proc (handle: ^udp_t, multicast_addr: cstring, interface_addr: cstring, membership: membership) -> c.int ---
    udp_set_source_membership :: proc (handle: ^udp_t, multicast_addr: cstring, interface_addr: cstring, source_addr: cstring, membership: membership) -> c.int ---
    udp_set_multicast_loop :: proc (handle: ^udp_t, on: c.int) -> c.int ---
    udp_set_multicast_ttl :: proc (handle: ^udp_t, ttl: c.int) -> c.int ---
    udp_set_multicast_interface :: proc (handle: ^udp_t, interface_addr: cstring) -> c.int ---
    udp_set_broadcast   :: proc (handle: ^udp_t, on: c.int) -> c.int ---
    udp_set_ttl         :: proc (handle: ^udp_t, ttl: c.int) -> c.int ---
    udp_send            :: proc (req: udp_send_t, handle: ^udp_t, bufs: []buf_t , nbufs: c.uint, addr: ^windows.sockaddr, send_cb: udp_send_cb) -> c.int ---
    udp_try_send        :: proc (handle: ^udp_t, bufs: []buf_t, nbufs: c.uint, addr: ^windows.sockaddr) -> c.int ---
    udp_recv_start      :: proc (handle: ^udp_t, alloc_cb: alloc_cb, recv_cb: udp_recv_cb) -> c.int ---
    udp_using_recvmmsg  :: proc (handle: ^udp_t) -> c.int ---
    udp_recv_stop       :: proc (handle: ^udp_t) -> c.int ---
    udp_get_send_queue_size :: proc (handle: ^udp_t) -> c.size_t ---
    udp_get_send_queue_count :: proc (handle: ^udp_t) -> c.size_t ---

    //uv_fs_event_t
    fs_event_init       :: proc (loop: ^loop_t, handle: ^fs_event_t) -> c.int ---
    fs_event_start      :: proc (handle: ^fs_event_t, cb: fs_event_cb, path: cstring, flags: c.uint) -> c.int ---
    fs_event_stop       :: proc (handle: ^fs_event_t) -> c.int ---
    fs_event_getpath    :: proc (handle: ^fs_event_t, buffer: cstring, size: ^c.size_t) -> c.int ---

    //uv_fs_poll_t
    fs_poll_init        :: proc (loop: ^loop_t, handle: ^fs_poll_t) -> c.int ---
    fs_poll_start       :: proc (handle: ^fs_poll_t, poll_cb: fs_poll_cb, path: cstring, interval: c.uint) -> c.int ---
    fs_poll_stop        :: proc (handle: ^fs_poll_t) -> c.int ---
    fs_poll_getpath     :: proc (handle: ^fs_poll_t, buffer: cstring, size: ^c.size_t) -> c.int ---

    //filesystem utilities
    fs_req_cleanup      :: proc (req: ^fs_t) ---
    fs_close            :: proc (loop: ^loop_t, req: ^fs_t, file: file, cb:fs_cb) -> c.int ---
    fs_open             :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, flags, mode: c.int, cb:fs_cb) -> c.int ---
    fs_read             :: proc (loop: ^loop_t, req: ^fs_t, file: file, bufs: []buf_t , nbufs: c.uint, offset: c.int64_t, cb:fs_cb) -> c.int ---
    fs_unlink           :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_write            :: proc (loop: ^loop_t, req: ^fs_t, file: file, bufs: []buf_t , nbufs: c.uint, offset: c.int64_t, cb:fs_cb) -> c.int ---
    fs_mkdir            :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, mode: c.int, cb:fs_cb) -> c.int ---
    fs_mkdtemp          :: proc (loop: ^loop_t, req: ^fs_t, tpl: cstring, cb:fs_cb) -> c.int ---
    fs_mkstemp          :: proc (loop: ^loop_t, req: ^fs_t, tpl: cstring, cb:fs_cb) -> c.int ---
    fs_rmdir            :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_opendir          :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_closedir         :: proc (loop: ^loop_t, req: ^fs_t, dir: ^dir_t, cb:fs_cb) -> c.int ---
    fs_readdir          :: proc (loop: ^loop_t, req: ^fs_t, dir: ^dir_t, cb:fs_cb) -> c.int ---
    fs_scandir          :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, flags: c.int, cb:fs_cb) -> c.int ---
    fs_scandir_next     :: proc (req: ^fs_t, ent: ^dirent_t) -> c.int ---
    fs_stat             :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_fstat            :: proc (loop: ^loop_t, req: ^fs_t, file: file, cb:fs_cb) -> c.int ---
    fs_lstat            :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_statfs           :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_rename           :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, new_path: cstring, cb:fs_cb) -> c.int ---
    fs_fsync            :: proc (loop: ^loop_t, req: ^fs_t, file: file, cb:fs_cb) -> c.int ---
    fs_fdatasync        :: proc (loop: ^loop_t, req: ^fs_t, file: file, cb:fs_cb) -> c.int ---
    fs_ftruncate        :: proc (loop: ^loop_t, req: ^fs_t, file: file, offset: c.int64_t, cb:fs_cb) -> c.int ---
    fs_copyfile         :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, new_path: cstring, flags: c.int, cb:fs_cb) -> c.int ---
    fs_sendfile         :: proc (loop: ^loop_t, req: ^fs_t, out_fd, in_fd: file, in_offset: c.int64_t, length: c.size_t, cb:fs_cb) -> c.int ---
    fs_access           :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, mode: c.int, cb:fs_cb) -> c.int ---
    fs_chmod            :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, mode: c.int, cb:fs_cb) -> c.int ---
    fs_fchmod           :: proc (loop: ^loop_t, req: ^fs_t, file: file, mode: c.int, cb:fs_cb) -> c.int ---
    fs_utime            :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, atime, mtime: c.double, cb:fs_cb) -> c.int ---
    fs_futime           :: proc (loop: ^loop_t, req: ^fs_t, file: file, atime, mtime: c.double, cb:fs_cb) -> c.int ---
    fs_lutime           :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, atime, mtime: c.double, cb:fs_cb) -> c.int ---
    fs_link             :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, new_path: cstring, cb:fs_cb) -> c.int ---
    fs_symlink          :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, new_path: cstring, flags: c.int, cb:fs_cb) -> c.int ---
    fs_readlink         :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_realpath         :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, cb:fs_cb) -> c.int ---
    fs_chown            :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, uid: uid_t, gid: gid_t, cb:fs_cb) -> c.int ---
    fs_fchown           :: proc (loop: ^loop_t, req: ^fs_t, file: file, uid: uid_t, gid: gid_t, cb:fs_cb) -> c.int ---
    fs_lchown           :: proc (loop: ^loop_t, req: ^fs_t, path: cstring, uid: uid_t, gid: gid_t, cb:fs_cb) -> c.int ---
    fs_get_type         :: proc (req: ^fs_t) -> fs_type ---
    fs_get_result       :: proc (req: ^fs_t) -> c.ssize_t ---
    fs_get_system_error :: proc (req: ^fs_t) -> c.int ---
    fs_get_ptr          :: proc (req: ^fs_t) -> rawptr ---
    fs_get_path         :: proc (req: ^fs_t) -> cstring ---
    fs_get_statbuf      :: proc (req: ^fs_t) -> ^stat_t ---
    get_osfhandle       :: proc (fd: c.int) -> os_fd_t ---
    open_osfhandle      :: proc (os_fd: os_fd_t) -> c.int ---

    //Thread pool work scheduling
    queue_work          :: proc (loop: ^loop_t, req: ^work_t, work_cb: work_cb, after_work_cb: after_work_cb) -> c.int ---

    //DNS utility
    getaddrinfo         :: proc (loop: ^loop_t, req: ^getaddrinfo_t, getaddrinfo_cb: getaddrinfo_cb , node, service: cstring, hints: ^addrinfo) -> c.int ---
    freeaddrinfo        :: proc (ai: ^addrinfo) ---
    getnameinfo         :: proc (loop: ^loop_t, req: ^getaddrinfo_t, getnameinfo_cb: getnameinfo_cb , addr: ^windows.sockaddr, flags: c.int) -> c.int ---

    //shared library handling
    dlopen              :: proc (filename: cstring, lib: ^lib_t) -> c.int ---
    dlclose             :: proc (lib: ^lib_t) ---
    dlsym               :: proc (lib: ^lib_t, name: cstring, ptr: ^rawptr) -> c.int ---
    dlerror             :: proc (lib: ^lib_t) -> cstring ---

    //Threading and synchronization utilities
    thread_create       :: proc (tid: ^thread_t, entry: thread_cb, arg: rawptr) -> c.int ---
    thread_create_ex    :: proc (tid: ^thread_t, params: ^thread_options_t, entry: thread_cb, arg: rawptr) -> c.int ---
    thread_setaffinity  :: proc (tid: ^thread_t, cpumask, oldmask: cstring, mask_size: c.size_t) -> c.int ---
    thread_getaffinity  :: proc (tid: ^thread_t, cpumask: cstring, mask_size: c.size_t) -> c.int ---
    thread_getcpu       :: proc () -> c.int ---
    thread_self         :: proc () ---
    thread_join         :: proc (tid: ^thread_t) -> c.int ---
    thread_equal        :: proc (t1: ^thread_t, t2: ^thread_t) -> c.int ---
    thread_setpriority  :: proc (tid: thread_t, priority: c.int) -> c.int ---
    thread_getpriority  :: proc (tid: thread_t, priority: ^c.int) -> c.int ---
    key_create          :: proc (key: ^key_t) ---
    key_delete          :: proc (key: ^key_t) ---
    key_get             :: proc (key: ^key_t) ---
    key_set             :: proc (key: ^key_t, value: rawptr) ---

    // i don't know how to convert this to odin
    /* void uv_once(uv_once_t *guard, void (*callback)(void)) */

    mutex_init          :: proc (handle: ^mutex_t) -> c.int ---
    mutex_init_recursive :: proc (handle: ^mutex_t) -> c.int ---
    mutex_destroy       :: proc (handle: ^mutex_t) ---
    mutex_lock          :: proc (handle: ^mutex_t) ---
    mutex_trylock       :: proc (handle: ^mutex_t) -> c.int ---
    mutex_unlock        :: proc (handle: ^mutex_t) ---
    rwlock_init         :: proc (rwlock: ^rwlock_t) -> c.int ---
    rwlock_destroy      :: proc (rwlock: ^rwlock_t) ---
    rwlock_rdlock       :: proc (rwlock: ^rwlock_t) ---
    rwlock_tryrdlock    :: proc (rwlock: ^rwlock_t) -> c.int ---
    rwlock_rdunlock     :: proc (rwlock: ^rwlock_t) ---
    rwlock_wrlock       :: proc (rwlock: ^rwlock_t) ---
    rwlock_trywrlock    :: proc (rwlock: ^rwlock_t) -> c.int ---
    rwlock_wrunlock     :: proc (rwlock: ^rwlock_t) ---
    sem_init            :: proc (sem: ^sem_t, value: c.uint) -> c.int ---
    sem_destroy         :: proc (sem: ^sem_t) ---
    sem_post            :: proc (sem: ^sem_t) ---
    sem_wait            :: proc (sem: ^sem_t) ---
    sem_trywait         :: proc (sem: ^sem_t) -> c.int ---
    cond_init           :: proc (cond: ^cond_t) -> c.int ---
    cond_destroy        :: proc (cond: ^cond_t) ---
    cond_signal         :: proc (cond: ^cond_t) ---
    cond_broadcast      :: proc (cond: ^cond_t) ---
    cond_wait           :: proc (cond: ^cond_t, mutex: ^mutex_t) ---
    cond_timedwait      :: proc (cond: ^cond_t, mutex: ^mutex_t, timeout: c.uint64_t) -> c.int ---
    barrier_init        :: proc (barrier: ^barrier_t, count: c.uint) -> c.int ---
    barrier_destroy     :: proc (barrier: ^barrier_t) ---
    barrier_wait        :: proc (barrier: ^barrier_t) -> c.int ---

    //miscellanous utilities
    guess_handle        :: proc (file: file) -> handle_type ---
    replace_allocator   :: proc (malloc_func: malloc_func, realloc_func: realloc_func, calloc_func: calloc_func, free_func: free_func) -> c.int ---
    library_shutdown    :: proc () ---
    buf_init            :: proc (base: cstring, len: c.uint) ->buf_t ---
    setup_args          :: proc (argc: c.int, argv: [^]c.char) -> ^cstring ---
    get_process_title   :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    set_process_title   :: proc (title: cstring) -> c.int ---
    resident_set_memory :: proc (rss: ^c.size_t) -> c.int ---
    uptime              :: proc (uptime: ^c.double) -> c.int ---
    getrusage           :: proc (rusage: ^rusage_t) -> c.int ---
    os_getpid           :: proc () -> pid_t ---
    os_getppid          :: proc () -> pid_t ---
    available_parallelism :: proc () -> c.uint ---
    cpu_info            :: proc (cpu_infos: [^]cpu_info_t, count: ^c.int) -> c.int ---
    free_cpu_info       :: proc (cpu_infos: ^cpu_info_t, count: c.int) ---
    cpumask_size        :: proc () -> c.int ---
    interface_addresses :: proc (addresses: [^]interface_address_t, count: ^c.int) -> c.int ---
    free_interface_addresses :: proc (addresses: ^interface_address_t, count: c.int) ---
    loadavg             :: proc (avg: [3]c.double) ---
    ip4_addr            :: proc (ip: cstring, port: c.int, addr: ^windows.sockaddr_in) -> c.int ---
    ip6_addr            :: proc (ip: cstring, port: c.int, addr: ^windows.sockaddr_in6) -> c.int ---
    ip4_name            :: proc (src: ^windows.sockaddr_in, dst: cstring, size: c.size_t) -> c.int ---
    ip6_name            :: proc (src: ^windows.sockaddr_in6, dst: cstring, size: c.size_t) -> c.int ---
    ip_name             :: proc (src: ^windows.sockaddr, dst: cstring, size: c.size_t) -> c.int ---
    inet_ntop           :: proc (af: c.int src: rawptr, dst: cstring, size: c.size_t) -> c.int ---
    inet_pton           :: proc (af: c.int, src: cstring, dst: rawptr) -> c.int ---
    if_indextoname      :: proc (ifindex: c.uint, buffer: cstring, size: c.size_t) -> c.int ---
    if_indextoiid       :: proc (ifindex: c.uint, buffer: cstring, size: c.size_t) -> c.int ---
    exepath             :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    cwd                 :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    chdir               :: proc (dir: cstring) -> c.int ---
    os_homedir          :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    os_tmpdir           :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    os_get_passwd       :: proc (pwd: ^passwd_t) -> c.int ---
    os_free_passwd      :: proc (pwd: ^passwd_t) ---
    get_free_memory     :: proc () -> c.uint64_t ---
    get_total_memory    :: proc () -> c.uint64_t ---
    get_constrained_memory :: proc () -> c.uint64_t ---
    get_available_memory :: proc () -> c.uint64_t ---
    hrtime              :: proc () -> c.uint64_t ---
    clock_gettime       :: proc (clock_id: clock_id, ts: ^timespec64_t) -> c.int ---
    print_all_handles   :: proc (loop: ^loop_t, stream: ^os.Handle) ---
    print_active_handles :: proc (loop: ^loop_t, stream: ^os.Handle) ---
    os_environ          :: proc (envitems: [^]env_item_t, count: ^c.int) -> c.int ---
    os_free_environ     :: proc (envitems: ^env_item_t, count: c.int) ---
    os_getenv           :: proc (name: cstring, buffer: cstring, size: c.size_t) -> c.int ---
    os_setenv           :: proc (name: cstring, value: cstring) -> c.int ---
    os_unsetenv         :: proc (name: cstring) -> c.int ---
    os_gethostname      :: proc (buffer: cstring, size: ^c.size_t) -> c.int ---
    os_getpriority      :: proc (pid: pid_t, priority: ^c.int) -> c.int ---
    os_setpriority      :: proc (pid: pid_t, priority: c.int) -> c.int ---
    os_uname            :: proc (buffer: ^utsname_t) -> c.int ---
    gettimeofday        :: proc (tv: ^timeval64_t) -> c.int ---
    random              :: proc (loop: ^loop_t, req: ^random_t, buf: rawptr, buflen: c.size_t, flags: c.uint, cb: random_cb) -> c.int ---
    sleep               :: proc (msec: c.uint) ---

    //string manipulation function
    utf16_length_as_wtf8    :: proc (utf16: c.uint16_t, utf16_len: c.ssize_t) -> c.size_t ---
    utf16_to_wtf8           :: proc (utf16: c.uint16_t, utf16_len: c.ssize_t, wtf8_ptr: [^]c.char, wtf8_len_ptr: ^c.size_t) -> c.int ---
    wtf8_length_as_utf16    :: proc (wtf8: cstring) -> c.ssize_t ---
    wtf8_to_utf16           :: proc (utf8: cstring, utf16: c.uint16_t, utf16_len: c.size_t) ---
    
    //metrics operation
    metrics_idle_time   :: proc (loop: ^loop_t) -> c.uint64_t ---
    metrics_info        :: proc (loop: ^loop_t, metrics: ^metrics_t) -> c.int ---

}
