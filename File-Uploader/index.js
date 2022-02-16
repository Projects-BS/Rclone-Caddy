const { exec } = require("child_process");
const PORT = process.env.PORT || 5000;

exec(`php -S 0.0.0.0:${ PORT }`, (error, stdout, stderr) => {
    if (error) {
        console.log(`[Error] ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`[Std Error] ${stderr}`);
        return;
    }
    console.log(`${stdout}`);
});
