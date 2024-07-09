const std = @import("std");

const test_targets = [_]std.Target.Query{
    .{},
    .{
        .cpu_arch = .x86_64,
        .os_tag = .linux,
    },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("zglm", .{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "src/zglm.zig" } },
        .target = target,
        .optimize = optimize,
    });

    //const test_step = b.step("test", "Run all unit tests");

    //for (test_targets) |test_target| {
    //    const unit_tests = b.addTest(.{
    //        .root_source_file = b.path("tests/all.zig"),
    //        .target = b.resolveTargetQuery(test_target),
    //    });

    //    const run_unit_tests = b.addRunArtifact(unit_tests);
    //    run_unit_tests.skip_foreign_checks = true;
    //    test_step.dependOn(&run_unit_tests.step);
    //}
}
