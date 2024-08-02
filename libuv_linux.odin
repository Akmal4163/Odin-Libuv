package libuv_linux

import "core:c"
import "core:os"
import "core:sys/linux"
import "core:sync"
import "core:thread"

//foreign import libuv "libuv.lib"
//foreign import uv "uv.lib"

uv_buf_t :: struct {
    base: cstring,
    len: c.size_t,
}
uv_lib_t :: struct {
    handle: rawptr,
    errmsg: cstring,
}
uv_key_t :: distinct linux.Key

uv_rwlock_t :: struct {
    __readers: c.uint32_t,
    __writers: c.uint32_t,
    __wrphase_futex: c.uint32_t,
    __writers_futex: c.uint32_t,
    __pad3: c.uint32_t,
    __pad4: c.uint32_t,
    __cur_writer: c.int,
    __shared: c.int,
    __rwelision: c.schar,
    __pad1: [7]c.uchar,
    __pad2: c.ulonglong,
    __flags: c.uint,
}

addrinfo :: struct {
    ai_flags: c.int,            // AI_PASSIVE, AI_CANONNAME, etc.
    ai_family: c.int,           // AF_INET, AF_INET6, AF_UNSPEC, etc.
    ai_socktype: c.int,         // SOCK_STREAM, SOCK_DGRAM, etc.
    ai_protocol: c.int,         // IPPROTO_TCP, IPPROTO_UDP, etc.
    ai_addrlen: c.size_t,       // length of ai_addr
    ai_addr: ^linux.Sock_Addr_Any, // binary address
    ai_canonname: cstring,      // canonical name for nodename
    ai_next: ^addrinfo,
}

uv_cond_t :: distinct sync.Cond
// see: https://github.com/libuv/libuv/blob/5d1ccc12c48099d720bb39f7430c480a52953039/include/uv/win.h#L284
uv_barrier_t :: distinct sync.Barrier


uv_file         :: distinct c.int
uv_os_sock_t    :: distinct c.int
uv_os_fd_t      :: distinct c.int
uv_pid_t        :: distinct linux.Pid
uv_uid_t        :: distinct linux.Uid
uv_gid_t        :: distinct linux.Gid
uv_thread_t     :: distinct thread.Thread
uv_mutex_t      :: distinct sync.Mutex
uv_sem_t        :: distinct sync.Sema

uv_timeval_t :: struct {
    tv_sec: c.long,
    tv_usec: c.long,
}

uv_timeval64_t :: struct {
    tv_sec: c.int64_t,
    tv_usec: c.int32_t,
}

uv_timespec64_t :: struct {
    tv_sec: c.int64_t,
    tv_nsec: c.int32_t,
}

uv_clock_id :: enum c.int {
    UV_CLOCK_MONOTONIC,
    UV_CLOCK_REALTIME
}
    
uv_rusage_t :: struct {
    ru_utime: uv_timeval_t, /* user CPU time used */
    ru_stime: uv_timeval_t, /* system CPU time used */
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

uv_cpu_times_s :: struct  {
    user: c.uint64_t, /* milliseconds */
    nice: c.uint64_t, /* milliseconds */
    sys: c.uint64_t, /* milliseconds */
    idle: c.uint64_t, /* milliseconds */
    irq: c.uint64_t, /* milliseconds */
}

uv_cpu_info_s :: struct  {
    model: cstring,
    speed: c.int,
    cpu_times: uv_cpu_times_s,
} 

uv_interface_address_s :: struct  {
    name: cstring,
    phys_addr: [6]c.char,
    is_internal: c.int,
    address: struct #raw_union {
        address4: linux.Sock_Addr_In,
        address6: linux.Sock_Addr_In6,
    },
    netmask: struct #raw_union {
        netmask4: linux.Sock_Addr_In,
        netmask6: linux.Sock_Addr_In6,
    },
}

uv_passwd_s :: struct {
    username: cstring,
    uid: c.long,
    gid: c.long,
    shell: cstring,
    homedir: cstring,
}

uv_utsname_s :: struct {
    sysname: [256]c.char,
    release: [256]c.char,
    version: [256]c.char,
    machine: [256]c.char,
}

uv_env_item_s :: struct {
    name: cstring,
    value: cstring,
}

uv_run_mode :: enum c.int {
    UV_RUN_DEFAULT = 0,
    UV_RUN_ONCE,
    UV_RUN_NOWAIT,
}

uv_handle_type :: enum c.int {
    UV_UNKNOWN_HANDLE = 0,
    UV_ASYNC,
    UV_CHECK,
    UV_FS_EVENT,
    UV_FS_POLL,
    UV_HANDLE,
    UV_IDLE,
    UV_NAMED_PIPE,
    UV_POLL,
    UV_PREPARE,
    UV_PROCESS,
    UV_STREAM,
    UV_TCP,
    UV_TIMER,
    UV_TTY,
    UV_UDP,
    UV_SIGNAL,
    UV_FILE,
    UV_HANDLE_TYPE_MAX
}

uv_req_type :: enum c.int {
    UV_UNKNOWN_REQ = 0,
    UV_REQ,
    UV_CONNECT,
    UV_WRITE,
    UV_SHUTDOWN,
    UV_UDP_SEND,
    UV_FS,
    UV_WORK,
    UV_GETADDRINFO,
    UV_GETNAMEINFO,
    UV_REQ_TYPE_MAX,
}

uv_poll_event :: enum c.int {
    UV_READABLE = 1,
    UV_WRITABLE = 2,
    UV_DISCONNECT = 4,
    UV_PRIORITIZED = 8
}

uv_process_flags :: enum c.int {
    UV_PROCESS_SETUID = (1 << 0),
    UV_PROCESS_SETGID = (1 << 1),
    UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 << 2),
    UV_PROCESS_DETACHED = (1 << 3),
    UV_PROCESS_WINDOWS_HIDE = (1 << 4),
    UV_PROCESS_WINDOWS_HIDE_CONSOLE = (1 << 5),
    UV_PROCESS_WINDOWS_HIDE_GUI = (1 << 6)
}

uv_stdio_flags :: enum c.int {
    UV_IGNORE         = 0x00,
    UV_CREATE_PIPE    = 0x01,
    UV_INHERIT_FD     = 0x02,
    UV_INHERIT_STREAM = 0x04,
    UV_READABLE_PIPE  = 0x10,
    UV_WRITABLE_PIPE  = 0x20,
    UV_NONBLOCK_PIPE  = 0x40,
}

uv_tty_mode_t :: enum c.int {
    /* Initial/normal terminal mode */
    UV_TTY_MODE_NORMAL,
    /* Raw input mode (On Windows, ENABLE_WINDOW_INPUT is also enabled) */
    UV_TTY_MODE_RAW,
    /* Binary-safe I/O mode for IPC (Unix-only) */
    UV_TTY_MODE_IO
}

