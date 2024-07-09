# ZGLM
This library aims to match the functionality of [cglm](https://github.com/recp/cglm/) one to one, using zig's native Vector types. 
This makes it significantly easier to include in zig projects, especially because it encodes cglm's allignment requirements into zig types.
### Using ZGLM
- zglm src files follow cglm header files.
- zglm adheres to the [cglm docs](http://cglm.readthedocs.io) as much as possible, while adding auto-doc comments to code.
- Declarations are less verbose, namespaced by zig's import system.
  For example, ```glm_mat4_mulv``` in cglm becomes ```glm.mat4.mulv``` in zglm (assuming ```const glm = @import("zglm")```).
  The exeption to this rule is when cglm functions translate directly to their namespace, such at ```glm_vec4```.
  In this case, the zglm function repeats the last identifier, so in this example ```glm_vec4``` would translate to ```glm.vec4.vec4```.
- Because zig's function parameters are immutable, zglm functions accept values rather than input-only pointers.
  For example, ```glm_mat4_mulv(&mat4, &vec4, &out)``` in cglm becomes ```glm.mat4.mulv(mat4, vec4, &out)``` in zglm.
