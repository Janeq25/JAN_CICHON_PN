/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 


.macro LOAD_CONST
    ldi @0, low(@2)
    ldi @1, high(@2)
.endmacro

LOAD_CONST R16, R17, 1234

