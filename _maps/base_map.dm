/**
 * SS220 EDIT - START
 * ORIGINAL: #include "map_files\generic\centcomm.dmm"
 * Uncomment define bellow if you need faster init for testing.
 */
//#define ENABLE_TEST_CC

#ifndef ENABLE_TEST_CC
#include "map_files220\generic\centcomm.dmm"
#else
#include "map_files220\generic\centcomm_test.dmm"
#endif
// SS220 EDIT - END
#define CC_TRANSITION_CONFIG DECLARE_LEVEL(CENTCOMM, UNAFFECTED, list(ADMIN_LEVEL, BLOCK_TELEPORT, IMPEDES_MAGIC))
#ifdef CIMAP
#include "ci_map_testing.dm"
#endif
