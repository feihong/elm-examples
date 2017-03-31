function getVoices() {
    return new Promise(resolve => {
        let isSupported = window.speechSynthesis !== undefined
        if (!isSupported) {
            resolve(null)
            return
        }

        let voices = speechSynthesis.getVoices()
        if (voices.length) {
            resolve(voices)
        } else {
            speechSynthesis.onvoiceschanged = () => {
                resolve(speechSynthesis.getVoices())
            }
        }
    })
}

getVoices().then(voices => {
    let node = document.getElementById('main')
    let app = Elm.Main.embed(node, {
        isSupported: voices !== null,
        initialText: "Hey hey we're the Monkees, and we like to monkey around",
        voices: voices || []
    })

    app.ports.speak.subscribe(function(args) {
        let [text, lang] = args
        let utterance = new SpeechSynthesisUtterance(text)
        utterance.lang = lang
        utterance.onstart = () => app.ports.speechStatus.send('start')
        utterance.onend = () => app.ports.speechStatus.send('end')
        speechSynthesis.speak(utterance)
    })
})
