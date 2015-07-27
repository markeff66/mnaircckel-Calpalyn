
OBJS = calpalyn.o zontem.o plot.o one.o dendro.o

diagram_that_pup: $(OBJS)
	f77  $(OBJS) -o diagram_that_pup
calpalyn.f: calpalyn.F
	# /lib/cpp <calpalyn.F >calpalyn.f
	/usr/ccs/lib/cpp <calpalyn.F >calpalyn.f
calpalyn.o: calpalyn.f
	f77  -c calpalyn.f
zontem.o: zontem.F
	f77   -c zontem.F
plot.o: plot.c
	cc -c -g plot.c -lm
one.f: one.F
	# /lib/cpp <one.F >one.f
	/usr/ccs/lib/cpp <one.F >one.f
one.o: one.f
	f77 -c  one.f
dendro.f: dendro.F
	# /lib/cpp <dendro.F >dendro.f
	/usr/ccs/lib/cpp <dendro.F >dendro.f
dendro.o: dendro.f
	f77  -c dendro.f

