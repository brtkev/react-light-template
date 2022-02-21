#!/usr/bin/env node

const { exec } = require('child_process');
const utils = require('./utils.js');

const newDirName = process.argv[2]
if(newDirName === undefined){
    console.log("you need a name bitch");
    throw "Error: no name";
}


const fs = require('fs');
const path = require('path');

const templateDir = path.join(__filename, '../../template');
const newDir = path.resolve(process.cwd(), newDirName);

fs.mkdir(newDir, (err) => {if(err && err.errno !== -4075) throw err });


utils.moveFilesTo(newDir, templateDir);
utils.changePackageName(newDir, newDirName);



// const { exec, spawn } = require("child_process");

// currCommand = spawn('npm', ['up'], { 'cwd' : newDir});

// currCommand.stdout.on('data', (data) => {
// console.log(`stdout: ${data}`);
// });

// currCommand.stderr.on('data', (data) => {
// console.error(`stderr: ${data}`);
// });

// currCommand.on('close', (code) => {
// console.log(`child process exited with code ${code}`);
// });


// currCommand = spawn('npm', ['up'], { 'cwd' : newDir});

// currCommand.stdout.on('data', (data) => {
// console.log(`stdout: ${data}`);
// });

// currCommand.stderr.on('data', (data) => {
// console.error(`stderr: ${data}`);
// });

// currCommand.on('close', (code) => {
// console.log(`child process exited with code ${code}`);
// });
  

// // exec("cd ../.. && npm rm react-light-template  && npm up ", (error, stdout, stderr) => {
// //     if (error) {
// //         console.log(`error: ${error.message}`);
// //         return;
// //     }
// //     if (stderr) {
// //         console.log(`stderr: ${stderr}`);
// //         return;
// //     }
// //     console.log(`stdout: ${stdout}`);
// // });

