#
# License: See LICENSE.md file
# GitHub: https://github.com/Baekalfen/PyBoy
#


cimport pyboy.core.mb
cimport opcodes

from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from libc.stdint cimport int16_t
from pyboy.utils cimport IntIOInterface

import cython


cdef uint16_t IF_ADDRESS, IE_ADDRESS
cdef short FLAGC, FLAGH, FLAGN, FLAGZ
cdef uint8_t INTR_VBLANK, INTR_LCDC, INTR_TIMER, INTR_SERIAL, INTR_HIGHTOLOW



cdef class CPU:
    cdef bint interrupt_master_enable, halted, stopped, profiling

    cdef uint8_t interrupts_flag, interrupts_enabled

    cdef int[512] hitrate

    cdef int check_interrupts(self)
    cdef void set_interruptflag(self, int)
    cdef bint handle_interrupt(self, uint8_t, uint16_t)

    @cython.locals(opcode=cython.ushort)
    cdef char fetch_and_execute(self, uint64_t)
    cdef int tick(self)
    cdef void save_state(self, IntIOInterface)
    cdef void load_state(self, IntIOInterface, int)

    # Only char (8-bit) needed, but I'm not sure all intermittent
    # results do not overflow
    cdef short A, F, B, C, D, E

    # Only short (16-bit) needed, but I'm not sure all intermittent
    # results do not overflow
    cdef int HL, SP, PC

    cdef pyboy.core.mb.Motherboard mb

    cdef void set_bc(CPU, int)
    cdef void set_de(CPU, int)

    cdef bint f_c(self)
    cdef bint f_h(self)
    cdef bint f_n(self)
    cdef bint f_z(self)
    cdef bint f_nc(self)
    cdef bint f_nz(self)
