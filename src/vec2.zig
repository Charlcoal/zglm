const std = @import("std");
const stdfl = std.math.float;
const math = std.math;
const util = @import("util.zig");
pub const Vec2 = @Vector(2, f32);

/// initializes dest from the first elements of v (Vec3 or Vec4)
pub fn vec2(v: anytype, dest: *Vec2) void {
    switch (@TypeOf(v)) {
        @Vector(3, f32) => {
            dest[0] = v[0];
            dest[1] = v[1];
        },
        @Vector(4, f32) => {
            dest[0] = v[0];
            dest[1] = v[1];
        },
        else => @compileError("only accepts Vec3 and Vec4"),
    }
}

/// REDUNDANT copy all members of a to dest
pub fn copy(a: Vec2, dest: *Vec2) void {
    dest.* = a;
}

/// REDUNDANT zeros out v
pub fn zero(v: *Vec2) void {
    v.* = @splat(0.0);
}

/// REDUNDANT sets v to all ones
pub fn one(v: *Vec2) void {
    v.* = @splat(1.0);
}

/// dot product of a and b
pub fn dot(a: Vec2, b: Vec2) f32 {
    return @reduce(.Add, a * b);
}

/// cross product of a and b
pub fn cross(a: Vec2, b: Vec2) f32 {
    return a[0] * b[1] - a[1] * b[0];
}

/// squared norm (magnitude) of v
pub fn norm2(v: Vec2) f32 {
    return dot(v, v);
}

/// norm (magnitude) of v
pub fn norm(v: Vec2) f32 {
    return @sqrt(norm2(v));
}

/// REDUNDANT adds a and b component-wise, then store in dest
pub fn add(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* = a + b;
}

/// add s to each component of v, then store in dest
pub fn adds(v: Vec2, s: f32, dest: *Vec2) void {
    dest.* = v + @as(Vec2, @splat(s));
}

/// REDUNDANT subtract b from a and store in dest
pub fn sub(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* = a - b;
}

/// subtract s from v and store in dest
pub fn subs(v: Vec2, s: f32, dest: *Vec2) void {
    dest.* = v + @as(Vec2, @splat(s));
}

/// REDUNDANT multiply a and b component-wise and store in dest
pub fn mul(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* = a * b;
}

/// scale v by s and store in dest
pub fn scale(v: Vec2, s: f32, dest: *Vec2) void {
    dest.* = v * @as(Vec2, @splat(s));
}

/// scale unit(v) by s and store in dest
pub fn scaleAs(v: Vec2, s: f32, dest: *Vec2) void {
    const n: f32 = norm(v);

    if (n < stdfl.floatEps(f32)) {
        coldZero(dest);
        return;
    }
    scale(v, s / n, dest);
}

// remove when @cold() is added
fn coldZero(dest: *Vec2) void {
    @setCold(true);
    zero(dest);
}

/// REDUNDANT component-wise divide a by b and store in dest
pub fn div(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* = a / b;
}

/// divide v by s and store in dest
pub fn divs(v: Vec2, s: f32, dest: *Vec2) void {
    dest.* = v / @as(Vec2, @splat(s));
}

/// REDUNDANT add a to b and add the result to dest
pub fn addadd(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* += a + b;
}

/// REDUNDANT subtract b from a and add the result to dest
pub fn subadd(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* += a - b;
}

/// REDUNDANT multiply a by b and add the result to dest
pub fn muladd(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* += a * b;
}

/// multiply v by s and add the result to dest
pub fn muladds(v: Vec2, s: f32, dest: *Vec2) void {
    dest.* += v * @as(Vec2, @splat(s));
}

/// add the component-wise max of a and b to dest
pub fn maxadd(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* += @select(Vec2, a > b, a, b);
}

/// add the component-wise min of a and b to dest
pub fn minadd(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* += @select(Vec2, a < b, a, b);
}

/// REDUNDANT subtract b from a and subtract the result from dest
pub fn subsub(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* -= a - b;
}

/// REDUNDANT add a and b and subtract the result from dest
pub fn addsub(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* -= a + b;
}

/// REDUNDANT multiply a and b and subtract the result from dest
pub fn mulsub(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* -= a * b;
}

/// scale v by s and subtract the result from dest
pub fn mulsubs(v: Vec2, s: f32, dest: *Vec2) void {
    dest.* -= v * @as(Vec2, @splat(s));
}