uv_tty_vtermstate_t :: enum c.int {
    /*
     * The console supports handling of virtual terminal sequences
     * (Windows10 new console, ConEmu)
     */
    UV_TTY_SUPPORTED,
    /* The console cannot process virtual terminal sequences.  (Legacy
     * console)
     */
    UV_TTY_UNSUPPORTED
}

uv_udp_flags :: enum c.int {
    /* Disables dual stack mode. */
    UV_UDP_IPV6ONLY = 1,
    /*
    * Indicates message was truncated because read buffer was too small. The
    * remainder was discarded by the OS. Used in uv_udp_recv_cb.
    */
    UV_UDP_PARTIAL = 2,
    /*
    * Indicates if SO_REUSEADDR will be set when binding the handle in
    * uv_udp_bind.
    * This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
    * Unix platforms, it sets the SO_REUSEADDR flag. What that means is that
    * multiple threads or processes can bind to the same address without error
    * (provided they all set the flag) but only the last one to bind will receive
    * any traffic, in effect "stealing" the port from the previous listener.
    */
    UV_UDP_REUSEADDR = 4,
    /*
     * Indicates that the message was received by recvmmsg, so the buffer provided
     * must not be freed by the recv_cb callback.
     */
    UV_UDP_MMSG_CHUNK = 8,
    /*
     * Indicates that the buffer provided has been fully utilized by recvmmsg and
     * that it should now be freed by the recv_cb callback. When this flag is set
     * in uv_udp_recv_cb, nread will always be 0 and addr will always be NULL.
     */
    UV_UDP_MMSG_FREE = 16,
    /*
     * Indicates if IP_RECVERR/IPV6_RECVERR will be set when binding the handle.
     * This sets IP_RECVERR for IPv4 and IPV6_RECVERR for IPv6 UDP sockets on
     * Linux. This stops the Linux kernel from suppressing some ICMP error messages
     * and enables full ICMP error reporting for faster failover.
     * This flag is no-op on platforms other than Linux.
     */
    UV_UDP_LINUX_RECVERR = 32,
    /*
    * Indicates that recvmmsg should be used, if available.
    */
    UV_UDP_RECVMMSG = 256
}

uv_membership :: enum c.int {
    UV_LEAVE_GROUP = 0,
    UV_JOIN_GROUP
}

uv_fs_event :: enum c.int {
    UV_RENAME = 1,
    UV_CHANGE = 2
}

uv_fs_event_flags :: enum c.int {
    /*
    * By default, if the fs event watcher is given a directory name, we will
    * watch for all events in that directory. This flags overrides this behavior
    * and makes fs_event report only changes to the directory entry itself. This
    * flag does not affect individual files watched.
    * This flag is currently not implemented yet on any backend.
    */
    UV_FS_EVENT_WATCH_ENTRY = 1,
    /*
    * By default uv_fs_event will try to use a kernel interface such as inotify
    * or kqueue to detect events. This may not work on remote file systems such
    * as NFS mounts. This flag makes fs_event fall back to calling stat() on a
    * regular interval.
    * This flag is currently not implemented yet on any backend.
    */
    UV_FS_EVENT_STAT = 2,
    /*
    * By default, event watcher, when watching directory, is not registering
    * (is ignoring) changes in its subdirectories.
    * This flag will override this behaviour on platforms that support it.
    */
    UV_FS_EVENT_RECURSIVE = 4
}

uv_fs_type :: enum c.int {
    UV_FS_UNKNOWN = -1,
    UV_FS_CUSTOM,
    UV_FS_OPEN,
    UV_FS_CLOSE,
    UV_FS_READ,
    UV_FS_WRITE,
    UV_FS_SENDFILE,
    UV_FS_STAT,
    UV_FS_LSTAT,
    UV_FS_FSTAT,
    UV_FS_FTRUNCATE,
    UV_FS_UTIME,
    UV_FS_FUTIME,
    UV_FS_ACCESS,
    UV_FS_CHMOD,
    UV_FS_FCHMOD,
    UV_FS_FSYNC,
    UV_FS_FDATASYNC,
    UV_FS_UNLINK,
    UV_FS_RMDIR,
    UV_FS_MKDIR,
    UV_FS_MKDTEMP,
    UV_FS_RENAME,
    UV_FS_SCANDIR,
    UV_FS_LINK,
    UV_FS_SYMLINK,
    UV_FS_READLINK,
    UV_FS_CHOWN,
    UV_FS_FCHOWN,
    UV_FS_REALPATH,
    UV_FS_COPYFILE,
    UV_FS_LCHOWN,
    UV_FS_OPENDIR,
    UV_FS_READDIR,
    UV_FS_CLOSEDIR,
    UV_FS_MKSTEMP,
    UV_FS_LUTIME,
}

NI_MAXHOST :: 1025
NI_MAXSERV :: 32

/* handle types */
uv_loop_t           :: distinct uv_loop_s
uv_handle_t         :: distinct uv_handle_s 
uv_dir_t            :: distinct uv_dir_s     
uv_stream_t         :: distinct uv_stream_s  
uv_tcp_t            :: distinct uv_tcp_s     
uv_udp_t            :: distinct uv_udp_s     
uv_pipe_t           :: distinct uv_pipe_s    
uv_tty_t            :: distinct uv_tty_s     
uv_poll_t           :: distinct uv_poll_s    
uv_timer_t          :: distinct uv_timer_s   
uv_prepare_t        :: distinct uv_prepare_s 
uv_check_t          :: distinct uv_check_s   
uv_idle_t           :: distinct uv_idle_s    
uv_async_t          :: distinct uv_async_s   
uv_process_t        :: distinct uv_process_s 
uv_fs_event_t       :: distinct uv_fs_event_s
uv_fs_poll_t        :: distinct uv_fs_poll_s 
uv_signal_t         :: distinct uv_signal_s

/* request types */
uv_req_t            :: distinct uv_req_s                                 
uv_getaddrinfo_t    :: distinct uv_getaddrinfo_s                         
uv_getnameinfo_t    :: distinct uv_getnameinfo_s                         
uv_shutdown_t       :: distinct uv_shutdown_s                            
uv_write_t          :: distinct uv_write_s                               
uv_connect_t        :: distinct uv_connect_s                             
uv_udp_send_t       :: distinct uv_udp_send_s                            
uv_fs_t             :: distinct uv_fs_s                                  
uv_work_t           :: distinct uv_work_s                                
uv_random_t         :: distinct uv_random_s 

/* None of the above. */ 
uv_env_item_t          :: distinct uv_env_item_s                                        
uv_cpu_info_t          :: distinct uv_cpu_info_s                                        
uv_interface_address_t :: distinct uv_interface_address_s                               
uv_dirent_t            :: distinct uv_dirent_s                                          
uv_passwd_t            :: distinct uv_passwd_s                                          
uv_utsname_t           :: distinct uv_utsname_s                                         
uv_statfs_t            :: distinct uv_statfs_s

