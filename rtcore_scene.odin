package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "embree4.lib"
} else {
    foreign import lib "system:embree4"
}

/* Scene flags */
SceneFlag :: enum c.int {
    DYNAMIC                 = 0,
    COMPACT                 = 1,
    ROBUST                  = 2,
    FILTER_FUNCTION_IN_ARGUMENTS = 3,
}

SceneFlags :: bit_set[SceneFlag]

/* Additional arguments for rtcIntersect1/4/8/16 calls */
when MIN_WIDTH > 0 {
    IntersectArguments :: struct {
        flags: RayQueryFlags,          // intersection flags
        feature_mask: FeatureFlags,    // selectively enable features for traversal
        ctx: ^RayQueryContext,         // optional pointer to ray query context
        filter: FilterFunctionN,       // filter function to execute
        intersect: IntersectFunctionN, // user geometry intersection callback to execute
        minWidthDistanceFactor: f32,   // curve radius is set to this factor times distance to ray origin
    }
} else {
    IntersectArguments :: struct {
        flags: RayQueryFlags,          // intersection flags
        feature_mask: FeatureFlags,    // selectively enable features for traversal
        ctx: ^RayQueryContext,         // optional pointer to ray query context
        filter: FilterFunctionN,       // filter function to execute
        intersect: IntersectFunctionN, // user geometry intersection callback to execute
    }
}


/* Initializes intersection arguments. */
InitIntersectArguments :: proc(args: ^IntersectArguments) {
    args.flags = {}
    args.feature_mask = FEATURE_FLAGS_ALL
    args.ctx = nil
    args.filter = nil
    args.intersect = nil

    when MIN_WIDTH > 0 {
        args.minWidthDistanceFactor = 0.0
    }
}

/* Additional arguments for rtcOccluded1/4/8/16 calls */
when MIN_WIDTH > 0 {
    OccludedArguments :: struct {
        flags: RayQueryFlags,        // intersection flags
        feature_mask: FeatureFlags,  // selectively enable features for traversal
        ctx: ^RayQueryContext,       // optional pointer to ray query context
        filter: FilterFunctionN,     // filter function to execute
        occluded: OccludedFunctionN, // user geometry occlusion callback to execute
        minWidthDistanceFactor: f32, // curve radius is set to this factor times distance to ray origin
    }
} else {
    OccludedArguments :: struct {
        flags: RayQueryFlags,        // intersection flags
        feature_mask: FeatureFlags,  // selectively enable features for traversal
        ctx: ^RayQueryContext,       // optional pointer to ray query context
        filter: FilterFunctionN,     // filter function to execute
        occluded: OccludedFunctionN, // user geometry occlusion callback to execute
    }
}

/* Initializes an intersection arguments. */
InitOccludedArguments :: proc(args: ^OccludedArguments) {
    args.flags = {}
    args.feature_mask = FEATURE_FLAGS_ALL
    args.ctx = nil
    args.filter = nil
    args.occluded = nil

    when MIN_WIDTH > 0 {
        args.minWidthDistanceFactor = 0.0
    }
}

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Creates a new scene. */
    NewScene :: proc(device: Device) -> Scene ---

    /* Returns the device the scene got created in. The reference count of
     * the device is incremented by this function. */
    GetSceneDevice :: proc(scene: Scene) -> Device ---

    /* Retains the scene (increments the reference count). */
    RetainScene :: proc(scene: Scene) ---

    /* Releases the scene (decrements the reference count). */
    ReleaseScene :: proc(scene: Scene) ---


    /* Attaches the geometry to a scene. */
    AttachGeometry :: proc(scene: Scene, geometry: Geometry) -> u32 ---

    /* Attaches the geometry to a scene using the specified geometry ID. */
    AttachGeometryByID :: proc(scene: Scene, geometry: Geometry, geomID: u32) ---

    /* Detaches the geometry from the scene. */
    DetachGeometry :: proc(scene: Scene, geomID: u32) ---

    /* Gets a geometry handle from the scene. This function is not thread safe and should get used during rendering. */
    GetGeometry :: proc(scene: Scene, geomID: u32) -> Geometry ---

    /* Gets a geometry handle from the scene. This function is thread safe and should NOT get used during rendering. */
    GetGeometryThreadSafe :: proc(scene: Scene, geomID: u32) -> Geometry ---

    /* Gets the user-defined data pointer of the geometry. This function is not thread safe and should get used during rendering. */
    GetGeometryUserDataFromScene :: proc(scene: Scene, geomID: u32) -> rawptr ---


    /* Commits the scene. */
    CommitScene :: proc(scene: Scene) ---

    /* Commits the scene from multiple threads. */
    JoinCommitScene :: proc(scene: Scene) ---
}