/// subtract the component-wise max of a and b from dest
pub fn maxsub(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* -= @select(Vec2, a > b, a, b);
}

/// subtract the component-wise min of a and b from dest
pub fn minsub(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* -= @select(Vec2, a < b, a, b);
}

/// REDUNDANT take component-wise negation of v and store in dest
pub fn negateTo(v: Vec2, dest: *Vec2) void {
    dest.* = -v;
}

/// REDUNDANT component-wise negate v
pub fn negate(v: *Vec2) void {
    v.* = -v.*;
}

/// normalize v
pub fn normalize(v: *Vec2) void {
    const n: f32 = norm(v.*);

    if (n < stdfl.floatEps(f32)) {
        coldZero(v);
        return;
    }
    scale(v.*, 1.0 / n, v);
}

/// store normalization of v in dest
pub fn normalizeTo(v: Vec2, dest: *Vec2) void {
    const n: f32 = norm(v);

    if (n < stdfl.floatEps(f32)) {
        coldZero(dest);
        return;
    }
    scale(v, 1.0 / n, dest);
}

// needs testing for alternative implimentations (speed)
/// take rotated v about origin by angle and store in dest
pub fn rotate(v: Vec2, angle: f32, dest: *Vec2) void {
    const c: f32 = @cos(angle);
    const s: f32 = @sin(angle);

    dest.* = Vec2{ c, s } * @as(Vec2, @splat(v[0])) + Vec2{ -s, c } * @as(Vec2, @splat(v[1]));
}

/// find the center of a and b, then store the result in dest
pub fn center(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest = (a + b) * Vec2{ 0.5, 0.5 };
}

/// return the squared distance between a and b
pub fn distance2(a: Vec2, b: Vec2) f32 {
    const s = a - b;
    return @reduce(.Add, s * s);
}

/// return the distance between a and b
pub fn distance(a: Vec2, b: Vec2) f32 {
    return @sqrt(distance2(a, b));
}

/// find the component-wise max of a and b and store in dest
pub fn maxv(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* = @select(Vec2, a > b, a, b);
}

/// find the component-wise min of a and b and store in dest
pub fn minv(a: Vec2, b: Vec2, dest: *Vec2) void {
    dest.* = @select(Vec2, a < b, a, b);
}

/// component-wise clamp v between min and max
pub fn clamp(v: *Vec2, minval: f32, maxval: f32) void {
    const minvec: Vec2 = @splat(minval);
    const maxvec: Vec2 = @splat(maxval);
    const set_min: @Vector(2, bool) = v.* < minvec;
    const set_max: @Vector(2, bool) = v.* > maxvec;
    v.* = @select(Vec2, set_min, minvec, v.*);
    v.* = @select(Vec2, set_max, maxvec, v.*);
}

fn clamp_scalar_zo(t: f32) f32 {
    return if (t < 0) 0 else if (t > 1) 1 else t;
}

/// linear interpolate between from and to, t between 0 and 1, store in dest
pub fn lerp(from: Vec2, to: Vec2, t: f32, dest: *Vec2) void {
    const s: Vec2 = @splat(clamp_scalar_zo(t));
    var v: Vec2 = to - from;
    v = s * v;
    dest.* = v + from;
}

/// create Vec2 in dest from src floats
pub fn make(noalias src: [2]f32, noalias dest: *Vec2) void {
    dest.* = src;
}

/// reflection vector using incident ray (v) and surface normal (n)
pub fn reflect(v: Vec2, n: Vec2, dest: *Vec2) void {
    dest.* = n * @as(Vec2, @splat(2.0 * dot(v, n))) + v;
}

/// compute refraction vector for an incident ray (v), surface normal(n),
/// and index of refraction ratio (eta) using snell's law.
/// return true if refraction occurs, false & sets dest to 0, 0 if total internal reflection occurs
pub fn refract(v: Vec2, n: Vec2, eta: f32, dest: *Vec2) bool {
    const ndi: f32 = dot(v, n);
    const eni: f32 = eta * ndi;
    const k: f32 = 1 + eta * eta - eni * eni;

    if (k < 0) {
        dest.* = @splat(0.0);
        return false;
    }

    dest.* = scale(v, eta) - scale(n, eni + @sqrt(k));
    return true;
}
