#!/usr/bin/env python3
"""
ARM Thumb disassembler for DMR firmware analysis
Focuses on tracing control flow from contactType comparison locations
"""

import struct
import sys

class ARMThumbDisasm:
    def __init__(self, firmware_path, base_addr=0x08000000):
        with open(firmware_path, 'rb') as f:
            self.data = f.read()
        self.base = base_addr
        
    def read_u16(self, offset):
        """Read 16-bit little-endian value"""
        if offset + 1 < len(self.data):
            return struct.unpack('<H', self.data[offset:offset+2])[0]
        return 0
    
    def addr_to_offset(self, addr):
        """Convert address to file offset"""
        return addr - self.base
    
    def offset_to_addr(self, offset):
        """Convert file offset to address"""
        return self.base + offset
    
    def decode_thumb(self, offset):
        """Decode single Thumb instruction at offset"""
        instr = self.read_u16(offset)
        addr = self.offset_to_addr(offset)
        
        # Extract bytes for display
        b1 = self.data[offset]
        b2 = self.data[offset + 1]
        
        # Pattern matching for common instructions
        
        # CMP immediate: 001 01 Rn imm8
        if (instr & 0xF800) == 0x2800:
            rn = (instr >> 8) & 0x7
            imm = instr & 0xFF
            return f"cmp r{rn}, #{imm}", 2
        
        # CMP register: 010000 1010 Rm Rn
        if (instr & 0xFFC0) == 0x4280:
            rm = (instr >> 3) & 0x7
            rn = instr & 0x7
            return f"cmp r{rn}, r{rm}", 2
        
        # Conditional branch: 1101 cond imm8
        if (instr & 0xF000) == 0xD000:
            cond = (instr >> 8) & 0xF
            imm = instr & 0xFF
            if imm > 127:
                imm = imm - 256
            target = addr + 4 + (imm * 2)
            cond_names = ["beq", "bne", "bcs", "bcc", "bmi", "bpl", "bvs", "bvc",
                         "bhi", "bls", "bge", "blt", "bgt", "ble", "b", "und"]
            return f"{cond_names[cond]} 0x{target:08x}", 2
        
        # Unconditional branch: 11100 imm11
        if (instr & 0xF800) == 0xE000:
            imm = instr & 0x7FF
            if imm > 1023:
                imm = imm - 2048
            target = addr + 4 + (imm * 2)
            return f"b 0x{target:08x}", 2
        
        # BL/BLX (32-bit instruction)
        if (instr & 0xF800) == 0xF000:
            instr2 = self.read_u16(offset + 2)
            if (instr2 & 0xD000) == 0xD000:
                imm11_1 = instr & 0x7FF
                imm11_2 = instr2 & 0x7FF
                s = (instr >> 10) & 1
                j1 = (instr2 >> 13) & 1
                j2 = (instr2 >> 11) & 1
                i1 = not (j1 ^ s)
                i2 = not (j2 ^ s)
                imm = (s << 24) | (i1 << 23) | (i2 << 22) | (imm11_1 << 11) | imm11_2
                if imm & 0x1000000:
                    imm = imm - 0x2000000
                target = addr + 4 + (imm * 2)
                return f"bl 0x{target:08x}", 4
        
        # LDR immediate: 01101 imm5 Rn Rt
        if (instr & 0xF800) == 0x6800:
            imm = ((instr >> 6) & 0x1F) * 4
            rn = (instr >> 3) & 0x7
            rt = instr & 0x7
            return f"ldr r{rt}, [r{rn}, #{imm}]", 2
        
        # LDRB immediate
        if (instr & 0xF800) == 0x7800:
            imm = (instr >> 6) & 0x1F
            rn = (instr >> 3) & 0x7
            rt = instr & 0x7
            return f"ldrb r{rt}, [r{rn}, #{imm}]", 2
        
        # MOV immediate: 001 00 Rd imm8
        if (instr & 0xF800) == 0x2000:
            rd = (instr >> 8) & 0x7
            imm = instr & 0xFF
            return f"movs r{rd}, #{imm}", 2
        
        # LSL immediate: 000 00 imm5 Rm Rd
        if (instr & 0xF800) == 0x0000 and instr != 0:
            imm = (instr >> 6) & 0x1F
            rm = (instr >> 3) & 0x7
            rd = instr & 0x7
            if imm > 0:
                return f"lsls r{rd}, r{rm}, #{imm}", 2
        
        # ORR register: 010000 1100 Rm Rdn
        if (instr & 0xFFC0) == 0x4300:
            rm = (instr >> 3) & 0x7
            rdn = instr & 0x7
            return f"orrs r{rdn}, r{rm}", 2
        
        # NOP: 1011 1111 0000 0000
        if instr == 0xBF00:
            return "nop", 2
        
        # Default
        return f"?? ({b1:02x} {b2:02x})", 2
    
    def disassemble_range(self, start_addr, count=50):
        """Disassemble instructions starting from address"""
        offset = self.addr_to_offset(start_addr)
        results = []
        
        for _ in range(count):
            if offset >= len(self.data) - 1:
                break
            
            addr = self.offset_to_addr(offset)
            instr_str, size = self.decode_thumb(offset)
            
            # Get raw bytes
            if size == 2:
                b1 = self.data[offset]
                b2 = self.data[offset + 1]
                bytes_str = f"{b1:02x} {b2:02x}"
            else:
                b1 = self.data[offset]
                b2 = self.data[offset + 1]
                b3 = self.data[offset + 2]
                b4 = self.data[offset + 3]
                bytes_str = f"{b1:02x} {b2:02x} {b3:02x} {b4:02x}"
            
            results.append(f"0x{addr:08x}: {bytes_str:12s} {instr_str}")
            offset += size
        
        return results
    
    def trace_branches(self, start_addr, depth=5):
        """Trace execution flow from address, following branches"""
        visited = set()
        to_visit = [(start_addr, 0)]
        results = {}
        
        while to_visit:
            addr, level = to_visit.pop(0)
            if level > depth or addr in visited:
                continue
            
            visited.add(addr)
            offset = self.addr_to_offset(addr)
            
            if offset < 0 or offset >= len(self.data) - 1:
                continue
            
            instr_str, size = self.decode_thumb(offset)
            results[addr] = (level, instr_str)
            
            # Follow branches
            if "b" in instr_str and "0x" in instr_str:
                try:
                    target_str = instr_str.split("0x")[1].split()[0]
                    target = int(target_str, 16)
                    to_visit.append((target, level + 1))
                except:
                    pass
            
            # Continue to next instruction
            if not instr_str.startswith("b "):  # Not unconditional branch
                to_visit.append((addr + size, level))
        
        return results


