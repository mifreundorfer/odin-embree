package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "embree4.lib"
} else {
    foreign import lib "system:embree4"
}

/* Opaque device type */
Device :: distinct rawptr

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Creates a new Embree device. */
    NewDevice :: proc(config: cstring) -> Device ---

    /* Retains the Embree device (increments the reference count). */
    RetainDevice ::proc(device: Device) ---

    /* Releases an Embree device (decrements the reference count). */
    ReleaseDevice :: proc(device: Device) ---
}

/* Device properties */
DeviceProperty :: enum c.int {
    VERSION       = 0,
    VERSION_MAJOR = 1,
    VERSION_MINOR = 2,
    VERSION_PATCH = 3,

    NATIVE_RAY4_SUPPORTED  = 32,
    NATIVE_RAY8_SUPPORTED  = 33,
    NATIVE_RAY16_SUPPORTED = 34,

    BACKFACE_CULLING_SPHERES_ENABLED = 62,
    BACKFACE_CULLING_CURVES_ENABLED = 63,
    RAY_MASK_SUPPORTED          = 64,
    BACKFACE_CULLING_ENABLED    = 65,
    FILTER_FUNCTION_SUPPORTED   = 66,
    IGNORE_INVALID_RAYS_ENABLED = 67,
    COMPACT_POLYS_ENABLED       = 68,

    TRIANGLE_GEOMETRY_SUPPORTED    = 96,
    QUAD_GEOMETRY_SUPPORTED        = 97,
    SUBDIVISION_GEOMETRY_SUPPORTED = 98,
    CURVE_GEOMETRY_SUPPORTED       = 99,
    USER_GEOMETRY_SUPPORTED        = 100,
    POINT_GEOMETRY_SUPPORTED       = 101,

    TASKING_SYSTEM        = 128,
    JOIN_COMMIT_SUPPORTED = 129,
    PARALLEL_COMMIT_SUPPORTED = 130,
}

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Gets a device property. */
    GetDeviceProperty :: proc(device: Device, prop: DeviceProperty) -> int ---

    /* Sets a device property. */
    SetDeviceProperty :: proc(device: Device, prop: DeviceProperty, value: int) ---
}
  
/* Error codes */
Error :: enum c.int {
    NONE              = 0,
    UNKNOWN           = 1,
    INVALID_ARGUMENT  = 2,
    INVALID_OPERATION = 3,
    OUT_OF_MEMORY     = 4,
    UNSUPPORTED_CPU   = 5,
    CANCELLED         = 6,
}

/* Error callback function */
ErrorFunction :: proc "c" (userPtr: rawptr, code: Error, str: cstring)

/* Memory monitor callback function */
MemoryMonitorFunction :: proc "c" (userPtr: rawptr, bytes: int, post: bool) -> bool

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Returns the error code. */
    GetDeviceError :: proc(device: Device) -> Error ---

    /* Sets the error callback function. */
    SetDeviceErrorFunction :: proc(device: Device, error: ErrorFunction, userPtr: rawptr) ---

    /* Sets the memory monitor callback function. */
    SetDeviceMemoryMonitorFunction :: proc(device: Device, memoryMonitor: MemoryMonitorFunction, userPtr: rawptr) ---
}
