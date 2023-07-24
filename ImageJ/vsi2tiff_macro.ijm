// 230724

mouse="PZ99"
vsi_file="PZ99_1"

num_groups = 18
first_num = 3

run("Viewer", "open=E:/histology/paula/"+mouse+"/"+vsi_file+".vsi group10_level1 group11_level1 group12_level1 group13_level1 group14_level1 group15_level1 group16_level1 group17_level1 group18_level1 group3_level1 group4_level1 group5_level1 group6_level1 group7_level1 group8_level1 group9_level1");	
for (i = first_num; i < (num_groups+1); i++) {
	selectWindow("PZ99_1.vsi Group:"+i+" Level:1");
	run("Split Channels");
	selectWindow("C1-"+vsi_file+".vsi Group:"+i+" Level:1");
	saveAs("Tiff", "E:/histology/paula/"+mouse+"/C1_"+mouse+"_"+i+".tif");
	selectWindow("C2-"+vsi_file+".vsi Group:"+i+" Level:1");
	saveAs("Tiff", "E:/histology/paula/"+mouse+"/C2_"+mouse+"_"+(i+first_num)+".tif");
	close("*");
}
