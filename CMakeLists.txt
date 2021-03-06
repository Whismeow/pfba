cmake_minimum_required(VERSION 3.0)
#set(CMAKE_VERBOSE_MAKEFILE ON)

# pfba version
set(PFBA_VERSION_MAJOR 1)
set(PFBA_VERSION_MINOR 57)

# delete cmake cache folder before changing this option
set(BUILD_SFML OFF CACHE BOOL "Build with SFML support")
set(BUILD_SDL1 OFF CACHE BOOL "Build with SDL1 support (software, osmesa) support")
set(BUILD_SDL1_GL OFF CACHE BOOL "Build with SDL1 support (hardware rendering, fast, needs BUILD_SDL1=ON)")
set(BUILD_SDL2 OFF CACHE BOOL "Build with SDL2 (software) support")
set(BUILD_SDL2_GL OFF CACHE BOOL "Build with SDL2 support (hardware rendering, fast, needs BUILD_SDL2=ON)")
set(BUILD_PSP2 OFF CACHE BOOL "Build with PSP2 support")
set(BUILD_PS3 OFF CACHE BOOL "Build with PS3 support")
set(BUILD_3DS OFF CACHE BOOL "Build with 3DS support")
set(BUILD_NX OFF CACHE BOOL "Build with NX (SWITCH) support")
set(BUILD_NX_GL OFF CACHE BOOL "Build with NX (SWITCH) support (software, osmesa)")

set(BUILD_PFBA ON CACHE BOOL "Build with PFBA support")
set(UPDATE_CONFIG ON "Force config file updating")

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(BUILD_DEBUG true CACHE BOOL "Debug build")
endif ()

# add libcross2d/libcross2dui library. If you want to port pfba to another platform,
# you should (may) only need to port libcross2d library.
include(libcross2dui/libcross2d/Toolchain.cmake)
add_subdirectory(libcross2dui)
#enable_language(ASM)

execute_process(COMMAND "date" "+%Y.%m.%d" OUTPUT_VARIABLE BUILD_DATE OUTPUT_STRIP_TRAILING_WHITESPACE)

project(pfba)

# handle m68k
FILE(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/deps)
ADD_CUSTOM_COMMAND(OUTPUT
        ${CMAKE_BINARY_DIR}/deps/m68kops.h ${CMAKE_BINARY_DIR}/deps/m68kops.c
        COMMAND gcc ${CMAKE_SOURCE_DIR}/fba/src/cpu/m68k/m68kmake.c -o ${CMAKE_BINARY_DIR}/deps/m68kmake
        COMMAND ${CMAKE_BINARY_DIR}/deps/m68kmake ${CMAKE_BINARY_DIR}/deps/ ${CMAKE_SOURCE_DIR}/fba/src/cpu/m68k/m68k_in.c)

##############
# burn
##############
set(BURN_DIRS
        fba/src/burn
        fba/src/burn/devices
        fba/src/burn/snd
        )
