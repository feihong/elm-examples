console.log(`Using EmojiOne version ${emojione.emojiVersion}`)

emojione.imagePathPNG = emojione.imagePathPNG.replace('/64/', '/128/')
let shortnames = emojione.shortnames.split('|')

// Use the EmojiOne library to generate a random emoji entry.
function getRandomEmoji() {
    let len = shortnames.length 
    let index = Math.floor(Math.random() * len)
    let shortname = shortnames[index]
    return getEmoji(shortname)
}

function getEmoji(shortname) {
    let div = document.createElement('div')
    div.innerHTML = emojione.shortnameToImage(shortname)
    let img = div.firstChild
    let result =  {
        unicode: img.alt,
        shortname: img.title,
        url: img.src
    }
    return result
}

let app = Elm.Main.embed(document.getElementById('main'))

// Respond to emoji requests.
app.ports.requestEmoji.subscribe(shortname => {
    let result = getRandomEmoji()
    app.ports.receivedEmoji.send(result)
})