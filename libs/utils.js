const fs = require('fs');
const path = require('path');

const moveFilesTo = (newDir, templateDir) => {
	let listDir = [ ...fs.readdirSync(templateDir).map(file =>  `${templateDir}/${file}` )];

	while(listDir.length > 0){
		let file = listDir.shift();
		if(fs.lstatSync(file).isDirectory()){
			fs.mkdir(file.replace(templateDir, newDir), (err) => {if(err && err.errno !== -4075) throw err });
			listDir = [...listDir, ...fs.readdirSync(file).map(nFile =>  `${file}/${nFile}` )]		
		}else{
			try{
				fs.copyFileSync(file, file.replace(templateDir, newDir), fs.constants.COPYFILE_EXCL);
			}catch(e){
				if (e.errno !== -4075) console.log(e);
			}
		}
	}

}

const changePackageName = (newDir, name) => {
    let pkgPath = path.resolve(newDir, 'package.json');
    let pkgData = JSON.parse( fs.readFileSync(pkgPath, 'utf8'));
    pkgData.name = name;
    fs.writeFileSync(pkgPath, JSON.stringify(pkgData), 'utf8');
}

module.exports = {
    moveFilesTo, changePackageName
}