startY=30;

pitch=1.2;
count=0;
for count in range(0, 16):
	print "editPin -snap TRACK -side INSIDE -layer 4 -assign 0 " + str(startY-count*pitch) + "  -pin phase\[" +str(count) + "\]";
