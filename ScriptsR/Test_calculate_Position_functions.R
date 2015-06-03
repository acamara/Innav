b1x = 0.00; b1y = 2.10
b2x = 5.60; b2y = 0.40
b3x = 3.00; b3y = 4.40
b4x = 3.00; b4y = 4.40;

r1 = 3; r2=3.05; r3=2.4;

source('./ScriptsR/calculate_Position_LSQ.R');
calculate_Position_LSQ(b1x, b1y, b2x, b2y, b3x, b3y, r1, r2, r3)

source('./ScriptsR/calculate_Position_NLSQ.R');
calculate_Position_NLSQ(b1x, b1y, b2x, b2y, b3x, b3y, r1, r2, r3)

source('./ScriptsR/calculate_Position_IntersectionsCircles.R');
calculate_Position_IntersectionsCircles(b1x, b1y, b2x, b2y, b3x, b3y, r1, r2, r3)

source('./ScriptsR/calculate_Position_Centroid.R');
calculate_Position_Centroid(b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y)