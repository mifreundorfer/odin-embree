package embree

// Copyright 2009-2021 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

/*
 * Structure for transformation representation as a matrix decomposition using
 * a quaternion
 */
QuaternionDecomposition :: struct #align 16 {
    scale_x: f32,
    scale_y: f32,
    scale_z: f32,
    skew_xy: f32,
    skew_xz: f32,
    skew_yz: f32,
    shift_x: f32,
    shift_y: f32,
    shift_z: f32,
    quaternion_r: f32,
    quaternion_i: f32,
    quaternion_j: f32,
    quaternion_k: f32,
    translation_x: f32,
    translation_y: f32,
    translation_z: f32,
}

InitQuaternionDecomposition :: proc(qdecomp: ^QuaternionDecomposition) {
    qdecomp.scale_x = 1.0
    qdecomp.scale_y = 1.0
    qdecomp.scale_z = 1.0
    qdecomp.skew_xy = 0.0
    qdecomp.skew_xz = 0.0
    qdecomp.skew_yz = 0.0
    qdecomp.shift_x = 0.0
    qdecomp.shift_y = 0.0
    qdecomp.shift_z = 0.0
    qdecomp.quaternion_r = 1.0
    qdecomp.quaternion_i = 0.0
    qdecomp.quaternion_j = 0.0
    qdecomp.quaternion_k = 0.0
    qdecomp.translation_x = 0.0
    qdecomp.translation_y = 0.0
    qdecomp.translation_z = 0.0
}

QuaternionDecompositionSetQuaternion :: proc(qdecomp: ^QuaternionDecomposition, r, i, j, k: f32) {
    qdecomp.quaternion_r = r
    qdecomp.quaternion_i = i
    qdecomp.quaternion_j = j
    qdecomp.quaternion_k = k
}

QuaternionDecompositionSetScale :: proc(qdecomp: ^QuaternionDecomposition, scale_x, scale_y, scale_z: f32) {
    qdecomp.scale_x = scale_x
    qdecomp.scale_y = scale_y
    qdecomp.scale_z = scale_z
}

QuaternionDecompositionSetSkew :: proc(qdecomp: ^QuaternionDecomposition, skew_xy, skew_xz, skew_yz: f32) {
    qdecomp.skew_xy = skew_xy
    qdecomp.skew_xz = skew_xz
    qdecomp.skew_yz = skew_yz
}

QuaternionDecompositionSetShift :: proc(qdecomp: ^QuaternionDecomposition, shift_x, shift_y, shift_z: f32) {
    qdecomp.shift_x = shift_x
    qdecomp.shift_y = shift_y
    qdecomp.shift_z = shift_z
}

QuaternionDecompositionSetTranslation :: proc(qdecomp: ^QuaternionDecomposition, translation_x, translation_y, translation_z: f32) {
    qdecomp.translation_x = translation_x
    qdecomp.translation_y = translation_y
    qdecomp.translation_z = translation_z
}
