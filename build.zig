const std = @import("std");

pub const pkg = std.build.Pkg{
    .name = "freetype",
    .path = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = null,
};

fn thisDir() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary("zig-freetype", "src/main.zig");
    lib.setBuildMode(mode);
    _ = buildFreetypeFor(lib) catch unreachable;
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    buildExample(b, target, mode);
}

pub fn buildExample(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) void {
    const example = b.addExecutable("example", "example/main.zig");
    example.setBuildMode(mode);
    example.setTarget(target);
    addFreetype(example) catch unreachable;
    example.install();

    // run step
    const example_run = example.run();
    example_run.cwd = "./example/";
    const run_example = b.step("run-example", "Run example");
    run_example.dependOn(&example_run.step);

    // add some tests!
}

const ft2_root = thisDir() ++ "/third_party/freetype/";

const ft2_srcs: []const []const u8 = &.{
    "src/autofit/autofit.c",
    "src/base/ftbase.c",
    "src/base/ftbbox.c",
    "src/base/ftbdf.c",
    "src/base/ftbitmap.c",
    "src/base/ftcid.c",
    "src/base/ftfstype.c",
    "src/base/ftgasp.c",
    "src/base/ftglyph.c",
    "src/base/ftgxval.c",
    "src/base/ftinit.c",
    "src/base/ftmm.c",
    "src/base/ftotval.c",
    "src/base/ftpatent.c",
    "src/base/ftpfr.c",
    "src/base/ftstroke.c",
    "src/base/ftsynth.c",
    "src/base/ftsystem.c", // we will provide our own primitives
    "src/base/fttype1.c",
    "src/base/ftwinfnt.c",
    "src/bdf/bdf.c",
    "src/bzip2/ftbzip2.c",
    "src/cache/ftcache.c",
    "src/cff/cff.c",
    "src/cid/type1cid.c",
    "src/gzip/ftgzip.c",
    "src/lzw/ftlzw.c",
    "src/pcf/pcf.c",
    "src/pfr/pfr.c",
    "src/psaux/psaux.c",
    "src/pshinter/pshinter.c",
    "src/psnames/psnames.c",
    "src/raster/raster.c",
    "src/sdf/sdf.c",
    "src/sfnt/sfnt.c",
    "src/smooth/smooth.c",
    "src/svg/svg.c",
    "src/truetype/truetype.c",
    "src/type1/type1.c",
    "src/type42/type42.c",
    "src/winfonts/winfnt.c",
};

pub fn buildFreetypeFor(exe: *std.build.LibExeObjStep) !*std.build.LibExeObjStep {
    var builder = exe.builder;
    const allocator = builder.allocator;
    _ = allocator;

    const ft2_flags: []const []const u8 = &.{
        "-DFT2_BUILD_LIBRARY",
    };
    var ft2_c_files = try std.ArrayList([]const u8).initCapacity(allocator, ft2_srcs.len);
    inline for (ft2_srcs) |f| {
        ft2_c_files.appendAssumeCapacity(ft2_root ++ f);
    }
    if ((exe.target.os_tag orelse builder.host.target.os.tag) == .windows) {
        try ft2_c_files.append(ft2_root ++ "builds/windows/ftdebug.c");
    } else {
        try ft2_c_files.append(ft2_root ++ "src/base/ftdebug.c");
    }

    const ft2_lib = builder.addStaticLibrary("freetype2", null);
    ft2_lib.addCSourceFiles(ft2_c_files.items, ft2_flags);
    ft2_lib.addIncludeDir(thisDir() ++ "/src/ft/");
    ft2_lib.addIncludeDir(ft2_root ++ "include/");

    exe.addIncludeDir(thisDir() ++ "/src/ft/");
    exe.addIncludeDir(ft2_root ++ "include/");
    exe.linkLibrary(ft2_lib);

    return ft2_lib;
}

pub fn addFreetype(exe: *std.build.LibExeObjStep) !void {
    _ = try buildFreetypeFor(exe);
    exe.addPackage(pkg);
}
