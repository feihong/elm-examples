let isSupported = window.speechSynthesis !== undefined
if (isSupported) {
    let voices = speechSynthesis.getVoices()
    // If voices is empty, we need to wait for them to be loaded.
    if (voices.length === 0) {
        window.speechSynthesis.onvoiceschanged = init
    } else {
        init()
    }
} else {
    init()
}

function init() {
    let voices = isSupported ? speechSynthesis.getVoices() : []

    let app = Elm.Main.embed(document.getElementById('main'), {
        isSupported: isSupported,
        initialText: "Hey hey we're the Monkees, and we like to monkey around",
        voices: voices
    })

    app.ports.speak.subscribe(function(text) {
        let utterance = new SpeechSynthesisUtterance(text)
        utterance.onstart = function() { app.ports.speechStatus.send('start') }
        utterance.onend = function() { app.ports.speechStatus.send('end') }
        speechSynthesis.speak(utterance)
    })
}