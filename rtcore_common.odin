package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "embree4.lib"
} else {
    foreign import lib "system:embree4"
}

/* Invalid geometry ID */
INVALID_GEOMETRY_ID :: u32(0xFFFFFFFF)

/* Maximum number of time steps */
MAX_TIME_STEP_COUNT :: 129

/* Formats of buffers and other data structures */
Format :: enum c.int {
    UNDEFINED = 0,

    /* 8-bit unsigned integer */
    UCHAR = 0x1001,
    UCHAR2,
    UCHAR3,
    UCHAR4,

    /* 8-bit signed integer */
    CHAR = 0x2001,
    CHAR2,
    CHAR3,
    CHAR4,

    /* 16-bit unsigned integer */
    USHORT = 0x3001,
    USHORT2,
    USHORT3,
    USHORT4,

    /* 16-bit signed integer */
    SHORT = 0x4001,
    SHORT2,
    SHORT3,
    SHORT4,

    /* 32-bit unsigned integer */
    UINT = 0x5001,
    UINT2,
    UINT3,
    UINT4,

    /* 32-bit signed integer */
    INT = 0x6001,
    INT2,
    INT3,
    INT4,

    /* 64-bit unsigned integer */
    ULLONG = 0x7001,
    ULLONG2,
    ULLONG3,
    ULLONG4,

    /* 64-bit signed integer */
    LLONG = 0x8001,
    LLONG2,
    LLONG3,
    LLONG4,

    /* 32-bit float */
    FLOAT = 0x9001,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    FLOAT5,
    FLOAT6,
    FLOAT7,
    FLOAT8,
    FLOAT9,
    FLOAT10,
    FLOAT11,
    FLOAT12,
    FLOAT13,
    FLOAT14,
    FLOAT15,
    FLOAT16,

    /* 32-bit float matrix (row-major order) */
    FLOAT2X2_ROW_MAJOR = 0x9122,
    FLOAT2X3_ROW_MAJOR = 0x9123,
    FLOAT2X4_ROW_MAJOR = 0x9124,
    FLOAT3X2_ROW_MAJOR = 0x9132,
    FLOAT3X3_ROW_MAJOR = 0x9133,
    FLOAT3X4_ROW_MAJOR = 0x9134,
    FLOAT4X2_ROW_MAJOR = 0x9142,
    FLOAT4X3_ROW_MAJOR = 0x9143,
    FLOAT4X4_ROW_MAJOR = 0x9144,

    /* 32-bit float matrix (column-major order) */
    FLOAT2X2_COLUMN_MAJOR = 0x9222,
    FLOAT2X3_COLUMN_MAJOR = 0x9223,
    FLOAT2X4_COLUMN_MAJOR = 0x9224,
    FLOAT3X2_COLUMN_MAJOR = 0x9232,
    FLOAT3X3_COLUMN_MAJOR = 0x9233,
    FLOAT3X4_COLUMN_MAJOR = 0x9234,
    FLOAT4X2_COLUMN_MAJOR = 0x9242,
    FLOAT4X3_COLUMN_MAJOR = 0x9243,
    FLOAT4X4_COLUMN_MAJOR = 0x9244,

    /* special 12-byte format for grids */
    GRID = 0xA001,
}

/* Build quality levels */
BuildQuality :: enum c.int {
    LOW    = 0,
    MEDIUM = 1,
    HIGH   = 2,
    REFIT  = 3,
}

/* Axis-aligned bounding box representation */
Bounds :: struct #align 16 {
    lower_x, lower_y, lower_z, align0: f32,
    upper_x, upper_y, upper_z, align1: f32,
}

/* Linear axis-aligned bounding box representation */
LinearBounds :: struct #align 16 {
    bounds0: Bounds,
    bounds1: Bounds,
}

