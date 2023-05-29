package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

import "core:c"

when ODIN_OS == .Windows {
    foreign import lib "embree4.lib"
} else {
    foreign import lib "system:embree4"
}

/* Opaque scene type */
Scene :: distinct rawptr

/* Opaque geometry type */
Geometry :: distinct rawptr

/* Types of geometries */
GeometryType :: enum c.int {
    TRIANGLE = 0, // triangle mesh
    QUAD     = 1, // quad (triangle pair) mesh
    GRID     = 2, // grid mesh

    SUBDIVISION = 8, // Catmull-Clark subdivision surface

    CONE_LINEAR_CURVE   = 15, // Cone linear curves - discontinuous at edge boundaries
    ROUND_LINEAR_CURVE  = 16, // Round (rounded cone like) linear curves
    FLAT_LINEAR_CURVE   = 17, // flat (ribbon-like) linear curves

    ROUND_BEZIER_CURVE  = 24, // round (tube-like) Bezier curves
    FLAT_BEZIER_CURVE   = 25, // flat (ribbon-like) Bezier curves
    NORMAL_ORIENTED_BEZIER_CURVE  = 26, // flat normal-oriented Bezier curves

    ROUND_BSPLINE_CURVE = 32, // round (tube-like) B-spline curves
    FLAT_BSPLINE_CURVE  = 33, // flat (ribbon-like) B-spline curves
    NORMAL_ORIENTED_BSPLINE_CURVE  = 34, // flat normal-oriented B-spline curves

    ROUND_HERMITE_CURVE = 40, // round (tube-like) Hermite curves
    FLAT_HERMITE_CURVE  = 41, // flat (ribbon-like) Hermite curves
    NORMAL_ORIENTED_HERMITE_CURVE  = 42, // flat normal-oriented Hermite curves

    SPHERE_POINT = 50,
    DISC_POINT = 51,
    ORIENTED_DISC_POINT = 52,

    ROUND_CATMULL_ROM_CURVE = 58, // round (tube-like) Catmull-Rom curves
    FLAT_CATMULL_ROM_CURVE  = 59, // flat (ribbon-like) Catmull-Rom curves
    NORMAL_ORIENTED_CATMULL_ROM_CURVE  = 60, // flat normal-oriented Catmull-Rom curves

    USER     = 120, // user-defined geometry
    INSTANCE = 121,  // scene instance
}

/* Interpolation modes for subdivision surfaces */
SubdivisionMode :: enum c.int {
    NO_BOUNDARY     = 0,
    SMOOTH_BOUNDARY = 1,
    PIN_CORNERS     = 2,
    PIN_BOUNDARY    = 3,
    PIN_ALL         = 4,
}

/* Curve segment flags */
CurveFlag :: enum c.int {
    NEIGHBOR_LEFT  = 0, // left segments exists
    NEIGHBOR_RIGHT = 1, // right segment exists
}

CurveFlags :: bit_set[CurveFlag]

/* Arguments for RTCBoundsFunction */
BoundsFunctionArguments :: struct{
    geometryUserPtr: rawptr,
    primID: u32,
    timeStep: u32,
    bounds_o: ^Bounds,
}

/* Bounding callback function */
BoundsFunction :: proc "c" (args: ^BoundsFunctionArguments)

/* Arguments for RTCIntersectFunctionN */
IntersectFunctionNArguments :: struct {
    valid: ^c.int,
    geometryUserPtr: rawptr,
    primID: u32,
    ctx: ^RayQueryContext,
    rayhit: ^RayHitN,
    N: u32,
    geomID: u32,
}

/* Arguments for RTCOccludedFunctionN */
OccludedFunctionNArguments :: struct {
    valid: ^c.int,
    geometryUserPtr: rawptr,
    primID: u32,
    ctx: ^RayQueryContext,
    ray: ^RayN,
    N: u32,
    geomID: u32,
}