file(GLOB SRC_BURN
        fba/src/burn/*.c*
        fba/src/burn/devices/*.c*
        fba/src/burn/snd/*.c*
        )

##############
# burner
##############
set(BURNER_DIRS
        fba/src/burner
        )
file(GLOB SRC_BURNER
        fba/src/burner/*.c*
        )
list(REMOVE_ITEM SRC_BURNER
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/conc.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/cong.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/dat.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/gamc.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/gami.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/image.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/misc.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/sshot.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burner/state.cpp
        )
##############
# drivers
##############
set(DRV_DIRS
        fba/src/burn/drv
        fba/src/burn/drv/capcom
        fba/src/burn/drv/cave
        fba/src/burn/drv/coleco
        fba/src/burn/drv/cps3
        fba/src/burn/drv/dataeast
        fba/src/burn/drv/galaxian
        fba/src/burn/drv/irem
        fba/src/burn/drv/konami
        fba/src/burn/drv/megadrive
        fba/src/burn/drv/midway
        fba/src/burn/drv/msx
        fba/src/burn/drv/neogeo
        fba/src/burn/drv/pce
        fba/src/burn/drv/pgm
        fba/src/burn/drv/pre90s
        fba/src/burn/drv/psikyo
        fba/src/burn/drv/pst90s
        fba/src/burn/drv/sega
        fba/src/burn/drv/sg1000
        fba/src/burn/drv/sms
        fba/src/burn/drv/snes
        fba/src/burn/drv/taito
        fba/src/burn/drv/toaplan
        )
file(GLOB_RECURSE SRC_DRV
        fba/src/burn/drv/*.cpp
        )
list(REMOVE_ITEM SRC_DRV
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burn/drv/capcom/ctv_make.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/burn/drv/pgm/pgm_sprite_create.cpp
        )

##############
# interfaces
##############
set(INTF_DIRS
        fba/src/intf
        fba/src/intf/input
        fba/src/intf/cd
        fba/src/intf/audio
        )
file(GLOB SRC_INTF
        fba/src/intf/*.cpp
        fba/src/intf/input/*.cpp
        fba/src/intf/cd/*.cpp
        fba/src/intf/audio/*.cpp
        )
list(REMOVE_ITEM SRC_INTF
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/intf/input/inp_interface.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/intf/audio/aud_dsp.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/intf/audio/aud_interface.cpp
        )

##############
# cpu
##############
set(CPU_DIRS
        fba/src/cpu
        #fba/src/cpu/a68k
        fba/src/cpu/adsp2100
        fba/src/cpu/tms34010
        fba/src/cpu/arm
        fba/src/cpu/arm7
        fba/src/cpu/h6280
        fba/src/cpu/hd6309
        fba/src/cpu/i8039
        fba/src/cpu/i8x41
        fba/src/cpu/i8051
        fba/src/cpu/konami
        fba/src/cpu/m68k
        fba/src/cpu/m6502
        fba/src/cpu/m6800
        fba/src/cpu/m6805
        fba/src/cpu/m6809
        fba/src/cpu/mips3
        fba/src/cpu/nec
        fba/src/cpu/pic16c5x
        fba/src/cpu/s2650
        fba/src/cpu/tlcs90
        fba/src/cpu/sh2
        fba/src/cpu/tms32010
        fba/src/cpu/upd7725
        fba/src/cpu/upd7810
        fba/src/cpu/v60
        fba/src/cpu/z80
        fba/src/cpu/z180
        )
file(GLOB SRC_CPU
        fba/src/cpu/*.c*
        #fba/src/cpu/a68k/*.c*
        fba/src/cpu/adsp2100/*.c*
        fba/src/cpu/tms34010/*.c*
        fba/src/cpu/arm/*.c*
        fba/src/cpu/arm7/*.c*
        fba/src/cpu/h6280/*.c*
        fba/src/cpu/hd6309/*.c*
        fba/src/cpu/i8039/*.c*
        fba/src/cpu/i8x41/*.c*
        fba/src/cpu/i8051/*.c*
        fba/src/cpu/konami/*.c*
        fba/src/cpu/m68k/*.c*
        fba/src/cpu/m6502/*.c*
        fba/src/cpu/m6800/*.c*
        fba/src/cpu/m6805/*.c*
        fba/src/cpu/m6809/*.c*
        fba/src/cpu/mips3/*.c*
        fba/src/cpu/nec/*.c*
        fba/src/cpu/pic16c5x/*.c*
        fba/src/cpu/s2650/*.c*
        fba/src/cpu/tlcs90/*.c*
        fba/src/cpu/sh2/*.c*
        fba/src/cpu/tms32010/*.c*
        fba/src/cpu/upd7725/*.c*
        fba/src/cpu/upd7810/*.c*
        fba/src/cpu/v60/*.c*
        fba/src/cpu/z80/*.c*
        fba/src/cpu/z180/*.c*
        # PFBA
        #pfba/cpu/c68000_intf.cpp
        )
list(REMOVE_ITEM SRC_CPU
        #${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m68000_intf.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/adsp2100/2100ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/tms34010/tms34010_dasm.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/tms34010/tms34010_newdasm.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m68k/m68kmake.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m68k/m68k_in.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m68k/m68kfpu.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m68k/m68kdasm.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/arm7/arm7core.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/arm7/arm7exec.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/hd6309/6309tbl.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/h6280/tblh6280.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/hd6309/6309ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/konami/konamops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6502/t6502.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6502/t65c02.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6502/t65sc02.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6502/tdeco16.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6502/tn2a03.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/konami/konamtbl.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6800/6800ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6800/6800tbl.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6805/6805ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6809/6809ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/m6809/6809tbl.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/mips3/mips3_dasm.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/nec/necinstr.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/nec/v25sfr.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/nec/v25instr.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/i8051/mcs51ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/i8x41/8x41dasm.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/upd7810/7810ops.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/upd7810/7810tbl.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op12.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/am.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/am1.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/am2.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op7a.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/am3.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op2.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op4.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op6.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op3.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/op5.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/optable.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/v60mem.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/v60/v60d.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/z180/z180cb.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/z180/z180dd.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/z180/z180ed.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/z180/z180fd.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/z180/z180op.c
        ${CMAKE_CURRENT_SOURCE_DIR}/fba/src/cpu/z180/z180xy.c
        )

##############
# 7z
##############
set(7Z_DIRS
        fba/src/dep/libs/lib7z
        )
file(GLOB SRC_7Z
        fba/src/dep/libs/lib7z/7zDec.c
        fba/src/dep/libs/lib7z/7zArcIn.c
        fba/src/dep/libs/lib7z/7zStream.c
        fba/src/dep/libs/lib7z/LzmaDec.c
        fba/src/dep/libs/lib7z/Lzma2Dec.c
        fba/src/dep/libs/lib7z/Bra.c
        fba/src/dep/libs/lib7z/Bcj2.c
        fba/src/dep/libs/lib7z/7zBuf.c
        fba/src/dep/libs/lib7z/Delta.c
        fba/src/dep/libs/lib7z/Bra86.c
        fba/src/dep/libs/lib7z/BraIA64.c
        fba/src/dep/libs/lib7z/7zCrc.c
        fba/src/dep/libs/lib7z/7zCrcOpt.c
        fba/src/dep/libs/lib7z/CpuArch.c
        )

##############
# pfba
##############
set(PFBA_DIRS pfba pfba/fba)
file(GLOB SRC_PFBA pfba/*.c* pfba/fba/*.c*)

# includes
set(INC ${PFBA_DIRS}
        ${7Z_DIRS}
        ${BURN_DIRS}
        ${BURNER_DIRS}
        ${DRV_DIRS}
        ${CPU_DIRS}
        ${INTF_DIRS}
        ${CMAKE_BINARY_DIR}/deps
        ${PROJECT_BINARY_DIR}/deps)

# flags
set(FLAGS
        -D__PFBA__
        -D__PFBA_VERSION_MAJOR__=${PFBA_VERSION_MAJOR}
        -D__PFBA_VERSION_MINOR__=${PFBA_VERSION_MINOR}
        -DINCLUDE_7Z_SUPPORT
        -DUSE_SPEEDHACKS -DBUILD_SDL -DBUILD_M68K
        -Wno-write-strings -Wno-narrowing -fforce-addr -finline-limit=1200 -Wno-sign-compare
        -DFASTCALL -U__fastcall -D_fastcall= -D__fastcall= -D__fastcall__=
        #"-DINLINE=static inline" "-DSH2_INLINE=static inline"
        -Wno-unused-variable -Wno-unused-but-set-variable -Wno-sequence-point
        #-fcheck-new
        )

#################
# PSP2 (ps vita)
#################
if (BUILD_PSP2)
    #list(APPEND INC pfba/cpu/cyclone)
    #list(APPEND SRC_PFBA pfba/cpu/cyclone/Cyclone.s)
    list(APPEND FLAGS -DNO_KEYBOARD -DBUILD_C68K -DUSE_FILE32API -DLSB_FIRST)
    #-D__PFBA_ARM__
    if (BUILD_DEBUG)
        list(APPEND FLAGS
                -D__PSP2_DEBUG__ -g # TODO: cyclone arm asm core not working without O2/O3
                )
    else ()
        list(APPEND FLAGS
                -mfpu=neon -mcpu=cortex-a9 -march=armv7-a -mfloat-abi=hard -ffast-math
                -fno-asynchronous-unwind-tables -funroll-loops
                -mword-relocations -fno-unwind-tables -fno-optimize-sibling-calls
                -mvectorize-with-neon-quad -funsafe-math-optimizations
                -mlittle-endian -munaligned-access
                -fsingle-precision-constant
                )
    endif (BUILD_DEBUG)
    set(LDFLAGS ScePower_stub)
elseif (BUILD_PS3)
    ##############
    # PS3
    ##############
    list(APPEND FLAGS
            -D__PS3__
            -DNO_KEYBOARD -D__CELLOS_LV2__ -DUSE_FILE32API
            -mhard-float -ffunction-sections -fdata-sections)
    set(LDFLAGS
            ${PSL1GHT}/ppu/lib/libpngdec.a
            ${PSL1GHT}/portlibs/ppu/lib/libfreetype.a
            ${PSL1GHT}/portlibs/ppu/lib/libpng.a
            ${PSL1GHT}/portlibs/ppu/lib/libtiff.a
            ${PSL1GHT}/portlibs/ppu/lib/libjpeg.a
            ${PSL1GHT}/ppu/lib/libgcm_sys.a
            ${PSL1GHT}/ppu/lib/librsx.a
            ${PSL1GHT}/ppu/lib/libsysutil.a
            ${PSL1GHT}/ppu/lib/libsysmodule.a
            ${PSL1GHT}/ppu/lib/libio.a
            ${PSL1GHT}/ppu/lib/libaudio.a
            ${PSL1GHT}/portlibs/ppu/lib/libz.a)
elseif (BUILD_3DS)
    ##############
    # 3DS
    ##############
    list(APPEND INC
            ${DEVKITPRO}/libctru/include
            ${DEVKITPRO}/portlibs/armv6k/include)
    list(APPEND FLAGS -DARM11 -D_3DS -D__3DS__
            -DNO_KEYBOARD -D__PFBA_ARM__ -DUSE_FILE32API -DLSB_FIRST
            -ffunction-sections -fomit-frame-pointer)
    set(LDFLAGS
            ${DEVKITPRO}/portlibs/armv6k/lib/libpng.a
            ${DEVKITPRO}/portlibs/armv6k/lib/libz.a
            ${DEVKITPRO}/libctru/lib/libcitro3d.a
            ${DEVKITPRO}/libctru/lib/libctru.a
            m)
elseif (BUILD_NX)
    ##############
    # NX (SWITCH)
    ##############
    list(APPEND FLAGS
            -DNO_KEYBOARD -DUSE_FILE32API -DLSB_FIRST
            -ffunction-sections -fomit-frame-pointer)
elseif (BUILD_SDL2)
    ##############
    # SDL2
    ##############
    list(APPEND FLAGS -DLSB_FIRST)
elseif (BUILD_SDL1)
    ##############
    # SDL1
    ##############
    list(APPEND FLAGS -DLSB_FIRST)
elseif (BUILD_SFML)
    ##############
    # SFML
    ##############
    list(APPEND FLAGS -DLSB_FIRST)
endif (BUILD_PSP2)

# source files
set(SRC ${SRC_PFBA} ${SRC_CPU} ${SRC_DRV} ${SRC_BURN} ${SRC_BURNER} ${SRC_INTF} ${SRC_7Z})

############
# FBA deps
############
add_custom_target(${PROJECT_NAME}.deps
        COMMAND rm -rf ${PROJECT_BINARY_DIR}/deps && mkdir ${PROJECT_BINARY_DIR}/deps
        # driverlist.h
        COMMAND perl ${CMAKE_SOURCE_DIR}/fba/src/dep/scripts/gamelist.pl -o deps/driverlist.h -l deps/gamelist.txt ${SRC_DRV}
        # ctv.h
        COMMAND g++ ${CMAKE_SOURCE_DIR}/fba/src/burn/drv/capcom/ctv_make.cpp -o deps/ctv_make
        COMMAND ${PROJECT_BINARY_DIR}/deps/ctv_make > deps/ctv.h
        # pgm sprite
        COMMAND g++ ${CMAKE_SOURCE_DIR}/fba/src/burn/drv/pgm/pgm_sprite_create.cpp -o deps/pgm_sprite_create
        COMMAND ${PROJECT_BINARY_DIR}/deps/pgm_sprite_create > deps/pgm_sprite.h
        # func headers
        COMMAND perl ${CMAKE_SOURCE_DIR}/fba/src/dep/scripts/toa_gp9001_func.pl -o deps/toa_gp9001_func.h
        COMMAND perl ${CMAKE_SOURCE_DIR}/fba/src/dep/scripts/neo_sprite_func.pl -o deps/neo_sprite_func.h
        COMMAND perl ${CMAKE_SOURCE_DIR}/fba/src/dep/scripts/cave_tile_func.pl -o deps/cave_tile_func.h
        COMMAND perl ${CMAKE_SOURCE_DIR}/fba/src/dep/scripts/cave_sprite_func.pl -o deps/cave_sprite_func.h
        COMMAND perl ${CMAKE_SOURCE_DIR}/fba/src/dep/scripts/psikyo_tile_func.pl -o deps/psikyo_tile_func.h
        )

##########################
# main target
##########################
add_custom_target(${PROJECT_NAME}.data
        COMMAND cp -rf ${CMAKE_SOURCE_DIR}/pfba/data/skin ${CMAKE_BINARY_DIR})
add_executable(${PROJECT_NAME}.elf ${SRC} ${CMAKE_BINARY_DIR}/deps/m68kops.c)
target_compile_options(${PROJECT_NAME}.elf PRIVATE ${FLAGS})
target_compile_options(${PROJECT_NAME}.elf PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-std=gnu++11 -fpermissive>)
target_include_directories(${PROJECT_NAME}.elf PRIVATE ${INC})
target_link_libraries(${PROJECT_NAME}.elf cross2dui ${LDFLAGS})
add_dependencies(${PROJECT_NAME}.elf ${PROJECT_NAME}.data)

#####################
# PSP2 (vita) vpk
#####################
if (BUILD_PSP2)
    add_custom_target(${PROJECT_NAME}.vpk
            DEPENDS ${PROJECT_NAME}.elf
            COMMAND rm -rf vpk && mkdir -p vpk/sce_sys
            COMMAND ${VITASDK}/bin/vita-elf-create ${PROJECT_NAME}.elf ${PROJECT_NAME}.velf
            COMMAND ${VITASDK}/bin/vita-make-fself -s -c ${PROJECT_NAME}.velf vpk/eboot.bin
            COMMAND ${VITASDK}/bin/vita-mksfoex -s TITLE_ID="VITAFBA01" "${PROJECT_NAME}" vpk/sce_sys/param.sfo
            COMMAND cp -r ${CMAKE_SOURCE_DIR}/pfba/data/skin vpk/
            COMMAND cp -r ${CMAKE_SOURCE_DIR}/pfba/data/psp2/* vpk
            COMMAND cd vpk && zip -r ../${PROJECT_NAME}-${BUILD_DATE}.vpk . && cd ..
            )
endif (BUILD_PSP2)

#####################
# PS3
#####################
if (BUILD_PS3)
    add_custom_target(${PROJECT_NAME}.ps3
            DEPENDS ${PROJECT_NAME}.elf
            COMMAND ${PSL1GHT}/bin/sprxlinker ${PROJECT_NAME}.elf
            COMMAND ${PSL1GHT}/bin/make_self ${PROJECT_NAME}.elf ${PROJECT_NAME}.ps3
            )
endif (BUILD_PS3)

#####################
# CTR (3DS) target
#####################
if (BUILD_3DS)
    set_target_properties(${PROJECT_NAME}.elf PROPERTIES LINK_FLAGS "-specs=3dsx.specs")
    add_3dsx_target(${PROJECT_NAME}.3ds "pFBA" "FBA 3DS" "Cpasjuste" pfba/data/3ds/icon.png)
    #add_cia_target(${PROJECT_NAME}.3ds pfba/data/3ds/app.rsf pfba/data/3ds/banner.png pfba/data/3ds/audio.wav "pFBA" "FBA 3DS" "Cpasjuste" pfba/data/3ds/icon.png)
endif (BUILD_3DS)

#####################
# NX (SWITCH) target
#####################
if (BUILD_NX)
    set_target_properties(${PROJECT_NAME}.elf PROPERTIES LINK_FLAGS "-specs=${DEVKITPRO}/libnx/switch.specs")
    add_custom_target(${PROJECT_NAME}.nro
            DEPENDS ${PROJECT_NAME}.elf
            COMMAND nacptool --create "pFBA" "Cpasjuste" "${PFBA_VERSION_MAJOR}.${PFBA_VERSION_MINOR}" pfba.nacp
            COMMAND elf2nro ${PROJECT_NAME}.elf ${PROJECT_NAME}.nro --icon=${CMAKE_SOURCE_DIR}/pfba/data/nx/icon.jpg --nacp=pfba.nacp
            )
    add_custom_target(${PROJECT_NAME}_release_switch.zip
            DEPENDS ${PROJECT_NAME}.nro
            COMMAND rm -rf ${CMAKE_BINARY_DIR}/release/pfba
            COMMAND mkdir -p ${CMAKE_BINARY_DIR}/release/pfba && mkdir -p ${CMAKE_BINARY_DIR}/release/pfba/roms
            COMMAND cp -f ${CMAKE_BINARY_DIR}/pfba.nro ${CMAKE_BINARY_DIR}/release/pfba/pfba.nro
            COMMAND cp -r ${CMAKE_SOURCE_DIR}/pfba/data/skin ${CMAKE_BINARY_DIR}/release/pfba/
            COMMAND cp -r ${CMAKE_SOURCE_DIR}/pfba/data/nx/skin ${CMAKE_BINARY_DIR}/release/pfba/
            COMMAND cd ${CMAKE_BINARY_DIR}/release && zip -r ../${PROJECT_NAME}-${PFBA_VERSION_MAJOR}.${PFBA_VERSION_MINOR}_switch.zip pfba && cd ${CMAKE_BINARY_DIR}
            )
endif (BUILD_NX)
