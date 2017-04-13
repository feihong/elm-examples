emojione.imageType = 'svg'
let shortnames = emojione.shortnames.split('|')

// Use the EmojiOne library to generate a random emoji entry.
function getRandomEmoji() {
    let len = shortnames.length 
    let index = Math.floor(Math.random() * len)
    let shortname = shortnames[index]
    let div = document.createElement('div')
    div.innerHTML = emojione.shortnameToImage(shortname)
    let obj = div.firstChild
    let result =  {
        unicode: obj.standby,
        shortname: shortname,
        url: obj.data
    }
    return JSON.stringify(result)
}

let app = Elm.Main.embed(document.getElementById('main'))

// Respond to emoji requests.
app.ports.requestEmoji.subscribe(shortname => {
    let result = getRandomEmoji()
    app.ports.receivedEmoji.send(result)
})