/* Arguments for RTCDisplacementFunctionN */
DisplacementFunctionNArguments :: struct {
    geometryUserPtr: rawptr,
    geometry: Geometry,
    primID: u32,
    timeStep: u32,
    u: [^]f32,
    v: [^]f32,
    Ng_x: [^]f32,
    Ng_y: [^]f32,
    Ng_z: [^]f32,
    P_x: [^]f32,
    P_y: [^]f32,
    P_z: [^]f32,
    N: u32,
}

/* Displacement mapping callback function */
DisplacementFunctionN :: proc "c" (args: ^DisplacementFunctionNArguments)


@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Creates a new geometry of specified type. */
    NewGeometry :: proc(device: Device, type: GeometryType) -> Geometry ---

    /* Retains the geometry (increments the reference count). */
    RetainGeometry :: proc(geometry: Geometry) ---

    /* Releases the geometry (decrements the reference count) */
    ReleaseGeometry :: proc(geometry: Geometry) ---

    /* Commits the geometry. */
    CommitGeometry :: proc(geometry: Geometry) ---


    /* Enables the geometry. */
    EnableGeometry :: proc(geometry: Geometry) ---

    /* Disables the geometry. */
    DisableGeometry :: proc(geometry: Geometry) ---


    /* Sets the number of motion blur time steps of the geometry. */
    SetGeometryTimeStepCount :: proc(geometry: Geometry, timeStepCount: u32) ---

    /* Sets the motion blur time range of the geometry. */
    SetGeometryTimeRange :: proc(geometry: Geometry, startTime: f32, endTime: f32) ---

    /* Sets the number of vertex attributes of the geometry. */
    SetGeometryVertexAttributeCount :: proc(geometry: Geometry, vertexAttributeCount: u32) ---

    /* Sets the ray mask of the geometry. */
    SetGeometryMask :: proc(geometry: Geometry, mask: u32) ---

    /* Sets the build quality of the geometry. */
    SetGeometryBuildQuality :: proc(geometry: Geometry, quality: BuildQuality) ---

    /* Sets the maximal curve or point radius scale allowed by min-width feature. */
    SetGeometryMaxRadiusScale :: proc(geometry: Geometry, maxRadiusScale: f32) ---


    /* Sets a geometry buffer. */
    SetGeometryBuffer :: proc(geometry: Geometry, type: BufferType, slot: u32, format: Format, buffer: Buffer, byteOffset: int, byteStride: int, itemCount: int) ---

    /* Sets a shared geometry buffer. */
    SetSharedGeometryBuffer :: proc(geometry: Geometry, type: BufferType, slot: u32, format: Format, ptr: rawptr, byteOffset: int, byteStride: int, itemCount: int) ---

    /* Creates and sets a new geometry buffer. */
    SetNewGeometryBuffer :: proc(geometry: Geometry, type: BufferType, slot: u32, format: Format, byteStride: int, itemCount: int) -> rawptr ---

    /* Returns the pointer to the data of a buffer. */
    GetGeometryBufferData :: proc(geometry: Geometry, type: BufferType, slot: u32) -> rawptr ---

    /* Updates a geometry buffer. */
    UpdateGeometryBuffer :: proc(geometry: Geometry, type: BufferType, slot: u32) ---


    /* Sets the intersection filter callback function of the geometry. */
    SetGeometryIntersectFilterFunction :: proc(geometry: Geometry, filter: FilterFunctionN) ---

    /* Sets the occlusion filter callback function of the geometry. */
    SetGeometryOccludedFilterFunction :: proc(geometry: Geometry, filter: FilterFunctionN) ---

    /* Enables argument version of intersection or occlusion filter function. */
    SetGeometryEnableFilterFunctionFromArguments :: proc(geometry: Geometry, enable: bool) ---

    /* Sets the user-defined data pointer of the geometry. */
    SetGeometryUserData :: proc(geometry: Geometry, ptr: rawptr) ---

    /* Gets the user-defined data pointer of the geometry. */
    GetGeometryUserData :: proc(geometry: Geometry) -> rawptr ---

    /* Set the point query callback function of a geometry. */
    SetGeometryPointQueryFunction :: proc(geometry: Geometry, pointQuery: PointQueryFunction) ---

    /* Sets the number of primitives of a user geometry. */
    SetGeometryUserPrimitiveCount :: proc(geometry: Geometry, userPrimitiveCount: u32) ---

    /* Sets the bounding callback function to calculate bounding boxes for user primitives. */
    SetGeometryBoundsFunction :: proc(geometry: Geometry, bounds: BoundsFunction, userPtr: rawptr) ---

    /* Set the intersect callback function of a user geometry. */
    SetGeometryIntersectFunction :: proc(geometry: Geometry, intersect: IntersectFunctionN) ---

    /* Set the occlusion callback function of a user geometry. */
    SetGeometryOccludedFunction :: proc(geometry: Geometry, occluded: OccludedFunctionN) ---

    /* Invokes the intersection filter from the intersection callback function. */
    InvokeIntersectFilterFromGeometry :: proc(args: ^IntersectFunctionNArguments, filterArgs: ^FilterFunctionNArguments) ---

    /* Invokes the occlusion filter from the occlusion callback function. */
    InvokeOccludedFilterFromGeometry :: proc(args: ^OccludedFunctionNArguments, filterArgs: ^FilterFunctionNArguments) ---

    /* Sets the instanced scene of an instance geometry. */
    SetGeometryInstancedScene :: proc(geometry: Geometry, scene: Scene) ---

    /* Sets the transformation of an instance for the specified time step. */
    SetGeometryTransform :: proc(geometry: Geometry, timeStep: u32, format: Format, xfm: rawptr) ---

    /* Sets the transformation quaternion of an instance for the specified time step. */
    SetGeometryTransformQuaternion :: proc(geometry: Geometry, timeStep: u32, qd: ^QuaternionDecomposition) ---

    /* Returns the interpolated transformation of an instance for the specified time. */
    GetGeometryTransform :: proc(geometry: Geometry, time: f32, format: Format, xfm: rawptr) ---


    /* Sets the uniform tessellation rate of the geometry. */
    SetGeometryTessellationRate :: proc(geometry: Geometry, tessellationRate: f32) ---

    /* Sets the number of topologies of a subdivision surface. */
    SetGeometryTopologyCount :: proc(geometry: Geometry, topologyCount: u32) ---

    /* Sets the subdivision interpolation mode. */
    SetGeometrySubdivisionMode :: proc(geometry: Geometry, topologyID: u32, mode: SubdivisionMode) ---

    /* Binds a vertex attribute to a topology of the geometry. */
    SetGeometryVertexAttributeTopology :: proc(geometry: Geometry, vertexAttributeID: u32, topologyID: u32) ---

    /* Sets the displacement callback function of a subdivision surface. */
    SetGeometryDisplacementFunction :: proc(geometry: Geometry, displacement: DisplacementFunctionN) ---

    /* Returns the first half edge of a face. */
    GetGeometryFirstHalfEdge :: proc(geometry: Geometry, faceID: u32) -> u32 ---

    /* Returns the face the half edge belongs to. */
    GetGeometryFace :: proc(geometry: Geometry, edgeID: u32) -> u32 ---

    /* Returns next half edge. */
    GetGeometryNextHalfEdge :: proc(geometry: Geometry, edgeID: u32) -> u32 ---

    /* Returns previous half edge. */
    GetGeometryPreviousHalfEdge :: proc(geometry: Geometry, edgeID: u32) -> u32 ---

    /* Returns opposite half edge. */
    GetGeometryOppositeHalfEdge :: proc(geometry: Geometry, topologyID: u32, edgeID: u32) -> u32 ---
}


