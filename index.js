const fs = require('fs');
const path = require('path');	
const dir = path.join(__dirname, '/template');
const newDir = path.resolve(process.cwd(), '../..');

const moveFilesTo = () => {
	let listDir = [ ...fs.readdirSync(dir).map(file =>  `${dir}/${file}` )];

	while(listDir.length > 0){
		let file = listDir.shift();
		if(fs.lstatSync(file).isDirectory()){
			fs.mkdir(file.replace(dir, newDir), (err) => {if(err && err.errno !== -4075) throw err });
			listDir = [...listDir, ...fs.readdirSync(file).map(nFile =>  `${file}/${nFile}` )]		
		}else{
			try{
				fs.copyFileSync(file, file.replace(dir, newDir), fs.constants.COPYFILE_EXCL);
			}catch(e){
				if (e.errno !== -4075) console.log(e);
			}
		}
	}

}

const preSetup = () => {
	let packagePath = './template/package.json';
	let data = JSON.parse( fs.readFileSync(packagePath, 'utf8'));
	data.name = newDir.split('\\').pop();

	fs.writeFileSync(packagePath, JSON.stringify(data), 'utf8');

	console.log(data.name);
}

preSetup();
moveFilesTo();

const { exec, spawn } = require("child_process");

currCommand = spawn('ls',['-lh'] ,{ 'cwd' : newDir});

currCommand.stdout.on('data', (data) => {
console.log(`stdout: ${data}`);
});

currCommand.stderr.on('data', (data) => {
console.error(`stderr: ${data}`);
});

currCommand.on('close', (code) => {
console.log(`child process exited with code ${code}`);
});
  

// exec("cd ../.. && npm rm react-light-template  && npm up ", (error, stdout, stderr) => {
//     if (error) {
//         console.log(`error: ${error.message}`);
//         return;
//     }
//     if (stderr) {
//         console.log(`stderr: ${stderr}`);
//         return;
//     }
//     console.log(`stdout: ${stdout}`);
// });

