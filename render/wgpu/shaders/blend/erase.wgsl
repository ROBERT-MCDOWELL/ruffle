struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) uv: vec2<f32>,
};

@group(2) @binding(0) var parent_texture: texture_2d<f32>;
@group(2) @binding(1) var current_texture: texture_2d<f32>;
@group(2) @binding(2) var texture_sampler: sampler;

@vertex
fn main_vertex(in: VertexInput) -> VertexOutput {
    let pos = globals.view_matrix * transforms.world_matrix * vec4<f32>(in.position.x, in.position.y, 1.0, 1.0);
    let uv = vec2<f32>((pos.x + 1.0) / 2.0, -((pos.y - 1.0) / 2.0));
    return VertexOutput(pos, uv);
}

@fragment
fn main_fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // dst is the parent pixel we're blending onto
    var dst: vec4<f32> = textureSample(parent_texture, texture_sampler, in.uv);
    // src is the pixel that we want to apply
    var src: vec4<f32> = textureSample(current_texture, texture_sampler, in.uv);

    if (src.a > 0.0) {
        return vec4<f32>(dst.rgb * (1.0 - src.a), (1.0 - src.a) * dst.a);
    } else {
        if (true) {
            // This needs to be in a branch because... reasons. Bug in naga.
            // https://github.com/gfx-rs/naga/issues/2168
            discard;
        }
        return dst;
    }
}