def main():
    print("=== ARM Thumb Disassembler for DMR Firmware ===\n")
    
    fw_path = "app/src/main/assets/DMR003.UV4T.V022.bin"
    disasm = ARMThumbDisasm(fw_path)
    
    # ContactType comparison locations
    locations = [
        (0x08018F26, "Location 1"),
        (0x080392C9, "Location 2"),  
        (0x080490E2, "Location 3"),
        (0x080524E0, "Location 4"),
        (0x080524FA, "Location 5"),
    ]
    
    for addr, name in locations:
        print(f"\n{'='*60}")
        print(f"{name}: 0x{addr:08x}")
        print('='*60)
        
        # Disassemble 30 instructions
        lines = disasm.disassemble_range(addr, 30)
        for line in lines:
            # Highlight contactType comparison
            if "cmp r2, #2" in line:
                print(f"{line}  <-- contactType check")
            elif "cmp r7, #0x22" in line:
                print(f"{line}  <-- CMD 0x22 check")
            else:
                print(line)
        
        print(f"\n--- Control Flow Trace (depth=3) ---")
        flow = disasm.trace_branches(addr, depth=3)
        for trace_addr in sorted(flow.keys()):
            level, instr = flow[trace_addr]
            indent = "  " * level
            print(f"{indent}0x{trace_addr:08x}: {instr}")


if __name__ == "__main__":
    main()
