# ZGLM
This library aims to match the functionality of [cglm](https://github.com/recp/cglm/) one to one, using Zig's native Vector types. 
This makes it significantly easier to include in Zig projects, especially because it encodes cglm's allignment requirements into Zig types.
### Using ZGLM
- zglm src files follow cglm header files.
- zglm adheres to the [cglm docs](http://cglm.readthedocs.io) as much as possible, while adding auto-doc comments to code.
- zglm does **NOT** impliment cglm functionality marked as depricated.
- Declarations are less verbose, namespaced by Zig's import system.
  For example, ```glm_mat4_mulv``` in cglm becomes ```glm.mat4.mulv``` in zglm (assuming ```const glm = @import("zglm")```).
  The exeption to this rule is when cglm functions translate directly to their namespace, such at ```glm_vec4```.
  In this case, the zglm function repeats the last identifier, so ```glm_vec4``` would translate to ```glm.vec4.vec4```.
- Some cglm function are less restrictive with input types than Zig ```@Vectors``` allow.
  These have ```anytype``` in place of their c types, and give compile errors when fed invalid types.
- zglm types are aliases similar to in cglm, capitalized by Zig convention, and are found in their respective src files.
  e.g. ```mat4``` in cglm is ```glm.mat4.Mat4``` in zglm.
- cglm MACRO constants follow a similar pattern, becoming Zig global constants.
  For example, ```GLM_MAT4_IDENTITY_INIT``` becomes ```glm.mat4.IDENTITY_INIT```.
- cglm function-like MACROS, where possible, are implimented as Zig functions.
- Because Zig's function parameters are immutable, zglm functions accept values rather than input-only pointers.
  For example, ```glm_mat4_mulv(&mat4, &vec4, &out)``` in cglm becomes ```glm.mat4.mulv(mat4, vec4, &out)``` in zglm.
- Functions that can be accomlpished with simple ```@Vector``` operators are marked with "REDUNDANT" in auto-doc comments