uv_process_options_t   :: distinct uv_process_options_s
uv_thread_options_t    :: distinct uv_thread_options_s
uv_stdio_container_t   :: distinct uv_stdio_container_s

uv_any_handle :: union {
    uv_async_t,
    uv_check_t,
    uv_fs_event_t,
    uv_fs_poll_t,
    uv_handle_t,
    uv_idle_t,
    uv_pipe_t,
    uv_poll_t,
    uv_prepare_t,
    uv_process_t,
    uv_stream_t,
    uv_tcp_t,
    uv_timer_t,
    uv_tty_t,
    uv_udp_t,
    uv_signal_t,
}

uv_any_req :: union {
    uv_req_t,        
    uv_getaddrinfo_t,
    uv_getnameinfo_t,
    uv_shutdown_t,   
    uv_write_t,      
    uv_connect_t,    
    uv_udp_send_t,   
    uv_fs_t,         
    uv_work_t,       
    uv_random_t,     
}

uv_dirent_type_t :: enum c.int {
    UV_DIRENT_UNKNOWN,
    UV_DIRENT_FILE,
    UV_DIRENT_DIR,
    UV_DIRENT_LINK,
    UV_DIRENT_FIFO,
    UV_DIRENT_SOCKET,
    UV_DIRENT_CHAR,
    UV_DIRENT_BLOCK
}

//function pointers
uv_alloc_cb         :: distinct proc "c" (handle: ^uv_handle_t, suggested_size: c.size_t, buf: ^uv_buf_t)
uv_close_cb         :: distinct proc "c" (handle: ^uv_handle_t)
uv_walk_cb          :: distinct proc "c" (handle: ^uv_handle_t, arg: rawptr)
uv_timer_cb         :: distinct proc "c" (handle: ^uv_timer_t)
uv_prepare_cb       :: distinct proc "c" (handle: ^uv_prepare_t)
uv_check_cb         :: distinct proc "c" (handle: ^uv_check_t)
uv_idle_cb          :: distinct proc "c" (handle: ^uv_idle_t)
uv_async_cb         :: distinct proc "c" (handle: ^uv_async_t)
uv_poll_cb          :: distinct proc "c" (handle: ^uv_poll_t, status, events: c.int)
uv_signal_cb        :: distinct proc "c" (handle: ^uv_signal_t, signum: c.int)
uv_read_cb          :: distinct proc "c" (stream: ^uv_stream_t, nread: c.ssize_t, buf: ^uv_buf_t)
uv_exit_cb          :: distinct proc "c" (process: ^uv_process_t, exit_status: c.int64_t, term_signal: c.int)
uv_write_cb         :: distinct proc "c" (req: ^uv_write_t, status: c.int)
uv_connect_cb       :: distinct proc "c" (req: ^uv_connect_t, status: c.int)
uv_shutdown_cb      :: distinct proc "c" (req: ^uv_shutdown_t, status: c.int)
uv_connection_cb    :: distinct proc "c" (server: ^uv_stream_t, status: c.int)
uv_udp_send_cb      :: distinct proc "c" (req: ^uv_udp_send_t, status: c.int)
uv_udp_recv_cb      :: distinct proc "c" (handle: ^uv_udp_t, nread: c.ssize_t, buf: ^uv_buf_t, addr: ^linux.Sock_Addr_Any, flags: c.uint)
uv_fs_event_cb      :: distinct proc "c" (handle: ^uv_fs_event_t, filename: cstring, events, status: c.int)
uv_fs_poll_cb       :: distinct proc "c" (handle: ^uv_fs_poll_t, status: c.int, prev: ^uv_stat_t, curr: ^uv_stat_t)
uv_fs_cb            :: distinct proc "c" (req: ^uv_fs_t)
uv_work_cb          :: distinct proc "c" (req: ^uv_work_t)
uv_after_work_cb    :: distinct proc "c" (req: ^uv_work_t, status: c.int)
uv_getaddrinfo_cb   :: distinct proc "c" (req: ^uv_getaddrinfo_t, status: c.int, res: ^addrinfo)
uv_getnameinfo_cb   :: distinct proc "c" (req: ^uv_getaddrinfo_t status: c.int, hostname, service: cstring)
uv_thread_cb        :: distinct proc "c" (arg: rawptr)
uv_malloc_func      :: distinct proc "c" (size: c.size_t) -> rawptr 
uv_realloc_func     :: distinct proc "c" (ptr: rawptr, size: c.size_t) -> rawptr
uv_calloc_func      :: distinct proc "c" (count, size: c.size_t) -> rawptr
uv_free_func        :: distinct proc "c" (ptr: rawptr)
uv_random_cb        :: distinct proc "c" (req: ^uv_random_t, status: c.int, buf: rawptr, buflen: c.size_t)


uv_random_s :: struct {
    using requests: uv_req_t,
    /* read-only */
    loop: ^uv_loop_t,
}

uv_metrics_t :: struct {
    loop_count: c.uint64_t,
    events: c.uint64_t,
    events_waiting: c.uint64_t,
    /* private */
    reserved: [13]^c.uint64_t ,
}

uv_stdio_container_s :: struct {
    flags: uv_stdio_flags,
    data: struct #raw_union {
        stream: ^uv_stream_t,
        fd: c.int,
    }
}

uv_process_options_s :: struct {
    exit_cb: uv_exit_cb,
    file: cstring,
    args: ^cstring,
    env: ^cstring,
    cwd: cstring,
    flags: c.uint,
    stdio_count: c.int,
    stdio: ^uv_stdio_container_t,
    uid: uv_uid_t,
    gid: uv_gid_t,
}

flag :: enum c.int {
    UV_THREAD_NO_FLAGS = 0x00,
    UV_THREAD_HAS_STACK_SIZE = 0x01,
}
uv_thread_options_s :: struct {
    flags: flag,
    stack_size: c.size_t,
}

uv_timespec_t :: struct {
    tv_sec: c.long,
    tv_nsec: c.long,
}

uv_stat_t :: struct {
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
    st_atim: uv_timespec_t, 
    st_mtim: uv_timespec_t, 
    st_ctim : uv_timespec_t,
    st_birthtim: uv_timespec_t, 
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
    type: uv_dirent_type_t, 
}

uv_dir_s :: struct {
    dirents: ^uv_dirent_t,
    nentries: c.size_t,
}

uv_work_s :: struct {
    using request: uv_req_t,
    loop: ^uv_loop_t,
}

uv_getaddrinfo_s :: struct {
    using request: uv_req_t,
    loop: ^uv_loop_t,
    addrinfo: ^addrinfo,
}

uv_getnameinfo_s :: struct {
    using request: uv_req_t,
    loop: ^uv_loop_t,
    host: [NI_MAXHOST]c.char,
    service: [NI_MAXSERV]c.char,
}