/* Arguments for rtcInterpolate */
InterpolateArguments :: struct {
    geometry: Geometry,
    primID: u32,
    u: f32,
    v: f32,
    bufferType: BufferType,
    bufferSlot: u32,
    P: [^]f32,
    dPdu: [^]f32,
    dPdv: [^]f32,
    ddPdudu: [^]f32,
    ddPdvdv: [^]f32,
    ddPdudv: [^]f32,
    valueCount: u32,
}

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Interpolates vertex data to some u/v location and optionally calculates all derivatives. */
    Interpolate :: proc(args: ^InterpolateArguments) ---
}

/* Interpolates vertex data to some u/v location. */
Interpolate0 :: proc(geometry: Geometry, primID: u32, u: f32, v: f32, bufferType: BufferType, bufferSlot: u32, P: ^f32, valueCount: u32) {
    args: InterpolateArguments
    args.geometry = geometry
    args.primID = primID
    args.u = u
    args.v = v
    args.bufferType = bufferType
    args.bufferSlot = bufferSlot
    args.P = P
    args.dPdu = nil
    args.dPdv = nil
    args.ddPdudu = nil
    args.ddPdvdv = nil
    args.ddPdudv = nil
    args.valueCount = valueCount
    Interpolate(&args)
}

/* Interpolates vertex data to some u/v location and calculates first order derivatives. */
Interpolate1 :: proc(geometry: Geometry, primID: u32, u: f32, v: f32, bufferType: BufferType, bufferSlot: u32,
                     P: [^]f32, dPdu: [^]f32, dPdv: [^]f32, valueCount: u32) {
    args: InterpolateArguments
    args.geometry = geometry
    args.primID = primID
    args.u = u
    args.v = v
    args.bufferType = bufferType
    args.bufferSlot = bufferSlot
    args.P = P
    args.dPdu = dPdu
    args.dPdv = dPdv
    args.ddPdudu = nil
    args.ddPdvdv = nil
    args.ddPdudv = nil
    args.valueCount = valueCount
    Interpolate(&args)
}

