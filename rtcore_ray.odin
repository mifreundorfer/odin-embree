package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

/* Ray structure for a single ray */
Ray :: struct #align 16 {
    org_x: f32, // x coordinate of ray origin
    org_y: f32, // y coordinate of ray origin
    org_z: f32, // z coordinate of ray origin
    tnear: f32, // start of ray segment

    dir_x: f32, // x coordinate of ray direction
    dir_y: f32, // y coordinate of ray direction
    dir_z: f32, // z coordinate of ray direction
    time: f32,  // time of this ray for motion blur

    tfar: f32,  // end of ray segment (set to hit distance)
    mask: u32,  // ray mask
    id: u32,    // ray ID
    flags: u32, // ray flags
}

/* Hit structure for a single ray */
Hit :: struct #align 16 {
    Ng_x: f32,          // x coordinate of geometry normal
    Ng_y: f32,          // y coordinate of geometry normal
    Ng_z: f32,          // z coordinate of geometry normal

    u: f32,             // barycentric u coordinate of hit
    v: f32,             // barycentric v coordinate of hit

    primID: u32,        // primitive ID
    geomID: u32,        // geometry ID
    instID: [MAX_INSTANCE_LEVEL_COUNT]u32, // instance ID
}

/* Combined ray/hit structure for a single ray */
RayHit :: struct {
    ray: Ray,
    hit: Hit,
}

/* Ray structure for a packet of 4 rays */
Ray4 :: struct #align 16 {
    org_x: [4]f32,
    org_y: [4]f32,
    org_z: [4]f32,
    tnear: [4]f32,

    dir_x: [4]f32,
    dir_y: [4]f32,
    dir_z: [4]f32,
    time: [4]f32,

    tfar: [4]f32,
    mask: [4]u32,
    id: [4]u32,
    flags: [4]u32,
}

/* Hit structure for a packet of 4 rays */
Hit4 :: struct #align 16  {
    Ng_x: [4]f32,
    Ng_y: [4]f32,
    Ng_z: [4]f32,

    u: [4]f32,
    v: [4]f32,

    primID: [4]u32,
    geomID: [4]u32,
    instID: [MAX_INSTANCE_LEVEL_COUNT][4]u32,
}

/* Combined ray/hit structure for a packet of 4 rays */
RayHit4 :: struct {
    ray: Ray4,
    hit: Hit4,
}

/* Ray structure for a packet of 8 rays */
Ray8 :: struct #align 32 {
    org_x: [8]f32,
    org_y: [8]f32,
    org_z: [8]f32,
    tnear: [8]f32,

    dir_x: [8]f32,
    dir_y: [8]f32,
    dir_z: [8]f32,
    time: [8]f32,

    tfar: [8]f32,
    mask: [8]u32,
    id: [8]u32,
    flags: [8]u32,
}

/* Hit structure for a packet of 8 rays */
Hit8 :: struct #align 32 {
    Ng_x: [8]f32,
    Ng_y: [8]f32,
    Ng_z: [8]f32,

    u: [8]f32,
    v: [8]f32,

    primID: [8]u32,
    geomID: [8]u32,
    instID: [MAX_INSTANCE_LEVEL_COUNT][8]u32,
}

/* Combined ray/hit structure for a packet of 8 rays */
RayHit8 :: struct {
    ray: Ray8,
    hit: Hit8,
}

/* Ray structure for a packet of 16 rays */
Ray16 :: struct #align 64 {
    org_x: [16]f32,
    org_y: [16]f32,
    org_z: [16]f32,
    tnear: [16]f32,

    dir_x: [16]f32,
    dir_y: [16]f32,
    dir_z: [16]f32,
    time: [16]f32,

    tfar: [16]f32,
    mask: [16]u32,
    id: [16]u32,
    flags: [16]u32,
}

/* Hit structure for a packet of 16 rays */
Hit16 :: struct #align 64 {
    Ng_x: [16]f32,
    Ng_y: [16]f32,
    Ng_z: [16]f32,

    u: [16]f32,
    v: [16]f32,

    primID: [16]u32,
    geomID: [16]u32,
    instID: [MAX_INSTANCE_LEVEL_COUNT][16]u32,
}

/* Combined ray/hit structure for a packet of 16 rays */
RayHit16 :: struct {
    ray: Ray16,
    hit: Hit16,
}

RayN :: struct {}
HitN :: struct {}
RayHitN :: struct {}
