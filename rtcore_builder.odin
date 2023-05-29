package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "embree4.lib"
} else {
    foreign import lib "system:embree4"
}

/* Opaque BVH type */
BVH :: distinct rawptr

/* Input build primitives for the builder */
BuildPrimitive :: struct #align 32 {
    lower_x, lower_y, lower_z: f32,
    geomID: u32,
    upper_x, upper_y, upper_z: f32,
    primID: u32,
}

/* Opaque thread local allocator type */
ThreadLocalAllocator :: distinct rawptr

/* Callback to create a node */
CreateNodeFunction :: proc "c" (allocator: ThreadLocalAllocator, childCount: u32, userPtr: rawptr) -> rawptr

/* Callback to set the pointer to all children */
SetNodeChildrenFunction :: proc "c" (nodePtr: rawptr, children: [^]rawptr , childCount: u32, userPtr: rawptr)

/* Callback to set the bounds of all children */
SetNodeBoundsFunction :: proc "c" (nodePtr: rawptr, bounds: [^]^Bounds, childCount: u32, userPtr: rawptr)

/* Callback to create a leaf node */
CreateLeafFunction :: proc "c" (allocator: ThreadLocalAllocator, primitives: [^]BuildPrimitive, primitiveCount: int, userPtr: rawptr) -> rawptr

/* Callback to split a build primitive */
SplitPrimitiveFunction :: proc "c" (primitive: ^BuildPrimitive, dimension: u32, position: f32, leftBounds: ^Bounds, rightBounds: ^Bounds, userPtr: rawptr)

/* Build flags */
BuildFlag :: enum c.int {
    DYNAMIC = 0,
}

BuildFlags :: bit_set[BuildFlag]

MAX_PRIMITIVES_PER_LEAF :: 32

/* Input for builders */
BuildArguments :: struct {
    byteSize: int,
  
    buildQuality: BuildQuality,
    buildFlags: BuildFlags,
    maxBranchingFactor: u32,
    maxDepth: u32,
    sahBlockSize: u32,
    minLeafSize: u32,
    maxLeafSize: u32,
    traversalCost: f32,
    intersectionCost: f32,
  
    bvh: BVH,
    primitives: [^]BuildPrimitive,
    primitiveCount: int,
    primitiveArrayCapacity: int,
  
    createNode: CreateNodeFunction,
    setNodeChildren: SetNodeChildrenFunction,
    setNodeBounds: SetNodeBoundsFunction,
    createLeaf: CreateLeafFunction,
    splitPrimitive: SplitPrimitiveFunction,
    buildProgress: ProgressMonitorFunction,
    userPtr: rawptr,
}

/* Returns the default build settings.  */
DefaultBuildArguments :: proc () -> BuildArguments {
    args: BuildArguments
    args.byteSize = size_of(args)
    args.buildQuality = .MEDIUM
    args.buildFlags = {}
    args.maxBranchingFactor = 2
    args.maxDepth = 32
    args.sahBlockSize = 1
    args.minLeafSize = 1
    args.maxLeafSize = MAX_PRIMITIVES_PER_LEAF
    args.traversalCost = 1.0
    args.intersectionCost = 1.0
    args.bvh = nil
    args.primitives = nil
    args.primitiveCount = 0
    args.primitiveArrayCapacity = 0
    args.createNode = nil
    args.setNodeChildren = nil
    args.setNodeBounds = nil
    args.createLeaf = nil
    args.splitPrimitive = nil
    args.buildProgress = nil
    args.userPtr = nil
    return args
}

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Creates a new BVH. */
    NewBVH :: proc(device: Device) -> BVH ---

    /* Builds a BVH. */
    BuildBVH :: proc(args: ^BuildArguments) -> rawptr ---

    /* Allocates memory using the thread local allocator. */
    ThreadLocalAlloc :: proc(allocator: ThreadLocalAllocator, bytes: int, align: int) -> rawptr ---

    /* Retains the BVH (increments reference count). */
    RetainBVH :: proc(bvh: BVH) ---

    /* Releases the BVH (decrements reference count). */
    ReleaseBVH :: proc(bvh: BVH) ---
}

