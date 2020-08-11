all:	pibrot

PIS=pi2 pi3 pi4 pi5 pi1
LDFLAGS+=-L$(SDKSTAGE)/opt/vc/lib/ -lbrcmGLESv2 -lbrcmEGL -lopenmaxil -lbcm_host -lvcos -lvchiq_arm -lpthread -lrt -lm -L../libs/ilclient -L../libs/vgfont
INCLUDES+=-I$(SDKSTAGE)/opt/vc/include/ -I$(SDKSTAGE)/opt/vc/include/interface/vcos/pthreads -I$(SDKSTAGE)/opt/vc/include/interface/vmcs_host/linux -I./ -I../libs/ilclient -I../libs/vgfont
CCFLAGS+= -DRASPI -mfloat-abi=hard -mfpu=vfp -ffast-math -O3

.PHONY:	clean

pibrot:	pibrot.c communication.c egl_utils.c fractal.c multi_tex.c
	mkdir -p bin
	mpicc -O3 $(CCFLAGS) $(INCLUDES) $(LDFLAGS) ogl_utils.c rectangle_gl.c renderer.c communication.c egl_utils.c image_gl.c lodepng.c cursor_gl.c start_menu_gl.c exit_menu_gl.c fractal.c multi_tex.c -o bin/pibrot

run: copy
	cd $(HOME) && mpirun --host 10.99.86.101,10.99.86.102,10.99.86.103 -n 3 ./pibrot && cd PiBrot 

copy:
	@for pi in $(PIS);\
	do \
		scp ./bin/pibrot $$pi:~/; \
	done

clean:
	rm -rf *.o
