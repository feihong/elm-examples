const fs = require('fs')
const pathlib = require('path')
const join = pathlib.join

const promisify = require('es6-promisify')
const _readFile = promisify(fs.readFile)
const readFile = path => _readFile(path, 'utf8')
const readdir = promisify(fs.readdir)
const Koa = require('koa')
const pug = require('pug')
const stylus = require('stylus')
const compiler = require('node-elm-compiler')


const app = new Koa()
const rootDir = __dirname
const templateDir = join(rootDir, 'templates')


// Log each request to console.
app.use(async (ctx, next) => {
  let req = ctx.request
  console.log(`${req.method} - ${ctx.url}`)
  await next()
})

// Map url to file path, return 404 response if path doesn't exist.
app.use(async (ctx, next) => {
  let url = ctx.url
  if (url === '/') {
    url = ''
  }
  let path = join(rootDir, url)

  let stats = await getStats(path)
  if (stats === null) {
    ctx.response.status = 404
    ctx.body = `File not found: ${path}`
    return
  }

  ctx.state.path = path
  ctx.state.stats = stats
  await next()
})

// If path points to directory, try to render an index page. If there is no
// index page, just show the contents of the directory.
app.use(async (ctx, next) => {
  let {path, stats} = ctx.state

  if (stats.isDirectory()) {
    let indexFile = join(path, 'index.html')
    if (await isFile(indexFile)) {
      ctx.body = await readFile(indexFile)
      return
    }

    indexFile = join(path, 'index.pug')
    if (await isFile(indexFile)) {
      ctx.body = await renderTemplate(indexFile)
      return
    }

    ctx.body = await renderDirectory(ctx.url, path)
    return
  }
  await next()
})

// If path points to a Stylus stylesheet, render it as CSS.
app.use(async (ctx, next) => {
  let {path} = ctx.state
  let ext = pathlib.extname(path)
  if (ext === '.styl') {
    ctx.response.type = 'css'
    ctx.body = await compileStylesheet(path)
    return
  }
  await next()
})

// If path points to an Elm source file, render it as JS.
app.use(async (ctx, next) => {
  let {path} = ctx.state
  let ext = pathlib.extname(path)
  if (ext === '.elm') {
    ctx.response.type = 'javascript'
    ctx.body = await compileElm(path)
    return
  }
  await next()
})

// Just serve the file as-is.
app.use(async (ctx, next) => {
  let {path} = ctx.state
  ctx.response.body = await readFile(path)
})

function getStats(path) {
  return new Promise(resolve => {
    fs.stat(path, (err, stats) => {
      if (err) {
        // Unlike fs.stat, will resolve to null instead of throwing error.
        resolve(null)
      } else {
        resolve(stats)
      }
    })
  })
}

// Return true if path points to a file.
async function isFile(path) {
  let stats = await getStats(path)
  return (stats === null) ? false : stats.isFile()
}

// Return true if path points to a directory.
async function isDirectory(path) {
  let stats = await getStats(path)
  return (stats === null) ? false : stats.isDirectory()
}

async function renderTemplate(pugFile) {
  let text = await readFile(pugFile)
  return pug.render(text, {filename: pugFile, basedir: templateDir})
}

async function compileStylesheet(stylFile) {
  console.log('Compiling %s', stylFile)
  let text = await readFile(stylFile)
  return new Promise((resolve, reject) => {
    stylus(text)
      .set('filename', stylFile)
      .render((err, css) => {
        if (err) {
          reject(err)
        } else {
          resolve(css)
        }
      })
  })
}

async function compileElm(elmFile) {
  console.log('Compiling %s', elmFile)
  try {
    let data = await compiler.compileToString(
      [elmFile], {yes: true, cwd: pathlib.dirname(elmFile)})
    return data.toString()
  } catch (err) {
    let text = err.toString().replace(/`/g, '\\`')
    return 'console.error(`' + text + '`)'
  }
}

const directoryTemplate = pug.compile(`
h1= title
ul
  each file in files
    li
      a(href=file.url)= file.name
`)

const ignored_names = ['elm-stuff', 'node_modules']

async function renderDirectory(url, dirPath) {
  let files = await readdir(dirPath)
  // Ignore hidden files and package directories.
  files = files.filter(x => !x.startsWith('.') && !ignored_names.includes(x))
  files = await Promise.all(
    files.map(async (name) => {
      let isDir = await isDirectory(join(dirPath, name))
      let suffix = isDir ? '/' : ''
      return {
        isDir: isDir,
        name: name + suffix,
        url: join(url, name) + suffix,
      }
    })
  )
  // Directories should come first.
  files.sort((a, b) => b.isDir - a.isDir)
  return directoryTemplate({title: dirPath, files: files})
}


app.listen(8000)