uv_loop_s :: struct {
    data: rawptr,
}

uv_handle_s :: struct {
    data: rawptr,                                                                                                                    
    loop: ^uv_loop_t,                                                        
    type: uv_handle_type,                                                                                                           
}

uv_req_s :: struct {
    data: rawptr,
    type: uv_req_type,
}

uv_timer_s :: struct {
    using handle: uv_handle_t,  
}

uv_prepare_s :: struct {
    using handle: uv_handle_t,
}

uv_check_s :: struct {
    using handle: uv_handle_t,                                                                                                           
}

uv_idle_s :: struct {
    using handle: uv_handle_t,                                                                                                            
}

uv_async_s :: struct {
    using handle: uv_handle_t,                                                                                                            
}

uv_poll_s :: struct {
    using handle: uv_handle_t,                                                                                                            
}

uv_signal_s :: struct {
    signum: c.int,
    using handle: uv_handle_t,                                                                                                            
}

uv_process_s :: struct {
    using handle: uv_handle_t,
    exit_cb: uv_exit_cb,
    pid: c.int,                                                                                                        
}

uv_stream_s :: struct {
    using handle: uv_handle_t,   
    write_queue_size: c.size_t,                                                    
    alloc_cb: uv_alloc_cb,                                     
    read_cb: uv_read_cb,
}

uv_connect_s :: struct {
    using request: uv_req_t,
    cb: uv_connect_cb,
    handle: ^uv_stream_t,
}

uv_shutdown_s :: struct {
    using request: uv_req_t,
    handle: ^uv_stream_t,
    cb: uv_shutdown_cb,
}

uv_write_s :: struct {
    using request: uv_req_t,
    cb: uv_write_cb,
    send_handle: ^uv_stream_t,
    handle: ^uv_stream_t,
}

uv_tcp_s :: struct {
    using stream: uv_stream_t,
}

uv_pipe_s :: struct {
    using stream: uv_stream_t,
    ipc: c.int,
}

uv_tty_s :: struct {
    using stream: uv_stream_t,
}

uv_udp_s :: struct {
    using handle: uv_handle_t,
    send_queue_size: c.size_t,
    send_queue_count: c.size_t,
}

uv_udp_send_s :: struct {
    using request: uv_req_t,
    handle: ^uv_udp_t,
    cb: uv_udp_send_cb,
}

uv_fs_event_s :: struct {
    using handle: uv_handle_t,
}

uv_fs_poll_s :: struct {
    using handle: uv_handle_t,
}