/* Feature flags for SYCL specialization constants */
FeatureFlag :: enum c.int {
    MOTION_BLUR = 0,

    TRIANGLE = 1,
    QUAD = 2,
    GRID = 3,

    SUBDIVISION = 4,

    CONE_LINEAR_CURVE = 5,
    ROUND_LINEAR_CURVE  = 6,
    FLAT_LINEAR_CURVE = 7,

    ROUND_BEZIER_CURVE = 8,
    FLAT_BEZIER_CURVE = 9,
    NORMAL_ORIENTED_BEZIER_CURVE = 10,

    ROUND_BSPLINE_CURVE = 11,
    FLAT_BSPLINE_CURVE = 12,
    NORMAL_ORIENTED_BSPLINE_CURVE = 13,

    ROUND_HERMITE_CURVE = 14,
    FLAT_HERMITE_CURVE = 15,
    NORMAL_ORIENTED_HERMITE_CURVE = 16,

    ROUND_CATMULL_ROM_CURVE = 17,
    FLAT_CATMULL_ROM_CURVE = 18,
    NORMAL_ORIENTED_CATMULL_ROM_CURVE = 19,

    SPHERE_POINT = 20,
    DISC_POINT = 21,
    ORIENTED_DISC_POINT = 22,

    INSTANCE = 23,

    FILTER_FUNCTION_IN_ARGUMENTS = 24,
    FILTER_FUNCTION_IN_GEOMETRY = 25,

    USER_GEOMETRY_CALLBACK_IN_ARGUMENTS = 26,
    USER_GEOMETRY_CALLBACK_IN_GEOMETRY = 27,

    _32_BIT_RAY_MASK = 28,
}

FeatureFlags :: bit_set[FeatureFlag]

FEATURE_FLAGS_POINT :: FeatureFlags{
    .SPHERE_POINT,
    .DISC_POINT,
    .ORIENTED_DISC_POINT,
}

FEATURE_FLAGS_ROUND_CURVES :: FeatureFlags{
    .ROUND_LINEAR_CURVE,
    .ROUND_BEZIER_CURVE,
    .ROUND_BSPLINE_CURVE,
    .ROUND_HERMITE_CURVE,
    .ROUND_CATMULL_ROM_CURVE,
}

FEATURE_FLAGS_FLAT_CURVES :: FeatureFlags{
    .FLAT_LINEAR_CURVE,
    .FLAT_BEZIER_CURVE,
    .FLAT_BSPLINE_CURVE,
    .FLAT_HERMITE_CURVE,
    .FLAT_CATMULL_ROM_CURVE,
}

FEATURE_FLAGS_NORMAL_ORIENTED_CURVES :: FeatureFlags{
    .NORMAL_ORIENTED_BEZIER_CURVE,
    .NORMAL_ORIENTED_BSPLINE_CURVE,
    .NORMAL_ORIENTED_HERMITE_CURVE,
    .NORMAL_ORIENTED_CATMULL_ROM_CURVE,
}

FEATURE_FLAGS_LINEAR_CURVES :: FeatureFlags{
    .CONE_LINEAR_CURVE,
    .ROUND_LINEAR_CURVE,
    .FLAT_LINEAR_CURVE,
}

FEATURE_FLAGS_BEZIER_CURVES :: FeatureFlags{
    .ROUND_BEZIER_CURVE,
    .FLAT_BEZIER_CURVE,
    .NORMAL_ORIENTED_BEZIER_CURVE,
}

FEATURE_FLAGS_BSPLINE_CURVES :: FeatureFlags{
    .ROUND_BSPLINE_CURVE,
    .FLAT_BSPLINE_CURVE,
    .NORMAL_ORIENTED_BSPLINE_CURVE,
}

FEATURE_FLAGS_HERMITE_CURVES :: FeatureFlags{
    .ROUND_HERMITE_CURVE,
    .FLAT_HERMITE_CURVE,
    .NORMAL_ORIENTED_HERMITE_CURVE,
}

