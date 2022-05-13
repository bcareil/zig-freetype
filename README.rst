zig-freetype
============

Zig bindings for `freetype2`_.

.. _freetype2: https://gitlab.freedesktop.org/freetype/freetype

Development Status
------------------

The aim is to support multiple platforms and cross compilation through zig's
build system.

However, it currently is very rough and only tested on a select few platforms.

This is also currently only leveraging zig's ``@cImport`` feature but the goal
is to offer someting much closer to what's expected from a zig API. Namely:

- Proper error reporting

- Support for user provided allocator

- Remove dependency on libc where possible by allowing the user to provide
  replacements for syscalls.


Usage
-----

Would a copy of this repository be available in a ``third_party/zig-freetype``
directory, one would need the following added to their build.zig::

    // load zig-freetype's build.zig
    const freetype = @import("third_party/zig-freetype/build.zig");

    pub fn build(b: *std.build.Builder) void {
        // ...
        // assuming const exe = b.addExecutable(...);
        freetype.addLibFreeType(exe);
        exe.addPackage(freetype.pkg);
        // ...
        // exe.install()
        // ...
    }
