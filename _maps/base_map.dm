// SS220 EDIT - START
// ORIGINAL: #include "map_files\generic\centcomm.dmm"
#define ENABLE_TEST_CC

#ifndef ENABLE_TEST_CC
#include "map_files220\generic\centcomm.dmm"
#include "map_files220\generic\Admin_Zone.dmm"
#endif

#ifdef ENABLE_TEST_CC
#include "map_files220\generic\test_cc.dmm"
#endif
// SS220 EDIT - END

#define CC_TRANSITION_CONFIG DECLARE_LEVEL(CENTCOMM, SELFLOOPING, list(ADMIN_LEVEL, BLOCK_TELEPORT, IMPEDES_MAGIC))
#ifdef CIMAP
#include "ci_map_testing.dm"
#endif