//filesystem utilities
uv_fs_s :: struct {
    using request: uv_req_t,
    loop: ^uv_loop_t,
    fs_type: uv_fs_type,
    path: cstring,
    result: c.ssize_t,
    statbuf: uv_stat_t,
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
    
    //uv_loop_t procedures
    loop_init           :: proc (loop: ^uv_loop_t) -> c.int ---
    run                 :: proc (loop: ^uv_loop_t, mode: uv_run_mode) -> c.int ---
    loop_close          :: proc (loop: ^uv_loop_t) -> c.int ---
    default_loop        :: proc ()                 -> ^uv_loop_t  ---
    loop_alive          :: proc (loop: ^uv_loop_t) -> c.int ---
    stop                :: proc (loop: ^uv_loop_t) ---
    loop_size           :: proc ()                 -> c.size_t ---
    backend_fd          :: proc (loop: ^uv_loop_t) -> c.int ---
    backend_timeout     :: proc (loop: ^uv_loop_t) -> c.int ---
    now                 :: proc (loop: ^uv_loop_t) -> c.uint64_t ---
    update_time         :: proc (loop: ^uv_loop_t) ---
    walk                :: proc (loop: ^uv_loop_t, walk_cb: uv_walk_cb, arg: rawptr) ---
    loop_fork           :: proc (loop: ^uv_loop_t) -> c.int ---
    loop_get_data       :: proc (loop: ^uv_loop_t) -> rawptr ---
    loop_set_data       :: proc (loop: ^uv_loop_t, data: rawptr) -> rawptr ---

    //uv_handle_t
    is_active           :: proc (handle: ^uv_handle_t) -> c.int ---
    is_closing          :: proc (handle: ^uv_handle_t) -> c.int ---
    close               :: proc (handle: ^uv_handle_t, close_cb: uv_close_cb) ---
    ref                 :: proc (handle: ^uv_handle_t) ---
    unref               :: proc (handle: ^uv_handle_t) ---
    has_ref             :: proc (handle: ^uv_handle_t) -> c.int ---
    handle_size         :: proc (type: uv_handle_type) -> c.size_t ---
    send_buffer_size    :: proc (handle: ^uv_handle_t, value: ^c.int) -> c.int ---
    recv_buffer_size    :: proc (handle: ^uv_handle_t, value: ^c.int) -> c.int ---
    fileno              :: proc (handle: ^uv_handle_t, fd: ^uv_os_fd_t) -> c.int ---
    handle_get_loop     :: proc (handle: ^uv_handle_t) -> ^uv_loop_t ---
    handle_get_data     :: proc (handle: ^uv_handle_t) -> rawptr ---
    handle_set_data     :: proc (handle: ^uv_handle_t, data: rawptr) -> rawptr ---
    handle_get_type     :: proc (handle: ^uv_handle_t) -> uv_handle_type ---
    handle_type_name    :: proc (type: uv_handle_type) -> cstring ---

    //uv_req_t
    cancel              :: proc (req: ^uv_req_t) -> c.int ---
    req_size            :: proc (type: uv_req_type) -> c.size_t ---
    req_get_data        :: proc (req: ^uv_req_t) -> rawptr ---
    req_set_data        :: proc (req: ^uv_req_t, data: rawptr) -> rawptr ---
    req_get_type        :: proc (req: ^uv_req_t) -> uv_req_type ---
    req_type_name       :: proc (type: uv_req_type) -> cstring ---

    //uv_timer_t
    timer_init          :: proc (loop: ^uv_loop_t, handle: ^uv_timer_t) -> c.int --- 
    timer_start         :: proc (handle: ^uv_timer_t, cb: uv_timer_cb, timeout: c.uint64_t, repeat: c.uint64_t) -> c.int --- 
    timer_stop          :: proc (handle: ^uv_timer_t) -> c.int --- 
    timer_again         :: proc (handle: ^uv_timer_t) -> c.int --- 
    timer_set_repeat    :: proc (handle: ^uv_timer_t, repeat: c.uint64_t) ---
    timer_get_repeat    :: proc (handle: ^uv_timer_t) -> c.uint64_t ---
    timer_get_due_in    :: proc (handle: ^uv_timer_t) -> c.uint64_t ---

    //uv_prepare_t
    prepare_init        :: proc (loop: ^uv_loop_t, prepare: ^uv_prepare_t) -> c.int ---
    prepare_start       :: proc (prepare: ^uv_prepare_t, cb: uv_prepare_cb) -> c.int ---
    prepare_stop        :: proc (prepare: ^uv_prepare_t) -> c.int ---
    
    //uv_check_t    
    check_init          :: proc (loop: ^uv_loop_t, check: ^uv_check_t) -> c.int ---
    check_start         :: proc (check: ^uv_check_t, cb: uv_check_cb) -> c.int ---
    check_stop          :: proc (check: ^uv_check_t) -> c.int ---
        
    //uv_idle_t 
    idle_init           :: proc (loop: ^uv_loop_t, idle: ^uv_idle_t) -> c.int ---
    idle_start          :: proc (idle: ^uv_idle_t, cb: uv_idle_cb) -> c.int ---
    idle_stop           :: proc (idle: ^uv_idle_t) -> c.int ---
    
    //uv_async_t
    async_init          :: proc (loop: ^uv_loop_t, async: ^uv_async_t, async_cb: uv_async_cb) -> c.int ---
    async_send          :: proc (async: ^uv_async_t) -> c.int ---

    //uv_poll_t
    poll_init           :: proc (loop: ^uv_loop_t, handle: ^uv_poll_t, fd: c.int) -> c.int ---
    poll_init_socket    :: proc (loop: ^uv_loop_t, handle: ^uv_poll_t, socket: uv_os_sock_t) -> c.int ---
    poll_start          :: proc (handle: ^uv_poll_t, events: c.int, cb: uv_poll_cb) -> c.int ---
    poll_stop           :: proc (poll: ^uv_poll_t) -> c.int ---

    //uv_signal_t
    signal_init         :: proc (loop: ^uv_loop_t, signal: ^uv_signal_t) -> c.int ---
    signal_start        :: proc (signal: ^uv_signal_t, cb: uv_signal_cb, signum: c.int) -> c.int ---
    signal_start_oneshot:: proc (signal: ^uv_signal_t, cb: uv_signal_cb, signum: c.int) -> c.int ---
    signal_stop         :: proc (signal: ^uv_signal_t) -> c.int ---

    //uv_process_t
    disable_stdio_inheritance :: proc() ---
    spawn               :: proc (loop: ^uv_loop_t, handle: ^uv_process_t, options: ^uv_process_options_t) -> c.int ---
    process_kill        :: proc (handle: ^uv_process_t, signum: c.int) -> c.int ---
    kill                :: proc (pid: c.int, signum: c.int) -> c.int ---
    process_get_pid     :: proc (handle: ^uv_process_t) -> uv_pid_t ---

    //uv_stream_t
    shutdown            :: proc (req: ^uv_shutdown_t, handle: ^uv_stream_t, cb: uv_shutdown_cb) -> c.int ---
    listen              :: proc (stream: ^uv_stream_t, backlog: c.int, cb: uv_connection_cb) -> c.int ---
    accept              :: proc (server: ^uv_stream_t, client: ^uv_stream_t) -> c.int ---
    read_start          :: proc (stream: ^uv_stream_t, alloc_cb: uv_alloc_cb, read_cb: uv_read_cb) -> c.int ---
    read_stop           :: proc (stream: ^uv_stream_t) -> c.int ---
    write               :: proc (req: ^uv_write_t, handle: ^uv_stream_t, bufs: []uv_buf_t, nbufs: c.uint, cb: uv_write_cb) -> c.int ---
    write2              :: proc (req: ^uv_write_t, handle: ^uv_stream_t, bufs: []uv_buf_t, nbufs: c.uint, send_handle: ^uv_stream_t, cb: uv_write_cb) -> c.int ---
    try_write           :: proc (handle: ^uv_stream_t, bufs: []uv_buf_t, nbufs: c.uint) -> c.int ---
    try_write2          :: proc (handle: ^uv_stream_t, bufs: []uv_buf_t, nbufs: c.uint, send_handle: ^uv_stream_t) -> c.int ---
    is_readable         :: proc (handle: ^uv_stream_t) -> c.int ---
    is_writable         :: proc (handle: ^uv_stream_t) -> c.int ---
    stream_set_blocking :: proc (handle: ^uv_stream_t, blocking: c.int) -> c.int ---
    stream_get_write_queue_size :: proc (stream: ^uv_stream_t) -> c.size_t ---

    //uv_tcp_t
    tcp_init            :: proc (loop: ^uv_loop_t, handle: ^uv_tcp_t) -> c.int ---
    tcp_init_ex         :: proc (loop: ^uv_loop_t, handle: ^uv_tcp_t, flags: c.uint) -> c.int ---
    tcp_open            :: proc (handle: ^uv_tcp_t, sock: uv_os_sock_t) -> c.int ---
    tcp_nodelay         :: proc (handle: ^uv_tcp_t, enable: c.int) -> c.int ---
    tcp_keepalive       :: proc (handle: ^uv_tcp_t, enable: c.int, delay: c.uint) -> c.int ---
    tcp_simultaneous_accepts :: proc (handle: ^uv_tcp_t, enable: c.int) -> c.int ---
    tcp_bind            :: proc (handle: ^uv_tcp_t, addr: ^linux.Sock_Addr_Any, flags: c.uint) -> c.int ---
    tcp_getsockname     :: proc (handle: ^uv_tcp_t, name: ^linux.Sock_Addr_Any, namelen: ^c.int) -> c.int ---
    tcp_getpeername     :: proc (handle: ^uv_tcp_t, name: ^linux.Sock_Addr_Any, namelen: ^c.int) -> c.int ---
    tcp_connect         :: proc (req: ^uv_connect_t, handle: ^uv_tcp_t, addr: ^linux.Sock_Addr_Any, cb: uv_connect_cb) -> c.int ---
    tcp_close_reset     :: proc (handle: ^uv_tcp_t, close_cb: uv_close_cb) -> c.int ---
    socketpair          :: proc (protocol, type: c.int, socket_vector: [2]uv_os_sock_t, flags0, flags1: c.int) -> c.int ---

    //uv_pipe_t
    pipe_init           :: proc (loop: ^uv_loop_t, handle: ^uv_pipe_t, ipc: c.int) -> c.int ---
    pipe_open           :: proc (handle: ^uv_pipe_t, file: uv_file) -> c.int ---
    pipe_bind           :: proc (handle: ^uv_pipe_t, name: cstring) -> c.int ---
    pipe_bind2          :: proc (handle: ^uv_pipe_t, name: cstring, namelen: c.size_t, flags: c.uint) -> c.int ---
    pipe_connect        :: proc (req: ^uv_connect_t, handle: ^uv_pipe_t, name: cstring, cb: uv_connect_cb) ---
    pipe_connect2       :: proc (req: ^uv_connect_t, handle: ^uv_pipe_t, name: cstring, namelen: c.size_t, flags: c.uint, cb: uv_connect_cb) ---
    pipe_getsockname    :: proc (handle: ^uv_pipe_t, buffer: cstring, size: c.size_t) -> c.int ---
    pipe_getpeername    :: proc (handle: ^uv_pipe_t, buffer: cstring, size: c.size_t) -> c.int ---
    pipe_pending_instances :: proc (handle: ^uv_pipe_t, count: c.int) ---
    pipe_pending_count  :: proc (handle: ^uv_pipe_t) -> c.int ---
    pipe_pending_type   :: proc (handle: ^uv_pipe_t) -> uv_handle_type ---
    pipe_chmod          :: proc (handle: ^uv_pipe_t, flags: c.int) -> c.int ---
    pipe                :: proc (fds: [2]uv_file, read_flags, write_flags: c.int) -> c.int ---

    //uv_tty_t
    tty_init            :: proc (loop: ^uv_loop_t, handle: ^uv_tty_t, fd: uv_file, unused: c.int) -> c.int ---
    tty_set_mode        :: proc (handle: ^uv_tty_t, mode: uv_tty_mode_t) -> c.int ---
    tty_reset_mode      :: proc () -> c.int ---
    tty_get_winsize     :: proc (handle: ^uv_tty_t, width, height: ^c.int) -> c.int ---
    tty_set_vterm_state :: proc (state: uv_tty_vtermstate_t) ---
    tty_get_vterm_state :: proc (state: ^uv_tty_vtermstate_t) -> c.int ---

    //uv_udp_t
    udp_init            :: proc (loop: ^uv_loop_t, handle: ^uv_udp_t) -> c.int ---
    udp_init_ex         :: proc (loop: ^uv_loop_t, handle: ^uv_udp_t, flags: c.uint) -> c.int ---
    udp_open            :: proc (handle: ^uv_udp_t, sock: uv_os_sock_t) -> c.int ---
    udp_bind            :: proc (handle: ^uv_udp_t, addr: ^linux.Sock_Addr_Any, flags: c.int) -> c.int ---
    udp_connect         :: proc (handle: ^uv_udp_t, addr: ^linux.Sock_Addr_Any) -> c.int ---
    udp_getpeername     :: proc (handle: ^uv_udp_t, name: ^linux.Sock_Addr_Any, namelen: ^c.int) -> c.int ---
    udp_getsockname     :: proc (handle: ^uv_udp_t, name: ^linux.Sock_Addr_Any, namelen: ^c.int) -> c.int ---
    udp_set_membership  :: proc (handle: ^uv_udp_t, multicast_addr: cstring, interface_addr: cstring, membership: uv_membership) -> c.int ---
    udp_set_source_membership :: proc (handle: ^uv_udp_t, multicast_addr: cstring, interface_addr: cstring, source_addr: cstring, membership: uv_membership) -> c.int ---
    udp_set_multicast_loop :: proc (handle: ^uv_udp_t, on: c.int) -> c.int ---
    udp_set_multicast_ttl :: proc (handle: ^uv_udp_t, ttl: c.int) -> c.int ---
    udp_set_multicast_interface :: proc (handle: ^uv_udp_t, interface_addr: cstring) -> c.int ---
    udp_set_broadcast   :: proc (handle: ^uv_udp_t, on: c.int) -> c.int ---
    udp_set_ttl         :: proc (handle: ^uv_udp_t, ttl: c.int) -> c.int ---
    udp_send            :: proc (req: uv_udp_send_t, handle: ^uv_udp_t, bufs: []uv_buf_t , nbufs: c.uint, addr: ^linux.Sock_Addr_Any, send_cb: uv_udp_send_cb) -> c.int ---
    udp_try_send        :: proc (handle: ^uv_udp_t, bufs: []uv_buf_t, nbufs: c.uint, addr: ^linux.Sock_Addr_Any) -> c.int ---
    udp_recv_start      :: proc (handle: ^uv_udp_t, alloc_cb: uv_alloc_cb, recv_cb: uv_udp_recv_cb) -> c.int ---
    udp_using_recvmmsg  :: proc (handle: ^uv_udp_t) -> c.int ---
    udp_recv_stop       :: proc (handle: ^uv_udp_t) -> c.int ---
    udp_get_send_queue_size :: proc (handle: ^uv_udp_t) -> c.size_t ---
    udp_get_send_queue_count :: proc (handle: ^uv_udp_t) -> c.size_t ---

    //uv_fs_event_t
    fs_event_init       :: proc (loop: ^uv_loop_t, handle: ^uv_fs_event_t) -> c.int ---
    fs_event_start      :: proc (handle: ^uv_fs_event_t, cb: uv_fs_event_cb, path: cstring, flags: c.uint) -> c.int ---
    fs_event_stop       :: proc (handle: ^uv_fs_event_t) -> c.int ---
    fs_event_getpath    :: proc (handle: ^uv_fs_event_t, buffer: cstring, size: ^c.size_t) -> c.int ---

    //uv_fs_poll_t
    fs_poll_init        :: proc (loop: ^uv_loop_t, handle: ^uv_fs_poll_t) -> c.int ---
    fs_poll_start       :: proc (handle: ^uv_fs_poll_t, poll_cb: uv_fs_poll_cb, path: cstring, interval: c.uint) -> c.int ---
    fs_poll_stop        :: proc (handle: ^uv_fs_poll_t) -> c.int ---
    fs_poll_getpath     :: proc (handle: ^uv_fs_poll_t, buffer: cstring, size: ^c.size_t) -> c.int ---

    //filesystem utilities
    fs_req_cleanup      :: proc (req: ^uv_fs_t) ---
    fs_close            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, cb: uv_fs_cb) -> c.int ---
    fs_open             :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, flags, mode: c.int, cb: uv_fs_cb) -> c.int ---
    fs_read             :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, bufs: []uv_buf_t , nbufs: c.uint, offset: c.int64_t, cb: uv_fs_cb) -> c.int ---
    fs_unlink           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_write            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, bufs: []uv_buf_t , nbufs: c.uint, offset: c.int64_t, cb: uv_fs_cb) -> c.int ---
    fs_mkdir            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, mode: c.int, cb: uv_fs_cb) -> c.int ---
    fs_mkdtemp          :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, tpl: cstring, cb: uv_fs_cb) -> c.int ---
    fs_mkstemp          :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, tpl: cstring, cb: uv_fs_cb) -> c.int ---
    fs_rmdir            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_opendir          :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_closedir         :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, dir: ^uv_dir_t, cb: uv_fs_cb) -> c.int ---
    fs_readdir          :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, dir: ^uv_dir_t, cb: uv_fs_cb) -> c.int ---
    fs_scandir          :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, flags: c.int, cb: uv_fs_cb) -> c.int ---
    fs_scandir_next     :: proc (req: ^uv_fs_t, ent: ^uv_dirent_t) -> c.int ---
    fs_stat             :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_fstat            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, cb: uv_fs_cb) -> c.int ---
    fs_lstat            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_statfs           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_rename           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, new_path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_fsync            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, cb: uv_fs_cb) -> c.int ---
    fs_fdatasync        :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, cb: uv_fs_cb) -> c.int ---
    fs_ftruncate        :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, offset: c.int64_t, cb: uv_fs_cb) -> c.int ---
    fs_copyfile         :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, new_path: cstring, flags: c.int, cb: uv_fs_cb) -> c.int ---
    fs_sendfile         :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, out_fd, in_fd: uv_file, in_offset: c.int64_t, length: c.size_t, cb: uv_fs_cb) -> c.int ---
    fs_access           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, mode: c.int, cb: uv_fs_cb) -> c.int ---
    fs_chmod            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, mode: c.int, cb: uv_fs_cb) -> c.int ---
    fs_fchmod           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, mode: c.int, cb: uv_fs_cb) -> c.int ---
    fs_utime            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, atime, mtime: c.double, cb: uv_fs_cb) -> c.int ---
    fs_futime           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, atime, mtime: c.double, cb: uv_fs_cb) -> c.int ---
    fs_lutime           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, atime, mtime: c.double, cb: uv_fs_cb) -> c.int ---
    fs_link             :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, new_path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_symlink          :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, new_path: cstring, flags: c.int, cb: uv_fs_cb) -> c.int ---
    fs_readlink         :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_realpath         :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, cb: uv_fs_cb) -> c.int ---
    fs_chown            :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, uid: uv_uid_t, gid: uv_gid_t, cb: uv_fs_cb) -> c.int ---
    fs_fchown           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, file: uv_file, uid: uv_uid_t, gid: uv_gid_t, cb: uv_fs_cb) -> c.int ---
    fs_lchown           :: proc (loop: ^uv_loop_t, req: ^uv_fs_t, path: cstring, uid: uv_uid_t, gid: uv_gid_t, cb: uv_fs_cb) -> c.int ---
    fs_get_type         :: proc (req: ^uv_fs_t) -> uv_fs_type ---
    fs_get_result       :: proc (req: ^uv_fs_t) -> c.ssize_t ---
    fs_get_system_error :: proc (req: ^uv_fs_t) -> c.int ---
    fs_get_ptr          :: proc (req: ^uv_fs_t) -> rawptr ---
    fs_get_path         :: proc (req: ^uv_fs_t) -> cstring ---
    fs_get_statbuf      :: proc (req: ^uv_fs_t) -> ^uv_stat_t ---
    get_osfhandle       :: proc (fd: c.int) -> uv_os_fd_t ---
    open_osfhandle      :: proc (os_fd: uv_os_fd_t) -> c.int ---

    //Thread pool work scheduling
    queue_work          :: proc (loop: ^uv_loop_t, req: ^uv_work_t, work_cb: uv_work_cb, after_work_cb: uv_after_work_cb) -> c.int ---

    //DNS utility
    getaddrinfo         :: proc (loop: ^uv_loop_t, req: ^uv_getaddrinfo_t, getaddrinfo_cb: uv_getaddrinfo_cb , node, service: cstring, hints: ^addrinfo) -> c.int ---
    freeaddrinfo        :: proc (ai: ^addrinfo) ---
    getnameinfo         :: proc (loop: ^uv_loop_t, req: ^uv_getaddrinfo_t, getnameinfo_cb: uv_getnameinfo_cb , addr: ^linux.Sock_Addr_Any, flags: c.int) -> c.int ---

    //shared library handling
    dlopen              :: proc (filename: cstring, lib: ^uv_lib_t) -> c.int ---
    dlclose             :: proc (lib: ^uv_lib_t) ---
    dlsym               :: proc (lib: ^uv_lib_t, name: cstring, ptr: ^rawptr) -> c.int ---
    dlerror             :: proc (lib: ^uv_lib_t) -> cstring ---

    //Threading and synchronization utilities
    thread_create       :: proc (tid: ^uv_thread_t, entry: uv_thread_cb, arg: rawptr) -> c.int ---
    thread_create_ex    :: proc (tid: ^uv_thread_t, params: ^uv_thread_options_t, entry: uv_thread_cb, arg: rawptr) -> c.int ---
    thread_setaffinity  :: proc (tid: ^uv_thread_t, cpumask, oldmask: cstring, mask_size: c.size_t) -> c.int ---
    thread_getaffinity  :: proc (tid: ^uv_thread_t, cpumask: cstring, mask_size: c.size_t) -> c.int ---
    thread_getcpu       :: proc () -> c.int ---
    thread_self         :: proc () ---
    thread_join         :: proc (tid: ^uv_thread_t) -> c.int ---
    thread_equal        :: proc (t1: ^uv_thread_t, t2: ^uv_thread_t) -> c.int ---
    thread_setpriority  :: proc (tid: uv_thread_t, priority: c.int) -> c.int ---
    thread_getpriority  :: proc (tid: uv_thread_t, priority: ^c.int) -> c.int ---
    key_create          :: proc (key: ^uv_key_t) ---
    key_delete          :: proc (key: ^uv_key_t) ---
    key_get             :: proc (key: ^uv_key_t) ---
    key_set             :: proc (key: ^uv_key_t, value: rawptr) ---

    // i don't know how to convert this to odin
    /* void uv_once(uv_once_t *guard, void (*callback)(void)) */

    mutex_init          :: proc (handle: ^uv_mutex_t) -> c.int ---
    mutex_init_recursive :: proc (handle: ^uv_mutex_t) -> c.int ---
    mutex_destroy       :: proc (handle: ^uv_mutex_t) ---
    mutex_lock          :: proc (handle: ^uv_mutex_t) ---
    mutex_trylock       :: proc (handle: ^uv_mutex_t) -> c.int ---
    mutex_unlock        :: proc (handle: ^uv_mutex_t) ---
    rwlock_init         :: proc (rwlock: ^uv_rwlock_t) -> c.int ---
    rwlock_destroy      :: proc (rwlock: ^uv_rwlock_t) ---
    rwlock_rdlock       :: proc (rwlock: ^uv_rwlock_t) ---
    rwlock_tryrdlock    :: proc (rwlock: ^uv_rwlock_t) -> c.int ---
    rwlock_rdunlock     :: proc (rwlock: ^uv_rwlock_t) ---
    rwlock_wrlock       :: proc (rwlock: ^uv_rwlock_t) ---
    rwlock_trywrlock    :: proc (rwlock: ^uv_rwlock_t) -> c.int ---
    rwlock_wrunlock     :: proc (rwlock: ^uv_rwlock_t) ---
    sem_init            :: proc (sem: ^uv_sem_t, value: c.uint) -> c.int ---
    sem_destroy         :: proc (sem: ^uv_sem_t) ---
    sem_post            :: proc (sem: ^uv_sem_t) ---
    sem_wait            :: proc (sem: ^uv_sem_t) ---
    sem_trywait         :: proc (sem: ^uv_sem_t) -> c.int ---
    cond_init           :: proc (cond: ^uv_cond_t) -> c.int ---
    cond_destroy        :: proc (cond: ^uv_cond_t) ---
    cond_signal         :: proc (cond: ^uv_cond_t) ---
    cond_broadcast      :: proc (cond: ^uv_cond_t) ---
    cond_wait           :: proc (cond: ^uv_cond_t, mutex: ^uv_mutex_t) ---
    cond_timedwait      :: proc (cond: ^uv_cond_t, mutex: ^uv_mutex_t, timeout: c.uint64_t) -> c.int ---
    barrier_init        :: proc (barrier: ^uv_barrier_t, count: c.uint) -> c.int ---
    barrier_destroy     :: proc (barrier: ^uv_barrier_t) ---
    barrier_wait        :: proc (barrier: ^uv_barrier_t) -> c.int ---

    //miscellanous utilities
    guess_handle        :: proc (file: uv_file) -> uv_handle_type ---
    replace_allocator   :: proc (malloc_func: uv_malloc_func, realloc_func: uv_realloc_func, calloc_func: uv_calloc_func, free_func: uv_free_func) -> c.int ---
    library_shutdown    :: proc () ---
    buf_init            :: proc (base: cstring, len: c.uint) -> uv_buf_t ---
    setup_args          :: proc (argc: c.int, argv: [^]c.char) -> ^cstring ---
    get_process_title   :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    set_process_title   :: proc (title: cstring) -> c.int ---
    resident_set_memory :: proc (rss: ^c.size_t) -> c.int ---
    uptime              :: proc (uptime: ^c.double) -> c.int ---
    getrusage           :: proc (rusage: ^uv_rusage_t) -> c.int ---
    os_getpid           :: proc () -> uv_pid_t ---
    os_getppid          :: proc () -> uv_pid_t ---
    available_parallelism :: proc () -> c.uint ---
    cpu_info            :: proc (cpu_infos: [^]uv_cpu_info_t, count: ^c.int) -> c.int ---
    free_cpu_info       :: proc (cpu_infos: ^uv_cpu_info_t, count: c.int) ---
    cpumask_size        :: proc () -> c.int ---
    interface_addresses :: proc (addresses: [^]uv_interface_address_t, count: ^c.int) -> c.int ---
    free_interface_addresses :: proc (addresses: ^uv_interface_address_t, count: c.int) ---
    loadavg             :: proc (avg: [3]c.double) ---
    ip4_addr            :: proc (ip: cstring, port: c.int, addr: ^linux.Sock_Addr_In) -> c.int ---
    ip6_addr            :: proc (ip: cstring, port: c.int, addr: ^linux.Sock_Addr_In6) -> c.int ---
    ip4_name            :: proc (src: ^linux.Sock_Addr_In, dst: cstring, size: c.size_t) -> c.int ---
    ip6_name            :: proc (src: ^linux.Sock_Addr_In6, dst: cstring, size: c.size_t) -> c.int ---
    ip_name             :: proc (src: ^linux.Sock_Addr_Any, dst: cstring, size: c.size_t) -> c.int ---
    inet_ntop           :: proc (af: c.int src: rawptr, dst: cstring, size: c.size_t) -> c.int ---
    inet_pton           :: proc (af: c.int, src: cstring, dst: rawptr) -> c.int ---
    if_indextoname      :: proc (ifindex: c.uint, buffer: cstring, size: c.size_t) -> c.int ---
    if_indextoiid       :: proc (ifindex: c.uint, buffer: cstring, size: c.size_t) -> c.int ---
    exepath             :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    cwd                 :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    chdir               :: proc (dir: cstring) -> c.int ---
    os_homedir          :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    os_tmpdir           :: proc (buffer: cstring, size: c.size_t) -> c.int ---
    os_get_passwd       :: proc (pwd: ^uv_passwd_t) -> c.int ---
    os_free_passwd      :: proc (pwd: ^uv_passwd_t) ---
    get_free_memory     :: proc () -> c.uint64_t ---
    get_total_memory    :: proc () -> c.uint64_t ---
    get_constrained_memory :: proc () -> c.uint64_t ---
    get_available_memory :: proc () -> c.uint64_t ---
    hrtime              :: proc () -> c.uint64_t ---
    clock_gettime       :: proc (clock_id: uv_clock_id, ts: ^uv_timespec64_t) -> c.int ---
    print_all_handles   :: proc (loop: ^uv_loop_t, stream: ^os.Handle) ---
    print_active_handles :: proc (loop: ^uv_loop_t, stream: ^os.Handle) ---
    os_environ          :: proc (envitems: [^]uv_env_item_t, count: ^c.int) -> c.int ---
    os_free_environ     :: proc (envitems: ^uv_env_item_t, count: c.int) ---
    os_getenv           :: proc (name: cstring, buffer: cstring, size: c.size_t) -> c.int ---
    os_setenv           :: proc (name: cstring, value: cstring) -> c.int ---
    os_unsetenv         :: proc (name: cstring) -> c.int ---
    os_gethostname      :: proc (buffer: cstring, size: ^c.size_t) -> c.int ---
    os_getpriority      :: proc (pid: uv_pid_t, priority: ^c.int) -> c.int ---
    os_setpriority      :: proc (pid: uv_pid_t, priority: c.int) -> c.int ---
    os_uname            :: proc (buffer: ^uv_utsname_t) -> c.int ---
    gettimeofday        :: proc (tv: ^uv_timeval64_t) -> c.int ---
    random              :: proc (loop: ^uv_loop_t, req: ^uv_random_t, buf: rawptr, buflen: c.size_t, flags: c.uint, cb: uv_random_cb) -> c.int ---
    sleep               :: proc (msec: c.uint) ---

    //string manipulation function
    utf16_length_as_wtf8    :: proc (utf16: c.uint16_t, utf16_len: c.ssize_t) -> c.size_t ---
    utf16_to_wtf8           :: proc (utf16: c.uint16_t, utf16_len: c.ssize_t, wtf8_ptr: [^]c.char, wtf8_len_ptr: ^c.size_t) -> c.int ---
    wtf8_length_as_utf16    :: proc (wtf8: cstring) -> c.ssize_t ---
    wtf8_to_utf16           :: proc (utf8: cstring, utf16: c.uint16_t, utf16_len: c.size_t) ---
    
    //metrics operation
    metrics_idle_time   :: proc (loop: ^uv_loop_t) -> c.uint64_t ---
    metrics_info        :: proc (loop: ^uv_loop_t, metrics: ^uv_metrics_t) -> c.int ---

}
