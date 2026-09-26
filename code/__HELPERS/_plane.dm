/// Amount of plane space reserved for one Z-level.
///
/// Every regular plane keeps the same relative ordering inside a Z-level.
/// The Z-level itself is moved by this amount.
#define Z_LEVEL_PLANE_RANGE 1000

/// Returns a plane shifted by a Z-level offset.
///
/// offset = 0 -> original plane
/// offset = 1 -> one rendering level below
/// offset = -1 -> one rendering level above
#define GET_Z_PLANE(plane, offset) ((plane) - ((offset) * Z_LEVEL_PLANE_RANGE))

/// Returns the plane offset required to render source_z relative to viewer_z.
///
/// source_z == viewer_z -> 0
/// source_z below viewer_z -> positive offset
/// source_z above viewer_z -> negative offset
#define GET_Z_PLANE_OFFSET(source_z, viewer_z) ((viewer_z) - (source_z))

/// Returns the plane used to render an atom located on source_z
/// for a viewer currently looking at viewer_z.
#define GET_Z_PLANE_FOR(plane, source_z, viewer_z) GET_Z_PLANE((plane), GET_Z_PLANE_OFFSET((source_z), (viewer_z)))
