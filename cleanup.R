name <- system('uname -n',intern=T) 
print(name)
fname = sprintf("/data/ziz/flaxman/cleanup-%s",name)
if(!file.exists(fname)) {
	system("ls /data/localhost/not-backed-up/flaxman/file* | wc -l")
	system("rm /data/localhost/not-backed-up/flaxman/file*")
	write.csv(1,fname)
} else {
	system(sprintf("du -ah /data/localhost/not-backed-up/flaxman/ | tail -n 1 >> /data/ziz/flaxman/cleanup-%s",name))
	print(sprintf("Already cleaned up %s",name))
}
