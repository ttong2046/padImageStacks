// pad images in the folder to 16 slices and placed in a subfolder
destSlices = 16;
images2Pad = getDirectory("Select source to pad");
paddedFolder = images2Pad + "paddedTo16Slices";
if (!File.exists(paddedFolder)) {
	File.makeDirectory(paddedFolder);
}
list = getFileList(images2Pad);

setBatchMode(true);

for (i = 0; i < list.length; i++){
	if(endsWith(list[i], ".stk") || 
			endsWith(list[i], "tif") || 
			endsWith(list[i], "tiff")) {
		sourceFile = images2Pad + list[i];
		run("Bio-Formats (Windowless)", "open=[" +
				sourceFile + 
				"]");
		paddedFile = paddedFolder + 
				File.separator + 
				File.nameWithoutExtension + 
				"paddedTo" + 
				destSlices + 
				"Slices.tif";
		padToSlices(destSlices);
		saveAs("Tiff", paddedFile);
		run("Close All");

	}
}

setBatchMode(false);
exit("Padded all stacks to " + destSlices);

function padToSlices(destSlices){
	Stack.getDimensions(width, height, channels, slices, frames);
	if (slices < destSlices) {
		Stack.setSlice(slices);
		slices2Add = 16 - slices;
		for (i = 0; i < slices2Add; i++) {
			run("Add Slice");
		}
	}
}