FEATURE_FLAGS_CURVES :: FeatureFlags{
    .CONE_LINEAR_CURVE,
    .ROUND_LINEAR_CURVE,
    .FLAT_LINEAR_CURVE,
    .ROUND_BEZIER_CURVE,
    .FLAT_BEZIER_CURVE,
    .NORMAL_ORIENTED_BEZIER_CURVE,
    .ROUND_BSPLINE_CURVE,
    .FLAT_BSPLINE_CURVE,
    .NORMAL_ORIENTED_BSPLINE_CURVE,
    .ROUND_HERMITE_CURVE,
    .FLAT_HERMITE_CURVE,
    .NORMAL_ORIENTED_HERMITE_CURVE,
    .ROUND_CATMULL_ROM_CURVE,
    .FLAT_CATMULL_ROM_CURVE,
    .NORMAL_ORIENTED_CATMULL_ROM_CURVE,
}

FEATURE_FLAGS_FILTER_FUNCTION :: FeatureFlags{
    .FILTER_FUNCTION_IN_ARGUMENTS,
    .FILTER_FUNCTION_IN_GEOMETRY,
}

FEATURE_FLAGS_USER_GEOMETRY :: FeatureFlags{
    .USER_GEOMETRY_CALLBACK_IN_ARGUMENTS,
    .USER_GEOMETRY_CALLBACK_IN_GEOMETRY,
}

FEATURE_FLAGS_ALL :: FeatureFlags {
    .MOTION_BLUR,
    .TRIANGLE,
    .QUAD,
    .GRID,
    .SUBDIVISION,
    .CONE_LINEAR_CURVE,
    .ROUND_LINEAR_CURVE,
    .FLAT_LINEAR_CURVE,
    .ROUND_BEZIER_CURVE,
    .FLAT_BEZIER_CURVE,
    .NORMAL_ORIENTED_BEZIER_CURVE,
    .ROUND_BSPLINE_CURVE,
    .FLAT_BSPLINE_CURVE,
    .NORMAL_ORIENTED_BSPLINE_CURVE,
    .ROUND_HERMITE_CURVE,
    .FLAT_HERMITE_CURVE,
    .NORMAL_ORIENTED_HERMITE_CURVE,
    .ROUND_CATMULL_ROM_CURVE,
    .FLAT_CATMULL_ROM_CURVE,
    .NORMAL_ORIENTED_CATMULL_ROM_CURVE,
    .SPHERE_POINT,
    .DISC_POINT,
    .ORIENTED_DISC_POINT,
    .INSTANCE,
    .FILTER_FUNCTION_IN_ARGUMENTS,
    .FILTER_FUNCTION_IN_GEOMETRY,
    .USER_GEOMETRY_CALLBACK_IN_ARGUMENTS,
    .USER_GEOMETRY_CALLBACK_IN_GEOMETRY,
    ._32_BIT_RAY_MASK,
}

/* Ray query flags */
RayQueryFlag :: enum c.int {
    /* matching intel_ray_flags_t layout */
    INVOKE_ARGUMENT_FILTER = 1, // enable argument filter for each geometry

    /* embree specific flags */
    // NOTE: this is implicit by not setting COHERENT
    // INCOHERENT = (0 << 16), // optimize for incoherent rays
    COHERENT   = 16, // optimize for coherent rays
}

RayQueryFlags :: bit_set[RayQueryFlag]

/* Arguments for RTCFilterFunctionN */
FilterFunctionNArguments :: struct {
    valid: ^c.int,
    geometryUserPtr: rawptr,
    ctx: ^RayQueryContext,
    ray: ^RayN,
    hit: ^HitN,
    N: u32,
}

/* Filter callback function */
FilterFunctionN :: proc "c" (args: ^FilterFunctionNArguments)

/* Intersection callback function */
IntersectFunctionN :: proc "c" (args: ^IntersectFunctionNArguments)

/* Occlusion callback function */
OccludedFunctionN :: proc "c" (args: ^OccludedFunctionNArguments)

/* Ray query context passed to intersect/occluded calls */
when MAX_INSTANCE_LEVEL_COUNT > 1 {
    RayQueryContext :: struct {
        instStackSize: u32,                        // Number of instances currently on the stack.
        instID: [MAX_INSTANCE_LEVEL_COUNT]u32, // The current stack of instance ids.
    }
} else {
    RayQueryContext :: struct {
        instID: [MAX_INSTANCE_LEVEL_COUNT]u32, // The current stack of instance ids.
    }
}