/* Interpolates vertex data to some u/v location and calculates first and second order derivatives. */
Interpolate2 :: proc(geometry: Geometry, primID: u32, u: f32, v: f32, bufferType: BufferType, bufferSlot: u32,
                     P: [^]f32, dPdu: [^]f32, dPdv: [^]f32, ddPdudu: [^]f32, ddPdvdv: [^]f32, ddPdudv: [^]f32, valueCount: u32) {
    args: InterpolateArguments
    args.geometry = geometry
    args.primID = primID
    args.u = u
    args.v = v
    args.bufferType = bufferType
    args.bufferSlot = bufferSlot
    args.P = P
    args.dPdu = dPdu
    args.dPdv = dPdv
    args.ddPdudu = ddPdudu
    args.ddPdvdv = ddPdvdv
    args.ddPdudv = ddPdudv
    args.valueCount = valueCount
    Interpolate(&args)
}

/* Arguments for rtcInterpolateN */
InterpolateNArguments :: struct {
    geometry: Geometry,
    valid: rawptr,
    primIDs: [^]u32,
    u: [^]f32,
    v: [^]f32,
    N: u32,
    bufferType: BufferType,
    bufferSlot: u32,
    P: [^]f32,
    dPdu: [^]f32,
    dPdv: [^]f32,
    ddPdudu: [^]f32,
    ddPdvdv: [^]f32,
    ddPdudv: [^]f32,
    valueCount: u32,
}

@(default_calling_convention="c", link_prefix="rtc")
foreign lib {
    /* Interpolates vertex data to an array of u/v locations. */
    InterpolateN :: proc(args: ^InterpolateNArguments) ---
}

/* RTCGrid primitive for grid mesh */
Grid :: struct {
  startVertexID: u32,
  stride: u32,
  width, height: u16, // max is a 32k x 32k grid
}
