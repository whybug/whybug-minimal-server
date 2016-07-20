var JSONStream = require('JSONStream');
var fs = require('fs');
var es = require('event-stream');
var path = require('path');
const streamsql = require('streamsql');

const db = streamsql.connect({
    driver: 'sqlite3',
    filename: '/Users/apple/Library/Application Support/Dash/Stack Overflow/PHP Offline/PHP_Offline.docset/Contents/Resources/docSet.dsidx',
});

var posts = db.table('posts', {});
var inStream = posts.createReadStream("SELECT answer.Id as externalSolutionId, question.body AS errorDescription, answer.body AS solutionDescription FROM posts question LEFT JOIN posts answer ON question.AcceptedAnswerId = answer.id WHERE question.PostTypeId = 1 AND answer.Id NOT NULL");
// var outStream = fs.createWriteStream(path.normalize('data/stackoverflow-php.formatted.json'));

inStream
    // .pipe(JSONStream.parse('*'))
    .pipe(JSONStream.stringify("", "\n", ""))
    // .pipe(toBulk)
    // .pipe(outStream)
    .pipe(process.stdout)
    .on('error', function (err){
        console.log('error: ', err);
    });

