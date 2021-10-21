const fs = require('fs');
const path = require('path');	
const dir = path.join(__dirname, '/template');
const newDir = path.resolve(process.cwd());


const moveFilesTo = () => {
	let listDir = [ ...fs.readdirSync(dir).map(file =>  `${dir}/${file}` )];
	return

	while(listDir.length > 0){
		let file = listDir.shift();
		if(fs.lstatSync(file).isDirectory()){
			fs.mkdir(file.replace(dir, newDir), (err) => {if(err && err.errno !== -4075) throw err });
			listDir = [...listDir, ...fs.readdirSync(file).map(nFile =>  `${file}/${nFile}` )]		
		}else{
			fs.copyFileSync(file, file.replace(dir, newDir));
		}
	}

}

moveFilesTo();