/* Progress monitor callback function */
ProgressMonitorFunction :: proc "c" (ptr: rawptr, n: f64) -> bool

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Sets the progress monitor callback function of the scene. */
    SetSceneProgressMonitorFunction :: proc(scene: Scene, progress: ProgressMonitorFunction, ptr: rawptr) ---

    /* Sets the build quality of the scene. */
    SetSceneBuildQuality :: proc(scene: Scene, quality: BuildQuality) ---

    /* Sets the scene flags. */
    SetSceneFlags :: proc(scene: Scene, flags: SceneFlags) ---

    /* Returns the scene flags. */
    GetSceneFlags :: proc(scene: Scene) -> SceneFlags ---

    /* Returns the axis-aligned bounds of the scene. */
    GetSceneBounds :: proc(scene: Scene, bounds_o: ^Bounds) ---

    /* Returns the linear axis-aligned bounds of the scene. */
    GetSceneLinearBounds :: proc(scene: Scene, bounds_o: ^LinearBounds) ---


    /* Perform a closest point query of the scene. */
    PointQuery :: proc(scene: Scene, query: ^Point, ctx: ^PointQueryContext, queryFunc: PointQueryFunction, userPtr: rawptr) -> bool ---

    /* Perform a closest point query with a packet of 4 points with the scene. */
    PointQuery4 :: proc(valid: [^]c.int, scene: Scene, query: ^Point4, ctx: ^PointQueryContext, queryFunc: PointQueryFunction, userPtr: [^]rawptr) -> bool ---

    /* Perform a closest point query with a packet of 4 points with the scene. */
    PointQuery8 :: proc(valid: [^]c.int, scene: Scene, query: ^Point8, ctx: ^PointQueryContext, queryFunc: PointQueryFunction, userPtr: [^]rawptr) -> bool ---

    /* Perform a closest point query with a packet of 4 points with the scene. */
    PointQuery16 :: proc(valid: [^]c.int, scene: Scene, query: ^Point16, ctx: ^PointQueryContext, queryFunc: PointQueryFunction, userPtr: [^]rawptr) -> bool ---


    /* Intersects a single ray with the scene. */
    Intersect1 :: proc(scene: Scene, rayhit: ^RayHit, args: ^IntersectArguments) ---

    /* Intersects a packet of 4 rays with the scene. */
    Intersect4 :: proc(valid: [^]c.int, scene: Scene, rayhit: ^RayHit4, args: ^IntersectArguments) ---

    /* Intersects a packet of 8 rays with the scene. */
    Intersect8 :: proc(valid: [^]c.int, scene: Scene, rayhit: ^RayHit8, args: ^IntersectArguments) ---

    /* Intersects a packet of 16 rays with the scene. */
    Intersect16 :: proc(valid: [^]c.int, scene: Scene, rayhit: ^RayHit16, args: ^IntersectArguments) ---


    /* Forwards ray inside user geometry callback. */
    ForwardIntersect1 :: proc(args: ^IntersectFunctionNArguments, scene: Scene, ray: ^Ray, instID: u32) ---

    /* Forwards ray packet of size 4 inside user geometry callback. */
    ForwardIntersect4 :: proc(valid: [^]c.int, args: ^IntersectFunctionNArguments, scene: Scene, ray: ^Ray4, instID: u32) ---

    /* Forwards ray packet of size 8 inside user geometry callback. */
    ForwardIntersect8 :: proc(valid: [^]c.int, args: ^IntersectFunctionNArguments, scene: Scene, ray: ^Ray8, instID: u32) ---

    /* Forwards ray packet of size 16 inside user geometry callback. */
    ForwardIntersect16 :: proc(valid: [^]c.int, args: ^IntersectFunctionNArguments, scene: Scene, ray: ^Ray16, instID: u32) ---


    /* Tests a single ray for occlusion with the scene. */
    Occluded1 :: proc(scene: Scene, ray: ^Ray, args: ^OccludedArguments) ---

    /* Tests a packet of 4 rays for occlusion occluded with the scene. */
    Occluded4 :: proc(valid: [^]c.int, scene: Scene, ray: ^Ray4, args: ^OccludedArguments) ---

    /* Tests a packet of 8 rays for occlusion with the scene. */
    Occluded8 :: proc(valid: [^]c.int, scene: Scene, ray: ^Ray8, args: ^OccludedArguments) ---

    /* Tests a packet of 16 rays for occlusion with the scene. */
    Occluded16 :: proc(valid: [^]c.int, scene: Scene, ray: ^Ray16, args: ^OccludedArguments) ---


    /* Forwards single occlusion ray inside user geometry callback. */
    ForwardOccluded1 :: proc(args: ^OccludedFunctionNArguments, scene: Scene, ray: ^Ray , instID: u32) ---

    /* Forwards occlusion ray packet of size 4 inside user geometry callback. */
    ForwardOccluded4 :: proc(valid: [^]c.int, args: ^OccludedFunctionNArguments, scene: Scene, ray: ^Ray4, instID: u32) ---

    /* Forwards occlusion ray packet of size 8 inside user geometry callback. */
    ForwardOccluded8 :: proc(valid: [^]c.int, args: ^OccludedFunctionNArguments, scene: Scene, ray: ^Ray8, instID: u32) ---

    /* Forwards occlusion ray packet of size 16 inside user geometry callback. */
    ForwardOccluded16 :: proc(valid: [^]c.int, args: ^OccludedFunctionNArguments, scene: Scene, ray: ^Ray16, instID: u32) ---
}

/*! collision callback */
Collision :: struct {
    geomID0: u32,
    primID0: u32,
    geomID1: u32,
    primID1: u32,
}

CollideFunc :: proc "c" (userPtr: rawptr, collisions: [^]Collision, num_collisions: u32)

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /*! Performs collision detection of two scenes */
    Collide :: proc(scene0: Scene, scene: Scene, callback: CollideFunc, userPtr: rawptr) ---
}