/* Initializes an ray query context. */
InitRayQueryContext :: proc(ctx: ^RayQueryContext) {
    when MAX_INSTANCE_LEVEL_COUNT > 1 {
        ctx.instStackSize = 0
    }

    for l in 0 ..< MAX_INSTANCE_LEVEL_COUNT {
        ctx.instID[l] = INVALID_GEOMETRY_ID
    }
}

/* Point query structure for closest point query */
Point :: struct #align 16 {
    x: f32,                // x coordinate of the query point
    y: f32,                // y coordinate of the query point
    z: f32,                // z coordinate of the query point
    time: f32,             // time of the point query
    radius: f32,           // radius of the point query
}

/* Structure of a packet of 4 query points */
Point4 :: struct #align 16 {
    x: [4]f32,                // x coordinate of the query point
    y: [4]f32,                // y coordinate of the query point
    z: [4]f32,                // z coordinate of the query point
    time: [4]f32,             // time of the point query
    radius: [4]f32,           // radius of the point query
}

/* Structure of a packet of 8 query points */
Point8 :: struct #align 32 {
    x: [8]f32,                // x coordinate of the query point
    y: [8]f32,                // y coordinate of the query point
    z: [8]f32,                // z coordinate of the query point
    time: [8]f32,             // time of the point query
    radius: [8]f32,           // radius ofr the point query
}

/* Structure of a packet of 16 query points */
Point16 :: struct #align 64 {
    x: [16]f32,                // x coordinate of the query point
    y: [16]f32,                // y coordinate of the query point
    z: [16]f32,                // z coordinate of the query point
    time: [16]f32,             // time of the point quey
    radius: [16]f32,           // radius of the point query
}

PointQueryContext :: struct #align 16 {
    // accumulated 4x4 column major matrices from world space to instance space.
    // undefined if size == 0.
    world2inst: [MAX_INSTANCE_LEVEL_COUNT][16]f32,

    // accumulated 4x4 column major matrices from instance space to world space.
    // undefined if size == 0.
    inst2world: [MAX_INSTANCE_LEVEL_COUNT][16]f32,

    // instance ids.
    instID: [MAX_INSTANCE_LEVEL_COUNT]u32,

    // number of instances currently on the stack.
    instStackSize: u32,
}

/* Initializes an ray query context. */
InitPointQueryContext :: proc(ctx: ^PointQueryContext) {
    ctx.instStackSize = 0
    ctx.instID[0] = INVALID_GEOMETRY_ID
}

PointQueryFunctionArguments :: struct #align 16 {
    // The (world space) query object that was passed as an argument of rtcPointQuery. The
    // radius of the query can be decreased inside the callback to shrink the
    // search domain. Increasing the radius or modifying the time or position of
    // the query results in undefined behaviour.
    query: ^Point,

    // Used for user input/output data. Will not be read or modified internally.
    userPtr: rawptr,

    // primitive and geometry ID of primitive
    primID: u32,
    geomID: u32,

    // the context with transformation and instance ID stack
    ctx: ^PointQueryContext,

    // If the current instance transform M (= ctx.world2inst[ctx.instStackSize])
    // is a similarity matrix, i.e there is a constant factor similarityScale such that
    //    for all x,y: dist(Mx, My) = similarityScale * dist(x, y),
    // The similarity scale is 0, if the current instance transform is not a
    // similarity transform and vice versa. The similarity scale allows to compute
    // distance information in instance space and scale the distances into world
    // space by dividing with the similarity scale, for example, to update the
    // query radius. If the current instance transform is not a similarity
    // transform (similarityScale = 0), the distance computation has to be
    // performed in world space to ensure correctness. if there is no instance
    // transform (ctx.instStackSize == 0), the similarity scale is 1.
    similarityScale: f32,
}

PointQueryFunction :: proc "c" (args: ^PointQueryFunctionArguments) -> bool
