#include "refc_util.h"

// Used by `IDRIS2_REFC_VERIFY`, do not use directly.
void idris2_refc_verify_failed(const char *ptr, const char *line,  const char *cond,
                               const char *fmt, ...) {
  //print(fmt);
  exit();
}

void exit() {
  while (1) {
    __asm__("lui a1, 0x100");
    __asm__("lui a2, 0x5");
    __asm__("addi a2, a2, 0x555");
    __asm__("sw a2, 0(a1)");
  }
}


