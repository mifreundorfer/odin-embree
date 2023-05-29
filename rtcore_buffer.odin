package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "embree4.lib"
} else {
    foreign import lib "system:embree4"
}

/* Types of buffers */
BufferType :: enum c.int {
    INDEX            = 0,
    VERTEX           = 1,
    VERTEX_ATTRIBUTE = 2,
    NORMAL           = 3,
    TANGENT          = 4,
    NORMAL_DERIVATIVE = 5,

    GRID                 = 8,

    FACE                 = 16,
    LEVEL                = 17,
    EDGE_CREASE_INDEX    = 18,
    EDGE_CREASE_WEIGHT   = 19,
    VERTEX_CREASE_INDEX  = 20,
    VERTEX_CREASE_WEIGHT = 21,
    HOLE                 = 22,

    FLAGS = 32,
}

/* Opaque buffer type */
Buffer :: distinct rawptr

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Creates a new buffer. */
    NewBuffer :: proc(device: Device, byteSize: int) -> Buffer ---

    /* Creates a new shared buffer. */
    NewSharedBuffer :: proc(device: Device, ptr: rawptr, byteSize: int) -> Buffer ---

    /* Returns a pointer to the buffer data. */
    GetBufferData :: proc(buffer: Buffer) -> rawptr ---

    /* Retains the buffer (increments the reference count). */
    RetainBuffer :: proc(buffer: Buffer) ---

    /* Releases the buffer (decrements the reference count). */
    ReleaseBuffer :: proc(buffer: Buffer) ---
}